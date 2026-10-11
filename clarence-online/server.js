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
const rooms = new Map(); // code -> { host: ws, guest: ws|null }

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
  if (other) { send(other, { t: 'closed', why: why || 'friend left' }); other.room = null; other.role = null; }
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
    } else if (m.t === 'leave') {
      leave(ws, 'friend left');
    } else if (m.t === 'ping') {
      send(ws, { t: 'pong' });
    }
  });

  ws.on('close', () => leave(ws, 'friend disconnected'));
  ws.on('error', () => leave(ws, 'connection error'));
});

// Detect dead sockets (also keeps free hosts' proxies from idling the connection out).
setInterval(() => {
  wss.clients.forEach((ws) => {
    if (!ws.isAlive) return ws.terminate();
    ws.isAlive = false;
    try { ws.ping(); } catch (e) { /* ignore */ }
  });
}, 25000);

server.listen(PORT, () => console.log('Clarence Online listening on :' + PORT));
