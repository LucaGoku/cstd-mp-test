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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol962")]
   public dynamic class Mini3Crypto_248 extends MovieClip
   {
      
      public var Instruccion1:TextField;
      
      public var Instruccion2:TextField;
      
      public var Juego:MovieClip;
      
      public var cerrar:SimpleButton;
      
      public var volante:MovieClip;
      
      public var saliendo:Boolean;
      
      public function Mini3Crypto_248()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function Empezar(param1:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.CLICK,this.Empezar);
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
         MovieClip(parent).miCursor.startDrag(true);
         MovieClip(parent).miCursorOK.visible = false;
         this.Instruccion1.text = "";
         this.Instruccion2.text = "";
         this.Juego.elGo.play();
      }
      
      public function Continuar(param1:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.CLICK,this.Continuar);
         this.Salir();
      }
      
      public function mpEnd(won:Boolean) : void
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
         if(!this.saliendo)
         {
            if(this.stage != null)
            {
               MovieClip(root).SFX("ganar2");
            }
            if(!MP.active)
            {
               MovieClip(parent).Memoria[37] = true;
            }
            this.saliendo = true;
            this.Juego.Bajar = true;
            this.Instruccion1.text = "Well Done";
            this.Instruccion2.text = "Click anywhere to continue";
            MovieClip(parent).miCursorOK.visible = true;
            MovieClip(parent).miCursorOK.startDrag(true);
            MovieClip(parent).miCursor.visible = false;
            stage.addEventListener(MouseEvent.CLICK,this.Continuar);
         }
      }
      
      public function YaPerdio() : void
      {
         if(MP.active && !MP.mpFinal)
         {
            MP.claim(false);
            return;
         }
         if(!this.saliendo)
         {
            this.saliendo = true;
            this.Instruccion1.text = "You crashed!";
            this.Instruccion2.text = "Click anywhere to continue";
            MovieClip(parent).miCursorOK.visible = true;
            MovieClip(parent).miCursorOK.startDrag(true);
            MovieClip(parent).miCursor.visible = false;
            stage.addEventListener(MouseEvent.CLICK,this.Continuar);
         }
      }
      
      public function Salir() : void
      {
         MovieClip(parent).elFade.visible = true;
         Tweener.addTween(MovieClip(parent).elFade,{
            "alpha":1,
            "time":20,
            "useFrames":true,
            "transition":"easeInOutSine",
            "onComplete":this.Vamonos
         });
      }
      
      public function Vamonos() : void
      {
         this.Juego.LimpiarListeners();
         MovieClip(parent).FadeClarence();
         MovieClip(parent).inventario.visible = true;
         MovieClip(parent).miCursor.visible = true;
         MovieClip(parent).miCursor.startDrag(true);
         MovieClip(parent).miCursorOK.visible = false;
         MovieClip(parent).miCursorOK.gotoAndStop(1);
         MovieClip(parent).gotoAndStop("Direccionador");
      }
      
      public function cerrarBot(param1:MouseEvent) : void
      {
         this.cerrar.removeEventListener(MouseEvent.CLICK,this.cerrarBot);
         this.saliendo = true;
         this.Salir();
      }
      
      internal function frame1() : *
      {
         stop();
         MovieClip(parent).deDonde = "Mini3";
         MovieClip(parent).inventario.visible = false;
         MovieClip(parent).miCursorOK.gotoAndStop(2);
         MovieClip(parent).miCursorOK.visible = true;
         MovieClip(parent).miCursorOK.startDrag(true);
         MovieClip(parent).miCursor.visible = false;
         this.Instruccion1.mouseEnabled = false;
         this.Instruccion2.mouseEnabled = false;
         this.Instruccion1.text = "Move the cursor to steer, click to accelerate";
         this.Instruccion2.text = "Click anywhere to start";
         stage.addEventListener(MouseEvent.CLICK,this.Empezar);
         this.saliendo = false;
         this.cerrar.addEventListener(MouseEvent.CLICK,this.cerrarBot);
         if(MP.active)
         {
            MP.reg(this,3);
         }
      }
   }
}

