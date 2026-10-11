import os, shutil, sys

SRC = '/tmp/out/scripts'
DST = '/tmp/w2/scripts'
if os.path.exists('/tmp/w2'):
    shutil.rmtree('/tmp/w2')
shutil.copytree(SRC, DST)
shutil.copy('/tmp/mp_src/MP.as', DST + '/MP.as')

def load(p):
    return open(os.path.join(DST, p), newline='').read().replace('\r\n', '\n')

def save(p, s):
    open(os.path.join(DST, p), 'w', newline='').write(s)

def sub(s, old, new, count=1):
    n = s.count(old)
    if n != count:
        print('PATCH FAIL (found %d, wanted %d):\n%s' % (n, count, old[:200]))
        sys.exit(1)
    return s.replace(old, new)

I = '         '  # 9 spaces (method body indent)

# ------------------------------------------------------------------ MainTimeline
p = 'Clarence_fla/MainTimeline.as'
s = load(p)
s = sub(s, 'internal function frame13() : *\n      {\n         stop();\n',
        'internal function frame13() : *\n      {\n         stop();\n'
        '         if(MP.intercept(this))\n         {\n            return;\n         }\n')
s = sub(s, '         this.crsfd = 0;\n      }\n',
        '         this.crsfd = 0;\n         MP.init(this);\n      }\n')
save(p, s)

# ------------------------------------------------------------------ Mini1 (stickers race)
p = 'Clarence_fla/Mini1ElMenu_217.as'
s = load(p)
s = sub(s, '         if(Listo)\n         {\n            this.QuitarListeners();\n',
        '         if(MP.active)\n         {\n            MP.prog(this.countPlaced());\n         }\n'
        '         if(Listo && MP.active)\n         {\n            this.QuitarListeners();\n            MP.claim(true);\n         }\n'
        '         else if(Listo)\n         {\n            this.QuitarListeners();\n')
s = sub(s, '      public function QuitarListeners() : void\n',
        '''      public function countPlaced() : int
      {
         var n:int = 0;
         var k:int = 1;
         var s:MovieClip = null;
         while(k < 11)
         {
            s = this["sticker" + k];
            if(!(s.x < 174 || s.y < 34 || s.x + s.width > 426 || s.y + s.height > 366))
            {
               n++;
            }
            k++;
         }
         return n;
      }
      
      public function mpEnd(won:Boolean) : void
      {
         this.QuitarListeners();
         this.Instruccion1.text = won ? "You finished first!" : "Opponent finished first!";
         this.Instruccion2.text = "Click anywhere to continue";
         if(this.stage != null)
         {
            MovieClip(root).SFX(won ? "arpa" : "perder1");
         }
         addEventListener(Event.ENTER_FRAME,this.Wait);
      }
      
      public function QuitarListeners() : void
''')
s = sub(s, '         MovieClip(parent).inventario.visible = false;\n         this.wait = 0;\n      }\n',
        '         MovieClip(parent).inventario.visible = false;\n         this.wait = 0;\n'
        '         if(MP.active)\n         {\n            MP.reg(this,1);\n         }\n      }\n')
save(p, s)

# ------------------------------------------------------------------ Mini2 (Merciless duel)
p = 'Clarence_fla/Mini2Merciless_231.as'
s = load(p)
s = sub(s, '      public var numCombo:uint;\n',
        '      public var numCombo:uint;\n      \n      public var oppNum:uint;\n')
s = sub(s, '         stage.addEventListener(Event.ENTER_FRAME,this.Contador);\n         this.iniciado = true;\n         this.manoNino.play();\n',
        '         if(!MP.active)\n         {\n            stage.addEventListener(Event.ENTER_FRAME,this.Contador);\n            this.manoNino.play();\n         }\n         this.iniciado = true;\n')
s = sub(s, '               if(this.combo[this.numCombo] == "A")\n',
        '               MP.key("A");\n               if(this.combo[this.numCombo] == "A")\n')
s = sub(s, '               if(this.combo[this.numCombo] == "B")\n',
        '               MP.key("B");\n               if(this.combo[this.numCombo] == "B")\n')
