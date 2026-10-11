// Clarence Online - room relay + static file server (one process, one port).
// Rooms hold exactly two players (host + guest). The server never interprets
// game data: it forwards opaque strings from one player to the other.
'use strict';
const http = require('http');
const fs = require('fs');
const path = require('path');
const { WebSocketServer } = require('ws');

const PORT = process.env.PORT || 8080;
const WEB_DIR = path.join(__dirname, 'web');
const MAX_ROOMS = 300;
const MAX_MSG_BYTES = 512;
const MAX_MSGS_PER_SEC = 80;
const CODE_CHARS = 'BCDFGHJKLMNPQRSTVWXZ'; // no vowels -> no accidental words

const MIME = {
  '.html': 'text/html; charset=utf-8', '.js': 'text/javascript', '.css': 'text/css',
  '.swf': 'application/x-shockwave-flash', '.xml': 'application/xml', '.json': 'application/json',
  '.png': 'image/png', '.ico': 'image/x-icon', '.txt': 'text/plain'
};

const server = http.createServer((req, res) => {
  const urlPath = decodeURIComponent((req.url || '/').split('?')[0]);
  if (urlPath === '/healthz') { res.writeHead(200); return res.end('ok'); }
  if (urlPath === '/leaderboard') {
    const top = Object.values(ratings).filter((r) => r.games > 0)
      .sort((a, b) => b.elo - a.elo).slice(0, 20)
      .map((r) => ({ name: r.name, elo: r.elo, tier: tierOf(r.elo), games: r.games, wins: r.wins, losses: r.losses }));
    res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
    return res.end(JSON.stringify(top));
  }
  let rel = urlPath === '/' ? '/index.html' : urlPath;
  const file = path.normalize(path.join(WEB_DIR, rel));
  if (!file.startsWith(WEB_DIR)) { res.writeHead(403); return res.end('forbidden'); }
  fs.readFile(file, (err, data) => {
    if (err) { res.writeHead(404); return res.end('not found'); }
    res.writeHead(200, { 'Content-Type': MIME[path.extname(file).toLowerCase()] || 'application/octet-stream' });
    res.end(data);
  });
});

const wss = new WebSocketServer({ server, maxPayload: MAX_MSG_BYTES });
const rooms = new Map(); // code -> { host: ws, guest: ws|null, rk?: ranked info }

