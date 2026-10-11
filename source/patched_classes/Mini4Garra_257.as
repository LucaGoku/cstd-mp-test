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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1007")]
   public dynamic class Mini4Garra_257 extends MovieClip
   {
      
      public var Instruccion1:TextField;
      
      public var Instruccion2:TextField;
      
      public var Juego:MovieClip;
      
      public var cerrar:SimpleButton;
      
      public function Mini4Garra_257()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function cierre(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         stage.removeEventListener(Event.ENTER_FRAME,this.Juego.elUpdate);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.Juego.elClick);
         this.cerrar.removeEventListener(MouseEvent.CLICK,this.cierre);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.Juego.elClick);
         stage.removeEventListener(MouseEvent.CLICK,this.iniciar);
         stage.removeEventListener(MouseEvent.CLICK,this.cierre);
         MovieClip(parent).elFade.visible = true;
         Tweener.addTween(MovieClip(parent).elFade,{
            "alpha":1,
            "time":20,
            "useFrames":true,
            "transition":"easeInOutSine",
            "onComplete":function():*
            {
               MovieClip(parent).miCursor.visible = true;
               MovieClip(parent).miCursor.startDrag(true);
               MovieClip(parent).miCursorOK.visible = false;
               MovieClip(parent).inventario.visible = true;
               MovieClip(parent).gotoAndPlay("Direccionador");
            }
         });
      }
      
      public function iniciar(param1:MouseEvent) : void
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
         MovieClip(parent).miCursor.visible = true;
         MovieClip(parent).miCursor.startDrag(true);
         MovieClip(parent).miCursorOK.visible = false;
         this.cerrar.addEventListener(MouseEvent.CLICK,this.cierre);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.Juego.elClick);
         stage.removeEventListener(MouseEvent.CLICK,this.iniciar);
         this.Instruccion1.text = "";
         this.Instruccion2.text = "";
      }
      
      public function mpEnd(won:Boolean) : void
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
         this.Instruccion1.text = "Well Done!";
         this.Instruccion2.text = "Click anywhere to continue";
         MovieClip(parent).miCursorOK.visible = true;
         MovieClip(parent).miCursorOK.startDrag(true);
         MovieClip(parent).miCursor.visible = false;
         stage.addEventListener(MouseEvent.CLICK,this.cierre);
         this.cerrar.removeEventListener(MouseEvent.CLICK,this.cierre);
      }
      
      internal function frame1() : *
      {
         stop();
         MovieClip(parent).deDonde = "Mini4";
         MovieClip(parent).inventario.visible = false;
         MovieClip(parent).miCursorOK.gotoAndStop(2);
         MovieClip(parent).miCursorOK.visible = true;
         MovieClip(parent).miCursorOK.startDrag(true);
         MovieClip(parent).miCursor.visible = false;
         this.Instruccion1.mouseEnabled = false;
         this.Instruccion2.mouseEnabled = false;
         this.Instruccion1.text = "Use the cursor to move the claw crane.";
         this.Instruccion2.text = "Click to grab or to release. Click anywhere to start.";
         stage.addEventListener(MouseEvent.CLICK,this.iniciar);
         if(MP.active)
         {
            MP.reg(this,4);
         }
      }
   }
}