s = sub(s, '      public function Vamonos(param1:Boolean) : void\n      {\n         this.Instruccion.visible = true;\n         if(param1)\n         {\n            MovieClip(parent).Memoria[17] = true;\n         }\n',
        '''      public function mpKey(param1:String) : void
      {
         if(!this.iniciado || this.akuCarga || this.akuDisparo)
         {
            return;
         }
         if(this.combo[this.oppNum] == param1)
         {
            this.poderAku.nextFrame();
            ++this.oppNum;
         }
         else
         {
            this.poderAku.gotoAndStop(1);
            this.oppNum = 0;
         }
         if(param1 == "A")
         {
            this.Aku.gotoAndPlay("Golpe");
         }
         else
         {
            this.Aku.gotoAndPlay("Patada");
         }
         if(this.oppNum > 7)
         {
            this.contador = this.frCON * 8 - 1;
            stage.addEventListener(Event.ENTER_FRAME,this.Contador);
         }
      }
      
      public function mpEnd(won:Boolean) : void
      {
         this.Vamonos(won);
      }
      
      public function Vamonos(param1:Boolean) : void
      {
         if(MP.active && !MP.mpFinal)
         {
            MP.claim(param1);
            return;
         }
         this.Instruccion.visible = true;
         if(param1 && !MP.active)
         {
            MovieClip(parent).Memoria[17] = true;
         }
''')
s = sub(s, '         if(!MovieClip(parent).Memoria[40])\n',
        '         this.oppNum = 0;\n         if(!MovieClip(parent).Memoria[40] && !MP.active)\n')
s = sub(s, '         this.numCombo = 0;\n         this.poderRyu.stop();\n      }\n',
        '         this.numCombo = 0;\n         this.poderRyu.stop();\n         if(MP.active)\n         {\n            MP.reg(this,2);\n         }\n      }\n')
save(p, s)

# ------------------------------------------------------------------ Mini3 (Crypto race)
p = 'Clarence_fla/Mini3Crypto_248.as'
s = load(p)
s = sub(s, '         stage.removeEventListener(MouseEvent.CLICK,this.Empezar);\n         MovieClip(parent).miCursor.visible = true;\n',
        '''         stage.removeEventListener(MouseEvent.CLICK,this.Empezar);
         if(MP.active)
         {
            this.Instruccion1.text = "Waiting for opponent...";
            this.Instruccion2.text = "";
            MP.ready(this.Empezar2);
            return;
         }
         this.Empezar2();
      }
      
      public function Empezar2() : void
      {
         MovieClip(parent).miCursor.visible = true;
''')
s = sub(s, '      public function YaGano() : void\n      {\n',
        '''      public function mpEnd(won:Boolean) : void
      {
         if(won)
         {
            this.YaGano();
         }
         else if(this.Juego.Muerto)
         {
            this.YaPerdio();
         }
         else
         {
            this.mpLose();
         }
      }
      
      public function mpLose() : void
      {
         if(!this.saliendo)
         {
            this.saliendo = true;
            this.Juego.Parar();
            this.Instruccion1.text = "Opponent won the race!";
            this.Instruccion2.text = "Click anywhere to continue";
            MovieClip(parent).miCursorOK.visible = true;
            MovieClip(parent).miCursorOK.startDrag(true);
            MovieClip(parent).miCursor.visible = false;
            stage.addEventListener(MouseEvent.CLICK,this.Continuar);
         }
      }
      
      public function YaGano() : void
      {
         if(MP.active && !MP.mpFinal)
         {
            if(!this.saliendo)
            {
               MP.claim(true);
            }
            return;
         }
''')
s = sub(s, '            MovieClip(parent).Memoria[37] = true;\n',
        '            if(!MP.active)\n            {\n               MovieClip(parent).Memoria[37] = true;\n            }\n')
s = sub(s, '      public function YaPerdio() : void\n      {\n',
        '      public function YaPerdio() : void\n      {\n         if(MP.active && !MP.mpFinal)\n         {\n            MP.claim(false);\n            return;\n         }\n')
s = sub(s, '         this.cerrar.addEventListener(MouseEvent.CLICK,this.cerrarBot);\n      }\n   }\n}',
        '         this.cerrar.addEventListener(MouseEvent.CLICK,this.cerrarBot);\n         if(MP.active)\n         {\n            MP.reg(this,3);\n         }\n      }\n   }\n}')
save(p, s)