// ------------------------------------------------------------------ ranked ladder
// Ratings live in ratings.json (best effort). NOTE: free hosts have an ephemeral disk, so this file can
// disappear on restart/redeploy. The web page keeps a copy of each player's rating in the browser and
// re-sends it when queueing; the server re-seeds from it when it has no record of that player.
const RATINGS_FILE = process.env.RATINGS_FILE || path.join(__dirname, 'ratings.json');
const START_ELO = 800;
const TIERS = ['BRONZE', 'SILVER', 'GOLD', 'PLATINUM', 'MYTHRIL', 'ONYX', 'COSMIC'];
const TIER_MIN = [0, 1000, 1200, 1400, 1600, 1800, 2000]; // lowest -> highest
function tierOf(elo) { let t = 0; for (let i = 0; i < TIER_MIN.length; i++) if (elo >= TIER_MIN[i]) t = i; return TIERS[t]; }
let ratings = {};
try { ratings = JSON.parse(fs.readFileSync(RATINGS_FILE, 'utf8')); } catch (e) { ratings = {}; }
let saveTimer = null;
function saveRatings() {
  if (saveTimer) return;
  saveTimer = setTimeout(() => { saveTimer = null; fs.writeFile(RATINGS_FILE, JSON.stringify(ratings), () => {}); }, 2000);
}
function cleanName(n) {
  n = String(n == null ? '' : n).replace(/[\u0000-\u001f|<>&"']/g, '').trim().slice(0, 16);
  return n || 'Player';
}
function expected(a, b) { return 1 / (1 + Math.pow(10, (b - a) / 400)); }

const queue = []; // { ws, id, name, elo, since }
function removeFromQueue(ws) {
  const i = queue.findIndex((q) => q.ws === ws);
  if (i >= 0) queue.splice(i, 1);
}
// Pair waiting players. The acceptable rating gap starts at 100 and widens by 40 per second waited,
// so with only a few players online anyone still gets matched within a few seconds.
function tryMatch() {
  const now = Date.now();
  for (;;) {
    let best = null;
    for (let i = 0; i < queue.length; i++) {
      for (let j = i + 1; j < queue.length; j++) {
        const a = queue[i], b = queue[j];
        if (a.id === b.id) continue;
        const waited = Math.max(now - a.since, now - b.since) / 1000;
        const diff = Math.abs(a.elo - b.elo);
        if (diff <= 100 + 40 * waited && (!best || diff < best.diff)) best = { a, b, diff };
      }
    }
    if (!best) return;
    pairRanked(best.a, best.b);
  }
}
function pairRanked(x, y) {
  const a = x.since <= y.since ? x : y; // longest waiting = host
  const b = a === x ? y : x;
  removeFromQueue(a.ws); removeFromQueue(b.ws);
  const code = newCode();
  if (!code || rooms.size >= MAX_ROOMS) {
    send(a.ws, { t: 'err', msg: 'Server is full, try again later' });
    send(b.ws, { t: 'err', msg: 'Server is full, try again later' });
    return;
  }
  rooms.set(code, { host: a.ws, guest: b.ws, rk: { hid: a.id, gid: b.id, reports: { h: null, g: null }, done: false, timer: null } });
  a.ws.room = code; a.ws.role = 'host';
  b.ws.room = code; b.ws.role = 'guest';
  send(a.ws, { t: 'paired', role: 'host', ranked: true, opp: { name: b.name, elo: b.elo } });
  send(b.ws, { t: 'paired', role: 'guest', ranked: true, opp: { name: a.name, elo: a.elo } });
}
function finalizeRanked(room, winnerRole, reason) {
  const rk = room.rk;
  if (!rk || rk.done) return;
  rk.done = true;
  if (rk.timer) { clearTimeout(rk.timer); rk.timer = null; }
  const rh = ratings[rk.hid], rg = ratings[rk.gid];
  if (!rh || !rg) return;
  const ea = expected(rh.elo, rg.elo);
  const sh = winnerRole === 'h' ? 1 : 0;
  const kh = rh.games < 10 ? 40 : 24; // bigger swings for the first 10 games
  const kg = rg.games < 10 ? 40 : 24;
  const nh = Math.max(0, Math.round(rh.elo + kh * (sh - ea)));
  const ng = Math.max(0, Math.round(rg.elo + kg * ((1 - sh) - (1 - ea))));
  const dh = nh - rh.elo, dg = ng - rg.elo;
  rh.elo = nh; rh.games++; if (sh) rh.wins++; else rh.losses++;
  rg.elo = ng; rg.games++; if (sh) rg.losses++; else rg.wins++;
  saveRatings();
  send(room.host, { t: 'rank', elo: nh, games: rh.games, delta: dh, won: !!sh, reason });
  send(room.guest, { t: 'rank', elo: ng, games: rg.games, delta: dg, won: !sh, reason });
}
// Someone left a ranked room before the result was settled: the leaver loses,
// unless the opponent already reported a result (then that report is used).
function settleOnLeave(room, leaverRole) {
  if (!room.rk || room.rk.done) return;
  const opp = leaverRole === 'h' || leaverRole === 'host' ? 'g' : 'h';
  const rep = room.rk.reports[opp];
  finalizeRanked(room, rep || opp, 'left');
}

function newCode() {
  for (let tries = 0; tries < 50; tries++) {
    let c = '';
    for (let i = 0; i < 4; i++) c += CODE_CHARS[Math.floor(Math.random() * CODE_CHARS.length)];
    if (!rooms.has(c)) return c;
  }
  return null;
}
function send(ws, obj) { if (ws && ws.readyState === 1) ws.send(JSON.stringify(obj)); }
function peerOf(ws) {
  const r = rooms.get(ws.room);
  if (!r) return null;
  return ws.role === 'host' ? r.guest : r.host;
}
function leave(ws, why) {
  if (!ws.room) return;
  const r = rooms.get(ws.room);
  const code = ws.room;
  ws.room = null;
  if (!r) return;
  const other = ws.role === 'host' ? r.guest : r.host;
  if (r.rk && !r.rk.done) settleOnLeave(r, ws.role);
  if (other) { send(other, { t: 'closed', why: why || 'friend left' }); other.room = null; other.role = null; }
  if (r.rk && r.rk.timer) clearTimeout(r.rk.timer);
  rooms.delete(code);
}

wss.on('connection', (ws) => {
  ws.isAlive = true;
  ws.room = null; ws.role = null;
  ws.bucket = MAX_MSGS_PER_SEC; ws.bucketAt = Date.now();
  ws.on('pong', () => { ws.isAlive = true; });

  ws.on('message', (raw) => {
    ws.isAlive = true;
    const now = Date.now();
    ws.bucket = Math.min(MAX_MSGS_PER_SEC, ws.bucket + ((now - ws.bucketAt) / 1000) * MAX_MSGS_PER_SEC);
    ws.bucketAt = now;
    if (ws.bucket < 1) return; // drop flood
    ws.bucket -= 1;

    let m; try { m = JSON.parse(raw.toString()); } catch (e) { return; }
    if (!m || typeof m.t !== 'string') return;

    if (m.t === 'create') {
      if (ws.room) leave(ws);
      if (rooms.size >= MAX_ROOMS) return send(ws, { t: 'err', msg: 'Server is full, try again later' });
      const code = newCode();
      if (!code) return send(ws, { t: 'err', msg: 'Could not allocate a room' });
      rooms.set(code, { host: ws, guest: null });
      ws.room = code; ws.role = 'host';
      send(ws, { t: 'created', code });
    } else if (m.t === 'join') {
      const code = String(m.code || '').toUpperCase().trim();
      const r = rooms.get(code);
      if (!r) return send(ws, { t: 'err', msg: 'No room with that code' });
      if (r.guest) return send(ws, { t: 'err', msg: 'That room is already full' });
      if (ws.room) leave(ws);
      r.guest = ws; ws.room = code; ws.role = 'guest';
      send(r.host, { t: 'paired', role: 'host' });
      send(ws, { t: 'paired', role: 'guest', code });
    } else if (m.t === 'm') {
      if (typeof m.d !== 'string' || m.d.length > 200) return;
      const other = peerOf(ws);
      if (other) send(other, { t: 'm', d: m.d });
    } else if (m.t === 'queue') {
      if (ws.room) leave(ws, 'friend left');
      removeFromQueue(ws);
      const id = String(m.id || '');
      if (!/^[A-Za-z0-9-]{8,64}$/.test(id)) return send(ws, { t: 'err', msg: 'Bad player id' });
      const name = cleanName(m.name);
      let rec = ratings[id];
      if (!rec) {
        const claimed = Number(m.elo);
        rec = { elo: Number.isFinite(claimed) ? Math.max(0, Math.min(2400, Math.round(claimed))) : START_ELO, games: 0, wins: 0, losses: 0, name };
        ratings[id] = rec;
      }
      rec.name = name;
      queue.push({ ws, id, name, elo: rec.elo, since: Date.now() });
      send(ws, { t: 'queued' });
      tryMatch();
    } else if (m.t === 'qcancel') {
      removeFromQueue(ws);
    } else if (m.t === 'rresult') {
      const r = rooms.get(ws.room);
      if (!r || !r.rk || r.rk.done) return;
      if (m.w !== 'h' && m.w !== 'g') return;
      const role = ws.role === 'host' ? 'h' : 'g';
      if (r.rk.reports[role]) return;
      r.rk.reports[role] = m.w;
      const rep = r.rk.reports;
      if (rep.h && rep.g) {
        if (rep.h === rep.g) finalizeRanked(r, rep.h, 'agreed');
        else { // the two clients disagree: no rating change
          r.rk.done = true;
          if (r.rk.timer) clearTimeout(r.rk.timer);
          const rh = ratings[r.rk.hid], rg = ratings[r.rk.gid];
          send(r.host, { t: 'rank', elo: rh ? rh.elo : START_ELO, games: rh ? rh.games : 0, delta: 0, won: false, reason: 'disputed' });
          send(r.guest, { t: 'rank', elo: rg ? rg.elo : START_ELO, games: rg ? rg.games : 0, delta: 0, won: false, reason: 'disputed' });
        }
      } else if (!r.rk.timer) {
        // the other side never reported (crashed/quit): trust the one report after 20s
        r.rk.timer = setTimeout(() => { r.rk.timer = null; const only = rep.h || rep.g; if (only) finalizeRanked(r, only, 'single report'); }, 20000);
      }
    } else if (m.t === 'leave') {
      leave(ws, 'friend left');
    } else if (m.t === 'ping') {
      send(ws, { t: 'pong' });
    }
  });

  ws.on('close', () => { removeFromQueue(ws); leave(ws, 'friend disconnected'); });
  ws.on('error', () => { removeFromQueue(ws); leave(ws, 'friend disconnected'); });
});

// Detect dead sockets (also keeps free hosts' proxies from idling the connection out).
setInterval(tryMatch, 2000);
setInterval(() => {
  wss.clients.forEach((ws) => {
    if (!ws.isAlive) return ws.terminate();
    ws.isAlive = false;
    try { ws.ping(); } catch (e) { /* ignore */ }
  });
}, 25000);

server.listen(PORT, () => console.log('Clarence Online listening on :' + PORT));
