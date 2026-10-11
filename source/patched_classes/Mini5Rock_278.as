package Clarence_fla
{
   import adobe.utils.*;
   import caurina.transitions.Tweener;
   import flash.accessibility.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.globalization.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.sampler.*;
   import flash.sensors.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.engine.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1037")]
   public dynamic class Mini5Rock_278 extends MovieClip
   {
      
      public var BelsG:MovieClip;
      
      public var ClarG:MovieClip;
      
      public var MarcBels:MovieClip;
      
      public var MarcClar:MovieClip;
      
      public var Nombre1:TextField;
      
      public var Nombre2:TextField;
      
      public var NotasBels:MovieClip;
      
      public var NotasClar:MovieClip;
      
      public var ReadyRock:TextField;
      
      public var aguja:MovieClip;
      
      public var agujaB:MovieClip;
      
      public var MusY:Number;
      
      public var BelGoal:Number;
      
      public var Pausado:Boolean;
      
      public var tablatura:Array;
      
      public var mpAcc:Number;
      
      public var mpFpn:Number;
      
      public var mpSpawned:int;
      
      public var mpTotal:int;
      
      public var mpWait:int;
      
      public var mpLane:int;
      
      public var myMiss:int;
      
      public var myHit:int;
      
      public var mpDone:Boolean;
      
      public function Mini5Rock_278()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function Inicia(param1:MouseEvent) : void
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
         this.Nombre1.visible = false;
         this.Nombre2.visible = false;
         MovieClip(parent).cerrar.addEventListener(MouseEvent.CLICK,this.Cerrar);
         MovieClip(parent).Instruccion1.visible = false;
         MovieClip(parent).Instruccion2.visible = false;
         this.MarcClar.visible = true;
         this.MarcBels.visible = true;
         this.MarcClar.gotoAndStop(21);
         this.MarcBels.gotoAndStop(21);
         this.Pausado = false;
         stage.removeEventListener(MouseEvent.CLICK,this.Inicia);
         this.NotasClar.play();
         if(MP.active)
         {
            this.mpInit();
         }
         if(this.stage != null)
         {
            MovieClip(root).SFX("ganar2");
         }
         this.ReadyRock.text = "ROCK ON!";
         Tweener.addTween(this.ReadyRock,{
            "x":-300,
            "y":120,
            "scaleX":2,
            "scaleY":2,
            "time":20,
            "useFrames":true,
            "transition":"easeOutElastic",
            "onComplete":function():*
            {
               if(this.stage != null)
               {
                  Tweener.addTween(ReadyRock,{
                     "alpha":0,
                     "time":20,
                     "useFrames":true,
                     "transition":"linear",
                     "onComplete":function():*
                     {
                        if(this.stage != null)
                        {
                           ReadyRock.visible = false;
                        }
                     }
                  });
               }
            }
         });
      }
      
      public function Flechas(param1:Event) : void
      {
         this.MusY += 0.5 * (this.ClarG.mouseY - this.ClarG.flecha.y - 12.5);
         if(this.MusY < 0)
         {
            this.MusY = 0;
         }
         else if(this.MusY > 125)
         {
            this.MusY = 125;
         }
         this.ClarG.ghost3.y = this.ClarG.ghost2.y;
         this.ClarG.ghost2.y = this.ClarG.ghost1.y;
         this.ClarG.ghost1.y = this.ClarG.flecha.y;
         this.ClarG.flecha.y = this.MusY;
         if(MP.active)
         {
            this.BelGoal = MP.oppY;
            this.BelsG.flecha.y += (MP.oppY - this.BelsG.flecha.y) * 0.5;
            this.agujaB.rotation = MP.oppRot;
            this.MarcBels.gotoAndStop(this.MarcFrame(MP.oppRot));
            MP.sendRock(this.aguja.rotation,this.MusY,this.myMiss,this.myHit);
         }
         else if(this.BelsG.flecha.y < this.BelGoal - 1)
         {
            this.BelsG.flecha.y += 1;
         }
         else if(this.BelsG.flecha.y > this.BelGoal + 1)
         {
            --this.BelsG.flecha.y;
         }
      }
      
      public function Suma(param1:Boolean) : void
      {
         if(MP.active && !param1)
         {
            return;
         }
         if(MP.active)
         {
            ++this.myHit;
         }
         if(param1 && this.aguja.rotation > -10)
         {
            this.MarcClar.gotoAndStop(this.MarcFrame(this.aguja.rotation));
            this.aguja.rotation -= 0.5;
         }
         else if(!param1 && this.agujaB.rotation > -10)
         {
            this.MarcBels.gotoAndStop(this.MarcFrame(this.agujaB.rotation));
            this.agujaB.rotation -= 0.5;
         }
      }
      
      public function Resta(param1:Boolean) : void
      {
         if(MP.active && !param1)
         {
            return;
         }
         if(MP.active)
         {
            ++this.myMiss;
         }
         if(param1 && this.aguja.rotation < 10)
         {
            this.MarcClar.gotoAndStop(this.MarcFrame(this.aguja.rotation));
            this.aguja.rotation += 0.5;
            if(this.aguja.rotation > 9.5)
            {
               this.PerdioClarence();
            }
         }
         else if(!param1 && this.agujaB.rotation < 10)
         {
            this.MarcBels.gotoAndStop(this.MarcFrame(this.agujaB.rotation));
            this.agujaB.rotation += 0.5;
            if(this.agujaB.rotation > 9.5)
            {
               this.PerdioBelson();
            }
         }
      }
      
      public function MarcFrame(param1:Number) : int
      {
         return Math.round((param1 + 10) * 2) + 1;
      }
      
      public function moverBel() : void
      {
         if(this.tablatura.length > 0)
         {
            switch(this.tablatura.shift())
            {
               case "A":
                  this.BelGoal = 0;
                  break;
               case "B":
                  this.BelGoal = 25;
                  break;
               case "C":
                  this.BelGoal = 50;
                  break;
               case "D":
                  this.BelGoal = 75;
                  break;
               case "E":
                  this.BelGoal = 100;
                  break;
               case "F":
                  this.BelGoal = 125;
            }
         }
      }
      
      public function PerdioBelson() : void
      {
         if(!MP.active)
         {
            MovieClip(parent).Memoria[56] = true;
         }
         stage.addEventListener(MouseEvent.CLICK,this.Cerrar);
         this.ReadyRock.text = "YOU WIN!";
         MovieClip(parent).pararCanal();
         if(this.stage != null)
         {
            MovieClip(root).SFX("ganar2");
         }
         this.Mensaje();
         this.Pausado = true;
         stage.removeEventListener(Event.ENTER_FRAME,this.Flechas);
         var _loc1_:uint = 0;
         while(_loc1_ < this.NotasBels.numChildren)
         {
            MovieClip(this.NotasBels.getChildAt(_loc1_)).gotoAndPlay(7);
            _loc1_++;
         }
         var _loc2_:uint = 0;
         while(_loc2_ < this.NotasClar.numChildren)
         {
            MovieClip(this.NotasClar.getChildAt(_loc2_)).gotoAndPlay(20);
            _loc2_++;
         }
      }
      
      public function PerdioClarence() : void
      {
         if(MP.active && !MP.mpFinal)
         {
            return;
         }
         stage.addEventListener(MouseEvent.CLICK,this.Cerrar);
         this.ReadyRock.text = "YOU LOSE!";
         MovieClip(parent).pararCanal();
         if(this.stage != null)
         {
            MovieClip(root).SFX("perder1");
         }
         this.Mensaje();
         this.Pausado = true;
         stage.removeEventListener(Event.ENTER_FRAME,this.Flechas);
         var _loc1_:uint = 0;
         while(_loc1_ < this.NotasBels.numChildren)
         {
            MovieClip(this.NotasBels.getChildAt(_loc1_)).gotoAndPlay(20);
            _loc1_++;
         }
         var _loc2_:uint = 0;
         while(_loc2_ < this.NotasClar.numChildren)
         {
            MovieClip(this.NotasClar.getChildAt(_loc2_)).gotoAndPlay(7);
            _loc2_++;
         }
      }
      
      public function Mensaje() : void
      {
         MovieClip(parent).Instruccion2.visible = true;
         MovieClip(parent).Instruccion1.text = "";
         MovieClip(parent).Instruccion2.text = "Click anywhere to continue.";
         this.ReadyRock.visible = true;
         this.ReadyRock.alpha = 0;
         this.ReadyRock.x = 0;
         this.ReadyRock.y = 170;
         this.ReadyRock.scaleX = 1;
         this.ReadyRock.scaleY = 1;
         Tweener.addTween(this.ReadyRock,{
            "alpha":1,
            "x":-150,
            "y":145,
            "scaleX":1.5,
            "scaleY":1.5,
            "time":20,
            "useFrames":true,
            "transition":"easeOutElastic"
         });
      }
      
      public function Cerrar(param1:MouseEvent) : void
      {
         this.Pausado = true;
         MovieClip(parent).cerrar.removeEventListener(MouseEvent.CLICK,this.Cerrar);
         var _loc2_:uint = 0;
         while(_loc2_ < this.NotasBels.numChildren)
         {
            MovieClip(this.NotasBels.getChildAt(_loc2_)).gotoAndPlay(7);
            _loc2_++;
         }
         var _loc3_:uint = 0;
         while(_loc3_ < this.NotasClar.numChildren)
         {
            MovieClip(this.NotasClar.getChildAt(_loc3_)).gotoAndPlay(7);
            _loc3_++;
         }
         MovieClip(parent).elFade.visible = true;
         Tweener.addTween(MovieClip(parent).elFade,{
            "alpha":1,
            "scaleY":2,
            "time":20,
            "useFrames":true,
            "transition":"linear",
            "onComplete":this.vamonos
         });
      }
      
      public function vamonos() : void
      {
         stage.removeEventListener(Event.ENTER_FRAME,this.mpSpawner);
         stage.removeEventListener(Event.ENTER_FRAME,this.Flechas);
         stage.removeEventListener(MouseEvent.CLICK,this.elCont);
         stage.removeEventListener(MouseEvent.CLICK,this.Cerrar);
         var _loc1_:uint = 0;
         while(_loc1_ < this.NotasBels.numChildren)
         {
            if(MovieClip(this.NotasBels.getChildAt(_loc1_)).hasEventListener(Event.ENTER_FRAME))
            {
               MovieClip(this.NotasBels.getChildAt(_loc1_)).removeEventListener(Event.ENTER_FRAME,MovieClip(this.NotasBels.getChildAt(_loc1_)).Camina);
            }
            _loc1_++;
         }
         var _loc2_:uint = 0;
         while(_loc2_ < this.NotasClar.numChildren)
         {
            if(MovieClip(this.NotasClar.getChildAt(_loc2_)).hasEventListener(Event.ENTER_FRAME))
            {
               MovieClip(this.NotasClar.getChildAt(_loc2_)).removeEventListener(Event.ENTER_FRAME,MovieClip(this.NotasClar.getChildAt(_loc2_)).Camina);
            }
            _loc2_++;
         }
         MovieClip(parent).pararCanal();
         MovieClip(parent).FadeClarence();
         MovieClip(parent).inventario.visible = true;
         MovieClip(parent).deDonde = "Mini5";
         MovieClip(parent).direccion = "Mini5";
         MovieClip(parent).gotoAndPlay("Direccionador");
      }
      
      public function elCont(param1:MouseEvent) : void
      {
      }
      
      internal function frame1() : *
      {
         stop();
         if(MP.active)
         {
            MP.reg(this,5);
         }
         MovieClip(parent).inventario.visible = false;
         MovieClip(parent).Instruccion1.text = "Move Up and Down with the cursor to catch the notes.";
         MovieClip(parent).Instruccion2.text = "Click anywhere to start.";
         this.MusY = 0;
         this.BelGoal = 62.5;
         this.Pausado = true;
         this.MarcClar.visible = false;
         this.MarcBels.visible = false;
         stage.addEventListener(Event.ENTER_FRAME,this.Flechas);
         stage.addEventListener(MouseEvent.CLICK,this.Inicia);
         this.tablatura = ["D","B","C","E","F","E","D","B","B","B","B","A","A","B","A","A","B","B","B","B","C","B","C","D","E","D","F","E","F","F","F","F","F","F","D","E","F","D","E","D","C","B","D","E","D","F","C","B","D","E","A","B","D","C","B","D","E","D","F","C","B","D","E","A","A","A","A","A","A","A","A","E","D","C","E","F","E","F","E","D","F","E","E","D","C","D","F","E","F","E","C","B","B","B","A","B","A","B","A","D","C","B","C","E","C","A","A","B","A","C","D","E","F","C","D","E","F","E","F","D","C","B","C","B","A","B","E","C","B","A","A","A","A","A","A","A","A","X"];
      }
   }
}