# ------------------------------------------------------------------ Mini4 (Claw race)
p = 'Clarence_fla/Mini4Garra_257.as'
s = load(p)
s = sub(s, '      public function iniciar(param1:MouseEvent) : void\n      {\n',
        '''      public function iniciar(param1:MouseEvent) : void
      {
         if(MP.active)
         {
            stage.removeEventListener(MouseEvent.CLICK,this.iniciar);
            this.Instruccion1.text = "Waiting for opponent...";
            this.Instruccion2.text = "";
            MP.ready(this.iniciar2);
            return;
         }
         this.iniciar2();
      }
      
      public function iniciar2() : void
      {
''')
s = sub(s, '      public function Pollo() : void\n      {\n         MovieClip(parent).Memoria[35] = true;\n',
        '''      public function mpEnd(won:Boolean) : void
      {
         if(won)
         {
            this.Pollo();
         }
         else
         {
            this.mpLose();
         }
      }
      
      public function mpLose() : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.Juego.elClick);
         this.Instruccion1.text = "Too slow!";
         this.Instruccion2.text = "Click anywhere to continue";
         MovieClip(parent).miCursorOK.visible = true;
         MovieClip(parent).miCursorOK.startDrag(true);
         MovieClip(parent).miCursor.visible = false;
         stage.addEventListener(MouseEvent.CLICK,this.cierre);
      }
      
      public function Pollo() : void
      {
         if(MP.active && !MP.mpFinal)
         {
            MP.claim(true);
            return;
         }
         if(!MP.active)
         {
            MovieClip(parent).Memoria[35] = true;
         }
''')
s = sub(s, '         stage.addEventListener(MouseEvent.CLICK,this.iniciar);\n      }\n   }\n}',
        '         stage.addEventListener(MouseEvent.CLICK,this.iniciar);\n         if(MP.active)\n         {\n            MP.reg(this,4);\n         }\n      }\n   }\n}')
save(p, s)

# ------------------------------------------------------------------ Mini5 (Rock battle)
p = 'Clarence_fla/Mini5Rock_278.as'
s = load(p)
s = sub(s, '      public function Inicia(param1:MouseEvent) : void\n      {\n         var e:MouseEvent = param1;\n',
        '''      public function Inicia(param1:MouseEvent) : void
      {
         if(MP.active)
         {
            stage.removeEventListener(MouseEvent.CLICK,this.Inicia);
            MovieClip(parent).Instruccion1.text = "Waiting for opponent...";
            MovieClip(parent).Instruccion2.text = "";
            MP.ready(this.Inicia2);
            return;
         }
         this.Inicia2();
      }
      
      public function mpInit() : void
      {
         var nps:Number = MP.NPS[MP.diff];
         this.mpFpn = 30 / nps;
         this.mpTotal = int(Math.round(MP.DURATION * nps));
         this.mpSpawned = 0;
         this.mpAcc = this.mpFpn - 25;
         this.mpWait = 0;
         this.mpLane = 2;
         this.myMiss = 0;
         this.myHit = 0;
         this.mpDone = false;
         stage.addEventListener(Event.ENTER_FRAME,this.mpSpawner);
      }
      
      public function mpSpawner(param1:Event) : void
      {
         var lane:int = 0;
         if(this.Pausado || this.mpDone)
         {
            return;
         }
         if(this.mpSpawned < this.mpTotal)
         {
            this.mpAcc += 1;
            if(this.mpAcc >= this.mpFpn)
            {
               this.mpAcc -= this.mpFpn;
               if(MP.rnd() < 0.4)
               {
                  lane = this.mpLane + (MP.rnd() < 0.5 ? -1 : 1);
                  if(lane < 0)
                  {
                     lane = 1;
                  }
                  if(lane > 5)
                  {
                     lane = 4;
                  }
               }
               else
               {
                  lane = int(MP.rnd() * 6);
               }
               this.mpLane = lane;
               this.NotasClar.crea("ABCDEF".charAt(lane),true);
               ++this.mpSpawned;
            }
         }
         else
         {
            ++this.mpWait;
            if(this.mpWait > 90)
            {
               this.mpDone = true;
               stage.removeEventListener(Event.ENTER_FRAME,this.mpSpawner);
               MP.rockDone(this.myMiss,this.myHit);
            }
         }
      }
      
      public function mpEnd(won:Boolean) : void
      {
         stage.removeEventListener(Event.ENTER_FRAME,this.mpSpawner);
         if(MP.draw)
         {
            stage.addEventListener(MouseEvent.CLICK,this.Cerrar);
            this.ReadyRock.text = "DRAW!";
            MovieClip(parent).pararCanal();
            this.Mensaje();
            this.Pausado = true;
            stage.removeEventListener(Event.ENTER_FRAME,this.Flechas);
         }
         else if(won)
         {
            this.PerdioBelson();
         }
         else
         {
            this.PerdioClarence();
         }
      }
      
      public function Inicia2() : void
      {
         var e:MouseEvent = null;
''')
s = sub(s, '         if(this.BelsG.flecha.y < this.BelGoal - 1)\n',
        '''         if(MP.active)
         {
            this.BelGoal = MP.oppY;
            this.BelsG.flecha.y += (MP.oppY - this.BelsG.flecha.y) * 0.5;
            this.agujaB.rotation = MP.oppRot;
            this.MarcBels.gotoAndStop(this.MarcFrame(MP.oppRot));
            MP.sendRock(this.aguja.rotation,this.MusY,this.myMiss,this.myHit);
         }
         else if(this.BelsG.flecha.y < this.BelGoal - 1)
''')
s = sub(s, '      public function Suma(param1:Boolean) : void\n      {\n',
        '      public function Suma(param1:Boolean) : void\n      {\n         if(MP.active && !param1)\n         {\n            return;\n         }\n         if(MP.active)\n         {\n            ++this.myHit;\n         }\n')
