package
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.media.SoundMixer;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFieldAutoSize;

   /**
    * Online versus layer for the Clarence mini-games.
    *
    * Transport: the HTML page owns the WebSocket. Flash talks to it through
    * ExternalInterface using plain strings (no JSON needed):
    *   Flash -> page : mpSend(payload)         payload = "kind|a|b"
    *   page  -> Flash: mpRecv("status", text)  /  mpRecv("msg", payload)
    *
    * Results are arbitrated by the HOST so both screens always agree.
    */
   public class MP
   {
      public static var active:Boolean = false;
      public static var mpFinal:Boolean = false;
      public static var isHost:Boolean = false;
      public static var linked:Boolean = false;
      public static var game:int = 0;
      public static var resolved:Boolean = false;
      public static var claimed:Boolean = false;
      public static var myWins:int = 0;
      public static var oppWins:int = 0;
      public static var oppY:Number = 0;
      public static var oppRot:Number = 0;
      public static var oppProg:int = -1;
      public static var cur:Object = null;
      public static var diff:int = 1;
      public static var draw:Boolean = false;
      public static var myMiss:int = 0;
      public static var myHit:int = 0;
      public static var oppMiss:int = 0;
      public static var oppHit:int = 0;

      /** Rock Battle difficulty: notes per second for Easy / Normal / Hard. Tweak freely. */
      public static var NPS:Array = [1.5, 2.5, 4.0];
      public static var DIFF_NAMES:Array = ["EASY", "NORMAL", "HARD"];
      /** Rock Battle song length in seconds. */
      public static var DURATION:Number = 40;

      private static var _r:MovieClip = null;
      private static var inited:Boolean = false;
      private static var bridgeOk:Boolean = false;
      private static var statusText:String = "Not connected";
      private static var myReady:Boolean = false;
      private static var oppReady:Boolean = false;
      private static var readyFn:Function = null;
      private static var bkDeDonde:String = "";
      private static var bkDireccion:String = "";
      private static var bkSaved:Boolean = false;
      private static var fc:int = 0;
      private static var note:String = "";
      private static var seedState:Number = 1;
      private static var myFin:Boolean = false;
      private static var oppFin:Boolean = false;
      private static var oppFinM:int = 0;
      private static var oppFinH:int = 0;
      private static var diffBtns:Array = [];

      private static var btn:Sprite;
      private static var btnTxt:TextField;
      private static var lobby:Sprite;
      private static var lobbyStatus:TextField;
      private static var lobbyScore:TextField;
      private static var lobbyHint:TextField;
      private static var gameBtns:Array = [];
      private static var hud:TextField;
      private static var banner:TextField;
      private static var forfeit:Sprite;

      private static var NAMES:Array = ["", "STICKER RACE", "MERCILESS DUEL", "CRYPTO RACE", "CLAW RACE", "ROCK BATTLE"];
      private static var DESCS:Array = [
         "",
         "First to fit all 10 stickers in the frame wins",
         "Mash the combo - first to charge and fire wins",
         "Survive the course - crash and you lose",
         "First to grab the prize wins",
         "Keep your needle out of the red - last rocker wins"
      ];

      // ------------------------------------------------------------ setup
      public static function init(r:MovieClip) : void
      {
         _r = r;
         if(inited)
         {
            return;
         }
         inited = true;
         try
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.addCallback("mpRecv", recv);
               bridgeOk = true;
               ExternalInterface.call("mpFlashReady");
            }
         }
         catch(err:Error)
         {
            bridgeOk = false;
         }
         buildButton();
         buildLobby();
         buildHud();
         r.stage.addEventListener(Event.ENTER_FRAME, tick);
      }

      private static function fmt(size:int, color:uint, bold:Boolean = true, align:String = "left") : TextFormat
      {
         var f:TextFormat = new TextFormat();
         f.font = "_sans";
         f.size = size;
         f.color = color;
         f.bold = bold;
         f.align = align;
         return f;
      }

      private static function makeText(w:Number, h:Number, f:TextFormat) : TextField
      {
         var t:TextField = new TextField();
         t.defaultTextFormat = f;
         t.width = w;
         t.height = h;
         t.selectable = false;
         t.mouseEnabled = false;
         t.multiline = true;
         t.wordWrap = true;
         return t;
      }

      private static function makeBtn(label:String, id:String, x:Number, y:Number, w:Number, h:Number, size:int) : Sprite
      {
         var s:Sprite = new Sprite();
         s.graphics.beginFill(0x1B6E2F);
         s.graphics.lineStyle(2, 0xFFFFFF);
         s.graphics.drawRoundRect(0, 0, w, h, 10, 10);
         s.graphics.endFill();
         s.x = x;
         s.y = y;
         s.name = id;
         s.buttonMode = true;
         s.mouseChildren = false;
         var t:TextField = makeText(w, h, fmt(size, 0xFFFFFF, true, "center"));
         t.text = label;
         t.y = (h - (size + 6)) / 2;
         s.addChild(t);
         s.addEventListener(MouseEvent.CLICK, onClick);
         return s;
      }

      private static function paintBtn(sp:Sprite, w:Number, h:Number, fill:uint) : void
      {
         sp.graphics.clear();
         sp.graphics.beginFill(fill);
         sp.graphics.lineStyle(2, 0xFFFFFF);
         sp.graphics.drawRoundRect(0, 0, w, h, 10, 10);
         sp.graphics.endFill();
      }

      private static function buildButton() : void
      {
         btn = makeBtn("ONLINE VERSUS", "open", 6, 368, 120, 26, 12);
         btn.visible = false;
         _r.addChild(btn);
      }

      private static function buildLobby() : void
      {
         lobby = new Sprite();
         lobby.graphics.beginFill(0x0E1A24, 0.97);
         lobby.graphics.drawRect(0, 0, 600, 400);
         lobby.graphics.endFill();
         lobby.visible = false;

         var title:TextField = makeText(600, 40, fmt(28, 0xFFE24A, true, "center"));
         title.text = "ONLINE VERSUS";
         title.y = 10;
         lobby.addChild(title);

         lobbyStatus = makeText(560, 40, fmt(14, 0xFFFFFF, true, "center"));
         lobbyStatus.x = 20;
         lobbyStatus.y = 52;
         lobby.addChild(lobbyStatus);

         lobbyScore = makeText(560, 24, fmt(16, 0x7FE0FF, true, "center"));
         lobbyScore.x = 20;
         lobbyScore.y = 92;
         lobby.addChild(lobbyScore);

         var i:int = 1;
         var b:Sprite;
         var d:TextField;
         while(i < 6)
         {
            b = makeBtn(NAMES[i], "g" + i, 150, 122 + (i - 1) * 46, 300, 28, 15);
            lobby.addChild(b);
            gameBtns.push(b);
            d = makeText(300, 16, fmt(10, 0xB8C7D1, false, "center"));
            d.x = 150;
            d.y = 122 + (i - 1) * 46 + 28;
            d.text = DESCS[i];
            lobby.addChild(d);
            i++;
         }

         var dl:TextField = makeText(140, 18, fmt(11, 0xFFE24A, true, "center"));
         dl.x = 460;
         dl.y = 128;
         dl.text = "ROCK DIFFICULTY";
         lobby.addChild(dl);
         var di:int = 0;
         var db:Sprite;
         while(di < 3)
         {
            db = makeBtn(DIFF_NAMES[di] + "  " + NPS[di] + "/s", "d" + di, 470, 150 + di * 34, 120, 26, 12);
            lobby.addChild(db);
            diffBtns.push(db);
            di++;
         }

         lobbyHint = makeText(560, 36, fmt(12, 0xFFB347, true, "center"));
         lobbyHint.x = 20;
         lobbyHint.y = 352;
         lobby.addChild(lobbyHint);

         var back:Sprite = makeBtn("BACK", "back", 6, 368, 80, 26, 13);
         lobby.addChild(back);

         _r.addChild(lobby);
      }

      private static function buildHud() : void
      {
         hud = makeText(380, 40, fmt(13, 0xFFFF66, true, "center"));
         hud.x = 110;
         hud.y = 2;
         hud.background = true;
         hud.backgroundColor = 0x000000;
         hud.alpha = 0.85;
         hud.visible = false;
         _r.addChild(hud);

         banner = makeText(600, 80, fmt(44, 0xFFFFFF, true, "center"));
         banner.y = 150;
         banner.visible = false;
         _r.addChild(banner);

         forfeit = makeBtn("FORFEIT", "forfeit", 520, 4, 74, 22, 11);
         forfeit.visible = false;
         _r.addChild(forfeit);
      }

      // ------------------------------------------------------------ per-frame upkeep
      private static function tick(e:Event) : void
      {
         if(_r == null)
         {
            return;
         }
         var onTitle:Boolean = (_r.currentFrame == 6);
         btn.visible = (onTitle && !lobby.visible && !active);
         if(btn.visible)
         {
            btnTxt = TextField(btn.getChildAt(0));
            btnTxt.text = linked ? "ONLINE: CONNECTED" : "ONLINE VERSUS";
         }
         if(lobby.visible || active || btn.visible)
         {
            topOf(btn);
            topOf(lobby);
            topOf(hud);
            topOf(banner);
            topOf(forfeit);
            try
            {
               _r.setChildIndex(_r["miCursorOK"], _r.numChildren - 1);
               _r.setChildIndex(_r["miCursor"], _r.numChildren - 1);
            }
            catch(err:Error)
            {
            }
         }
         if(active)
         {
            hud.visible = true;
            forfeit.visible = !resolved;
            updateHud();
         }
      }

      private static function topOf(o:DisplayObject) : void
      {
         if(o.parent == _r)
         {
            _r.setChildIndex(o, _r.numChildren - 1);
         }
      }

      private static function updateHud() : void
      {
         var s:String = "YOU " + myWins + " - " + oppWins + " OPP   |   " + NAMES[game];
         if(game == 1 && oppProg >= 0)
         {
            s += "\nOpponent has " + oppProg + "/10 stickers in the frame";
         }
         if(game == 5)
         {
            s += "\nMisses: you " + myMiss + " / opponent " + oppMiss + "   (" + DIFF_NAMES[diff] + ", " + NPS[diff] + " notes/s)";
         }
         if(note != "")
         {
            s += "\n" + note;
         }
         hud.text = s;
         hud.height = (hud.numLines * 18) + 6;
      }

      // ------------------------------------------------------------ lobby
      private static function onClick(e:MouseEvent) : void
      {
         var id:String = e.currentTarget.name;
         if(id == "open")
         {
            openLobby();
         }
         else if(id == "back")
         {
            lobby.visible = false;
            if(_r.currentFrame != 6)
            {
               SoundMixer.stopAll();
               _r.gotoAndStop(6);
            }
         }
         else if(id == "forfeit")
         {
            claim(false);
         }
         else if(id.charAt(0) == "d")
         {
            if(!linked || isHost)
            {
               diff = int(id.charAt(1));
               send("diff|" + diff);
               refreshLobby();
            }
         }
         else if(id.charAt(0) == "g")
         {
            if(linked && isHost)
            {
               var sd:int = int(Math.random() * 2000000000) + 1;
               send("go|" + id.charAt(1) + "|" + sd + "|" + diff);
               startMatch(int(id.charAt(1)), sd, diff);
            }
         }
      }

      private static function openLobby() : void
      {
         lobby.visible = true;
         refreshLobby();
      }

      private static function refreshLobby() : void
      {
         if(!lobby.visible)
         {
            return;
         }
         if(!bridgeOk)
         {
            lobbyStatus.text = "Multiplayer bridge not found. Open the game through the provided web page.";
         }
         else
         {
            lobbyStatus.text = statusText;
         }
         lobbyScore.text = "SCORE   YOU " + myWins + " - " + oppWins + " OPPONENT";
         var canPick:Boolean = linked && isHost;
         var dj:int = 0;
         while(dj < diffBtns.length)
         {
            paintBtn(diffBtns[dj], 120, 26, (dj == diff) ? 0xB38F00 : 0x23506f);
            diffBtns[dj].alpha = (!linked || isHost) ? 1 : 0.6;
            dj++;
         }
         var i:int = 0;
         while(i < gameBtns.length)
         {
            gameBtns[i].alpha = canPick ? 1 : 0.35;
            i++;
         }
         if(!linked)
         {
            lobbyHint.text = "Use the Room panel under the game: create a room, or join with a friend's code.";
         }
         else if(isHost)
         {
            lobbyHint.text = "You are the HOST - pick a game to start.";
         }
         else
         {
            lobbyHint.text = "Waiting for the host to pick a game...";
         }
      }

      // ------------------------------------------------------------ transport
      public static function send(p:String) : void
      {
         if(!bridgeOk)
         {
            return;
         }
         try
         {
            ExternalInterface.call("mpSend", p);
         }
         catch(err:Error)
         {
         }
      }

      public static function recv(k:String, d:String = "") : void
      {
         if(k == "status")
         {
            onStatus(d);
         }
         else if(k == "msg")
         {
            onMsg(d);
         }
      }

      private static function onStatus(d:String) : void
      {
         var p:Array = d.split("|");
         var wasLinked:Boolean = linked;
         if(p[0] == "paired")
         {
            linked = true;
            isHost = (p[1] == "host");
            statusText = isHost ? "Friend connected - you are HOST" : "Connected - you are the GUEST";
            if(!wasLinked)
            {
               myWins = 0;
               oppWins = 0;
            }
         }
         else if(p[0] == "waiting")
         {
            linked = false;
            statusText = "Room " + p[1] + " ready - waiting for your friend to join...";
         }
         else if(p[0] == "connecting")
         {
            linked = false;
            statusText = "Connecting to server...";
         }
         else if(p[0] == "closed")
         {
            linked = false;
            statusText = "Disconnected" + (p.length > 1 && p[1] != "" ? " (" + p[1] + ")" : "");
            if(active && !resolved)
            {
               resolved = true;
               finish(isHost ? "h" : "g");
               note = "Opponent left - you win by forfeit";
            }
         }
         else
         {
            linked = false;
            statusText = "Not connected";
         }
         refreshLobby();
      }

      private static function inMpContext() : Boolean
      {
         return lobby.visible || (_r.currentFrame == 6) || active;
      }

      private static function onMsg(s:String) : void
      {
         var p:Array = s.split("|");
         var k:String = p[0];
         if(k == "go")
         {
            if(inMpContext())
            {
               startMatch(int(p[1]), Number(p[2]), int(p[3]));
            }
            else
            {
               send("busy");
            }
         }
         else if(k == "diff")
         {
            if(!isHost)
            {
               diff = int(p[1]);
               refreshLobby();
            }
         }
         else if(k == "rfin")
         {
            oppFin = true;
            oppFinM = int(p[1]);
            oppFinH = int(p[2]);
            checkRockFin();
         }
         else if(k == "busy")
         {
            statusText = "Your friend is not on the title screen / lobby yet.";
            refreshLobby();
         }
         else if(k == "claim")
         {
            if(isHost)
            {
               decide(p[1]);
            }
         }
         else if(k == "res")
         {
            if(active && !resolved)
            {
               resolved = true;
               finish(p[1]);
            }
         }
         else if(k == "rdy")
         {
            oppReady = true;
            checkReady();
         }
         else if(k == "key")
         {
            if(active && cur != null && !resolved)
            {
               try
               {
                  cur.mpKey(p[1]);
               }
               catch(err:Error)
               {
               }
            }
         }
         else if(k == "prog")
         {
            oppProg = int(p[1]);
         }
         else if(k == "rock")
         {
            oppRot = Number(p[1]);
            oppY = Number(p[2]);
            oppMiss = int(p[3]);
            oppHit = int(p[4]);
         }
      }

      // ------------------------------------------------------------ match flow
      private static function startMatch(g:int, sd:Number, d:int) : void
      {
         if(g < 1 || g > 5)
         {
            return;
         }
         game = g;
         seedState = sd;
         diff = (d >= 0 && d <= 2) ? d : 1;
         draw = false;
         myFin = false;
         oppFin = false;
         myMiss = 0;
         myHit = 0;
         oppMiss = 0;
         oppHit = 0;
         active = true;
         resolved = false;
         claimed = false;
         mpFinal = false;
         myReady = false;
         oppReady = false;
         readyFn = null;
         oppProg = -1;
         oppRot = 0;
         oppY = 0;
         note = "";
         cur = null;
         if(!bkSaved)
         {
            bkDeDonde = String(_r["deDonde"]);
            bkDireccion = String(_r["direccion"]);
            bkSaved = true;
         }
         lobby.visible = false;
         banner.visible = false;
         hud.visible = true;
         try
         {
            _r["elFade"].alpha = 0;
            _r["elFade"].visible = false;
         }
         catch(err:Error)
         {
         }
         _r.gotoAndStop("Mini" + g);
      }

      /** Each mini-game calls this from its frame1 when MP.active. */
      public static function reg(g:Object, n:int) : void
      {
         cur = g;
         try
         {
            g.cerrar.visible = false;
            g.cerrar.mouseEnabled = false;
         }
         catch(err:Error)
         {
         }
         try
         {
            g.parent.cerrar.visible = false;
            g.parent.cerrar.mouseEnabled = false;
         }
         catch(err:Error)
         {
         }
      }

      /** Both players must click "start" - the game proceeds only when both did. */
      public static function ready(fn:Function) : void
      {
         myReady = true;
         readyFn = fn;
         send("rdy");
         note = "Waiting for opponent...";
         checkReady();
      }

      private static function checkReady() : void
      {
         if(myReady && oppReady && readyFn != null)
         {
            var f:Function = readyFn;
            readyFn = null;
            note = "";
            f();
         }
      }

      /** iWon=true means "I finished/won"; false means "I lost/crashed/quit". */
      public static function claim(iWon:Boolean) : void
      {
         if(!active || resolved || claimed)
         {
            return;
         }
         claimed = true;
         var w:String = (iWon == isHost) ? "h" : "g";
         if(isHost)
         {
            decide(w);
         }
         else
         {
            send("claim|" + w);
            note = "Waiting for host to confirm...";
         }
      }

      private static function decide(w:String) : void
      {
         if(resolved || !active)
         {
            return;
         }
         resolved = true;
         send("res|" + w);
         finish(w);
      }

      private static function finish(w:String) : void
      {
         if(w == "d")
         {
            draw = true;
            mpFinal = true;
            note = "";
            banner.text = "DRAW";
            banner.textColor = 0xFFE24A;
            banner.visible = true;
            readyFn = null;
            if(cur != null)
            {
               try
               {
                  cur.mpEnd(false);
               }
               catch(err:Error)
               {
               }
            }
            return;
         }
         draw = false;
         var won:Boolean = ((w == "h") == isHost);
         if(won)
         {
            myWins++;
         }
         else
         {
            oppWins++;
         }
         mpFinal = true;
         note = "";
         banner.text = won ? "YOU WIN!" : "YOU LOSE";
         banner.textColor = won ? 0x6CFF6C : 0xFF6C6C;
         banner.visible = true;
         readyFn = null;
         if(cur != null)
         {
            try
            {
               cur.mpEnd(won);
            }
            catch(err:Error)
            {
            }
         }
      }

      /** Called by MainTimeline.frame13 (the exit router). Returns true if handled. */
      public static function intercept(r:MovieClip) : Boolean
      {
         if(!active)
         {
            return false;
         }
         toLobby();
         return true;
      }

      private static function toLobby() : void
      {
         active = false;
         cur = null;
         readyFn = null;
         hud.visible = false;
         banner.visible = false;
         forfeit.visible = false;
         if(bkSaved)
         {
            _r["deDonde"] = bkDeDonde;
            _r["direccion"] = bkDireccion;
            bkSaved = false;
         }
         try
         {
            _r["elFade"].alpha = 0;
            _r["elFade"].visible = false;
            _r["inventario"].visible = false;
            _r["miCursorOK"].visible = false;
            _r["miCursorOK"].gotoAndStop(1);
            _r["miCursor"].visible = true;
            _r["miCursor"].gotoAndStop(1);
            _r["miCursor"].startDrag(true);
         }
         catch(err:Error)
         {
         }
         openLobby();
      }

      // ------------------------------------------------------------ game helpers
      public static function key(k:String) : void
      {
         if(active)
         {
            send("key|" + k);
         }
      }

      public static function prog(n:int) : void
      {
         if(active)
         {
            send("prog|" + n);
         }
      }

      public static function sendRock(rot:Number, y:Number, miss:int, hit:int) : void
      {
         if(!active)
         {
            return;
         }
         myMiss = miss;
         myHit = hit;
         fc++;
         if(fc % 2 == 0)
         {
            send("rock|" + (Math.round(rot * 10) / 10) + "|" + Math.round(y) + "|" + miss + "|" + hit);
         }
      }

      /** Rock Battle: called when my song is over. Fewer misses wins; ties go to more hits. */
      public static function rockDone(m:int, h:int) : void
      {
         if(!active || resolved)
         {
            return;
         }
         myFin = true;
         myMiss = m;
         myHit = h;
         note = "Song finished - waiting for opponent...";
         if(isHost)
         {
            checkRockFin();
         }
         else
         {
            send("rfin|" + m + "|" + h);
         }
      }

      private static function checkRockFin() : void
      {
         if(!isHost || !myFin || !oppFin || resolved)
         {
            return;
         }
         var w:String;
         if(myMiss < oppFinM)
         {
            w = "h";
         }
         else if(myMiss > oppFinM)
         {
            w = "g";
         }
         else if(myHit > oppFinH)
         {
            w = "h";
         }
         else if(myHit < oppFinH)
         {
            w = "g";
         }
         else
         {
            w = "d";
         }
         decide(w);
      }

      // ------------------------------------------------------------ random + generators
      /** Seeded in online matches (both players get the same numbers); Math.random() otherwise. */
      public static function rnd() : Number
      {
         if(!active)
         {
            return Math.random();
         }
         seedState = (seedState * 1664525 + 1013904223) % 4294967296;
         return seedState / 4294967296;
      }

      /** Crypto race course. 1 = free lane, 0 = cube. Rows never contain a 1-lane-wide gap. */
      public static function cryptoRows() : Array
      {
         var rows:Array = [];
         var total:int = 26;
         var i:int = 0;
         var g:int;
         var gap:int;
         while(i < total)
         {
            rows.push(cryptoRow(i / (total - 1)));
            gap = (i < 8) ? 2 : 1;
            g = 0;
            while(g < gap)
            {
               rows.push([1, 1, 1, 1, 1, 1]);
               g++;
            }
            i++;
         }
         g = 0;
         while(g < 6)
         {
            rows.push([1, 1, 1, 1, 1, 1]);
            g++;
         }
         return rows;
      }

      private static function cryptoRow(p:Number) : Array
      {
         var k:int = int(1 + p * 3 + rnd() * 1.5);
         if(k > 4)
         {
            k = 4;
         }
         var tries:int = 0;
         var row:Array;
         var n:int;
         var c:int;
         while(tries < 60)
         {
            row = [1, 1, 1, 1, 1, 1];
            n = 0;
            while(n < k)
            {
               c = int(rnd() * 6);
               if(row[c] == 1)
               {
                  row[c] = 0;
                  n++;
               }
            }
            if(cryptoOk(row))
            {
               return row;
            }
            tries++;
         }
         // fallback: one solid block of cubes, positioned so no gap is 1 lane wide
         var starts:Array = [];
         var s:int = 0;
         var j:int;
         while(s <= 6 - k)
         {
            row = [1, 1, 1, 1, 1, 1];
            j = 0;
            while(j < k)
            {
               row[s + j] = 0;
               j++;
            }
            if(cryptoOk(row))
            {
               starts.push(s);
            }
            s++;
         }
         var st:int = starts[int(rnd() * starts.length)];
         row = [1, 1, 1, 1, 1, 1];
         j = 0;
         while(j < k)
         {
            row[st + j] = 0;
            j++;
         }
         return row;
      }

      /** True when every run of free lanes is at least 2 wide (the ship needs 2 lanes of room). */
      private static function cryptoOk(row:Array) : Boolean
      {
         var run:int = 0;
         var i:int = 0;
         while(i < 6)
         {
            if(row[i] == 1)
            {
               run++;
            }
            else
            {
               if(run == 1)
               {
                  return false;
               }
               run = 0;
            }
            i++;
         }
         if(run == 1)
         {
            return false;
         }
         return true;
      }
   }
}
