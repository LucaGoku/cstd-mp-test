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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol923")]
   public dynamic class Mini2Merciless_231 extends MovieClip
   {
      
      public var Aku:MovieClip;
      
      public var Instruccion:TextField;
      
      public var Ryu:MovieClip;
      
      public var akuBar:MovieClip;
      
      public var botA:MovieClip;
      
      public var botB:MovieClip;
      
      public var elLose:MovieClip;
      
      public var elWin:MovieClip;
      
      public var manoClar:MovieClip;
      
      public var manoNino:MovieClip;
      
      public var poderAku:MovieClip;
      
      public var poderRyu:MovieClip;
      
      public var ryuBar:MovieClip;
      
      public var akuCarga:Boolean;
      
      public var akuDisparo:Boolean;
      
      public var iniciado:Boolean;
      
      public var contador:uint;
      
      public var frCON:uint;
      
      public var ryuCarga:Boolean;
      
      public var ryuDisparo:Boolean;
      
      public var musX:int;
      
      public var musY:int;
      
      public var combo:Array;
      
      public var numCombo:uint;
      
      public var oppNum:uint;
      
      public function Mini2Merciless_231()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function ninoB() : void
      {
         if(!this.akuCarga && this.iniciado)
         {
            this.Aku.gotoAndPlay("Golpe");
         }
      }
      
      public function ninoA() : void
      {
         if(!this.akuCarga && this.iniciado)
         {
            this.Aku.gotoAndPlay("Patada");
         }
      }
      
      public function Iniciar() : void
      {
         if(!MP.active)
         {
            stage.addEventListener(Event.ENTER_FRAME,this.Contador);
            this.manoNino.play();
         }
         this.iniciado = true;
      }
      
      public function Contador(param1:Event) : void
      {
         ++this.contador;
         if(this.contador % this.frCON == 0 && this.poderAku.currentFrame < 9)
         {
            this.poderAku.nextFrame();
         }
         if(this.contador == this.frCON * 8)
         {
            this.akuCarga = true;
            this.Aku.gotoAndStop("Hadu1");
            if(this.ryuCarga)
            {
               stage.removeEventListener(Event.ENTER_FRAME,this.Contador);
            }
            else if(this.getChildIndex(this.Aku) < this.getChildIndex(this.Ryu))
            {
               this.swapChildren(this.Aku,this.Ryu);
            }
         }
         if(this.contador == this.frCON * 10)
         {
            this.akuDisparo = true;
            this.Aku.gotoAndPlay("Hadu2");
            stage.removeEventListener(Event.ENTER_FRAME,this.Contador);
         }
         if(this.contador == this.frCON * 10 + 10)
         {
            this.Aku.gotoAndStop("Espera");
            stage.removeEventListener(Event.ENTER_FRAME,this.Contador);
         }
      }
      
      public function moverMouse(param1:MouseEvent) : void
      {
         this.musX = mouseX;
         this.musY = mouseY;
         if(this.musX < 160)
         {
            this.musX = 160;
         }
         else if(this.musX > 280)
         {
            this.musX = 280;
         }
         this.manoClar.x = this.musX;
      }
      
      public function Presiona(param1:MouseEvent) : void
      {
         this.manoClar.gotoAndPlay(2);
         if(this.manoClar.x < 210)
         {
            this.AprietaA();
         }
         else if(this.manoClar.x > 230)
         {
            this.AprietaB();
         }
      }
      
      public function AprietaA() : void
      {
         this.botA.gotoAndPlay(2);
         if(!this.akuDisparo && this.iniciado)
         {
            if(!this.ryuCarga)
            {
               MP.key("A");
               if(this.combo[this.numCombo] == "A")
               {
                  this.poderRyu.nextFrame();
                  ++this.numCombo;
               }
               else
               {
                  this.poderRyu.gotoAndStop(1);
                  this.numCombo = 0;
               }
               this.Ryu.gotoAndPlay("Golpe");
            }
         }
      }
      
      public function AprietaB() : void
      {
         this.botB.gotoAndPlay(2);
         if(!this.akuDisparo && this.iniciado)
         {
            if(!this.ryuCarga)
            {
               MP.key("B");
               if(this.combo[this.numCombo] == "B")
               {
                  this.poderRyu.nextFrame();
                  ++this.numCombo;
               }
               else
               {
                  this.poderRyu.gotoAndStop(1);
                  this.numCombo = 0;
               }
               if(this.numCombo > 7)
               {
                  this.ryuCarga = true;
                  if(this.akuCarga)
                  {
                     this.Ryu.gotoAndStop("Hadu1");
                  }
                  else
                  {
                     this.Ryu.gotoAndPlay("Hadu1");
                     if(this.getChildIndex(this.Aku) > this.getChildIndex(this.Ryu))
                     {
                        this.swapChildren(this.Aku,this.Ryu);
                     }
                  }
               }
               else
               {
                  this.Ryu.gotoAndPlay("Patada");
               }
            }
         }
      }
      
      public function mpKey(param1:String) : void
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
         stage.removeEventListener(Event.ENTER_FRAME,this.Contador);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.moverMouse);
         stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.Presiona);
         MovieClip(parent).miCursor.visible = false;
         MovieClip(parent).miCursorOK.gotoAndStop(1);
         MovieClip(parent).miCursorOK.visible = true;
         MovieClip(parent).miCursorOK.startDrag(true);
         MovieClip(parent).miCursorOK.gotoAndStop(2);
         stage.addEventListener(MouseEvent.CLICK,this.clickSal);
      }
      
      public function clickSal(param1:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.CLICK,this.clickSal);
         MovieClip(parent).elFade.visible = true;
         Tweener.addTween(MovieClip(parent).elFade,{
            "alpha":1,
            "time":20,
            "useFrames":true,
            "transition":"easeInOutSine",
            "onComplete":this.salsal
         });
      }
      
      public function salsal() : void
      {
         MovieClip(parent).FadeClarence();
         MovieClip(parent).miCursor.visible = true;
         MovieClip(parent).miCursorOK.gotoAndStop(1);
         MovieClip(parent).miCursorOK.visible = false;
         MovieClip(parent).miCursor.startDrag(true);
         MovieClip(parent).inventario.visible = true;
         MovieClip(parent).deDonde = "Mini2";
         MovieClip(parent).gotoAndPlay("Direccionador");
      }
      
      internal function frame1() : *
      {
         stop();
         this.Instruccion.visible = false;
         this.Instruccion.mouseEnabled = false;
         MovieClip(parent).inventario.visible = false;
         this.akuCarga = false;
         this.akuDisparo = false;
         this.manoNino.stop();
         this.iniciado = false;
         this.poderAku.stop();
         this.contador = 0;
         this.frCON = 24;
         this.ryuCarga = false;
         this.ryuDisparo = false;
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.moverMouse);
         this.musX = 0;
         this.musY = 0;
         stage.addEventListener(MouseEvent.MOUSE_DOWN,this.Presiona);
         this.combo = ["A","A","B","B","A","B","A","B"];
         this.oppNum = 0;
         if(!MovieClip(parent).Memoria[40] && !MP.active)
         {
            this.combo = ["X","X","X","X","X","X","X","X"];
         }
         this.numCombo = 0;
         this.poderRyu.stop();
         if(MP.active)
         {
            MP.reg(this,2);
         }
      }
   }
}