s = sub(s, '      public function Resta(param1:Boolean) : void\n      {\n',
        '      public function Resta(param1:Boolean) : void\n      {\n         if(MP.active && !param1)\n         {\n            return;\n         }\n         if(MP.active)\n         {\n            ++this.myMiss;\n         }\n')
s = sub(s, '      public function PerdioClarence() : void\n      {\n',
        '      public function PerdioClarence() : void\n      {\n         if(MP.active && !MP.mpFinal)\n         {\n            return;\n         }\n')
s = sub(s, '      public function PerdioBelson() : void\n      {\n         MovieClip(parent).Memoria[56] = true;\n',
        '      public function PerdioBelson() : void\n      {\n         if(!MP.active)\n         {\n            MovieClip(parent).Memoria[56] = true;\n         }\n')
s = sub(s, '         stop();\n         MovieClip(parent).inventario.visible = false;\n         MovieClip(parent).Instruccion1.text = "Move Up',
        '         stop();\n         if(MP.active)\n         {\n            MP.reg(this,5);\n         }\n         MovieClip(parent).inventario.visible = false;\n         MovieClip(parent).Instruccion1.text = "Move Up')
save(p, s)

# ---- Rock extras: fields, spawner start, cleanup
p = 'Clarence_fla/Mini5Rock_278.as'
s = load(p)
s = sub(s, '      public var tablatura:Array;\n',
        '      public var tablatura:Array;\n      \n      public var mpAcc:Number;\n      \n      public var mpFpn:Number;\n      \n      public var mpSpawned:int;\n      \n      public var mpTotal:int;\n      \n      public var mpWait:int;\n      \n      public var mpLane:int;\n      \n      public var myMiss:int;\n      \n      public var myHit:int;\n      \n      public var mpDone:Boolean;\n')
s = sub(s, '         this.NotasClar.play();\n',
        '         this.NotasClar.play();\n         if(MP.active)\n         {\n            this.mpInit();\n         }\n')
s = sub(s, '      public function vamonos() : void\n      {\n',
        '      public function vamonos() : void\n      {\n         stage.removeEventListener(Event.ENTER_FRAME,this.mpSpawner);\n')
save(p, s)

# ---- Rock_Track: the 1577-frame timeline no longer spawns notes in online matches
p = 'Clarence_fla/Rock_Track_281.as'
s = load(p)
s = sub(s, '      public function crea(param1:String) : void\n      {\n',
        '      public function crea(param1:String, param2:Boolean = false) : void\n      {\n         if(MP.active && !param2)\n         {\n            return;\n         }\n')
save(p, s)

# ---- Crypto_Boxes: randomised course, no 1-lane gaps
import re
p = 'Clarence_fla/Crypto_Boxes_251.as'
s = load(p)
m = re.search(r'         this\.ArrBox = \[\[.*\]\];\n', s)
assert m, 'ArrBox literal not found'
s = s[:m.start()] + '         this.ArrBox = MP.cryptoRows();\n' + s[m.end():]
save(p, s)


print('ALL PATCHES APPLIED')
