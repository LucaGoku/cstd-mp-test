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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol825")]
   public dynamic class Mini1ElMenu_217 extends MovieClip
   {
      
      public var Instruccion1:TextField;
      
      public var Instruccion2:TextField;
      
      public var cerrar:SimpleButton;
      
      public var sticker1:MovieClip;
      
      public var sticker10:MovieClip;
      
      public var sticker2:MovieClip;
      
      public var sticker3:MovieClip;
      
      public var sticker4:MovieClip;
      
      public var sticker5:MovieClip;
      
      public var sticker6:MovieClip;
      
      public var sticker7:MovieClip;
      
      public var sticker8:MovieClip;
      
      public var sticker9:MovieClip;
      
      public var dropShadow:DropShadowFilter;
      
      public var i:uint;
      
      public var wait:uint;
      
      public function Mini1ElMenu_217()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function tomar(param1:MouseEvent) : void
      {
         if(this.stage != null)
         {
            MovieClip(root).SFX("papel1");
         }
         this.setChildIndex(MovieClip(param1.target),this.numChildren - 3);
         param1.target.filters = new Array(this.dropShadow);
         param1.target.startDrag();
         MovieClip(parent).miCursor.visible = false;
      }
      
      public function soltar(param1:MouseEvent) : void
      {
         var Listo:Boolean;
         var StiK:MovieClip;
         var StiL:MovieClip;
         var K:uint = 0;
         var L:uint = 0;
         var e:MouseEvent = param1;
         if(this.stage != null)
         {
            MovieClip(root).SFX("papel2");
         }
         e.target.filters = [];
         e.target.stopDrag();
         MovieClip(parent).miCursor.visible = true;
         MovieClip(parent).miCursor.startDrag(true);
         e.target.x = Math.round(e.target.x / 10) * 10;
         e.target.y = Math.round(e.target.y / 10) * 10;
         if(e.target.x < 0)
         {
            e.target.x = 0;
         }
         if(e.target.y < 0)
         {
            e.target.y = 0;
         }
         if(e.target.x > 600 - Math.round(e.target.width / 10) * 10)
         {
            e.target.x = 600 - Math.round(e.target.width / 10) * 10;
         }
         if(e.target.y > 400 - Math.round(e.target.height / 10) * 10)
         {
            e.target.y = 400 - Math.round(e.target.height / 10) * 10;
         }
         Listo = true;
         StiK = this.sticker10;
         StiL = null;
         if(StiK.x < 174 || StiK.y < 34 || StiK.x + StiK.width > 426 || StiK.y + StiK.height > 366)
         {
            Listo = false;
         }
         else
         {
            K = 1;
            while(K < 10)
            {
               StiK = this["sticker" + K];
               if(StiK.x < 174 || StiK.y < 34 || StiK.x + StiK.width > 426 || StiK.y + StiK.height > 366)
               {
                  Listo = false;
                  break;
               }
               L = K + 1;
               while(L < 11)
               {
                  StiL = this["sticker" + L];
                  if(Math.abs(StiK.x + StiK.width / 2 - (StiL.x + StiL.width / 2)) < (Math.abs(StiK.width + StiL.width) - 8) / 2 && Math.abs(StiK.y + StiK.height / 2 - (StiL.y + StiL.height / 2)) < (Math.abs(StiK.height + StiL.height) - 8) / 2)
                  {
                     Listo = false;
                     break;
                  }
                  L++;
               }
               K++;
            }
         }
         if(MP.active)
         {
            MP.prog(this.countPlaced());
         }
         if(Listo && MP.active)
         {
            this.QuitarListeners();
            MP.claim(true);
         }
         else if(Listo)
         {
            this.QuitarListeners();
            this.Instruccion1.text = MovieClip(parent).xmlTx.room.(@name == "Interface").char.(@name == "Messages").text.(@id == "7");
            this.Instruccion2.text = MovieClip(parent).xmlTx.room.(@name == "Interface").char.(@name == "Messages").text.(@id == "8");
            MovieClip(parent).Memoria[18] = true;
            if(this.stage != null)
            {
               MovieClip(root).SFX("arpa");
            }
            addEventListener(Event.ENTER_FRAME,this.Wait);
         }
      }
      
      public function countPlaced() : int
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
      {
         var _loc1_:uint = 1;
         while(_loc1_ < 11)
         {
            this["sticker" + _loc1_].play();
            this["sticker" + _loc1_].removeEventListener(MouseEvent.MOUSE_DOWN,this.tomar);
            this["sticker" + _loc1_].removeEventListener(MouseEvent.MOUSE_UP,this.soltar);
            _loc1_++;
         }
      }
      
      public function Salir(param1:MouseEvent) : void
      {
         MovieClip(parent).miCursor.visible = true;
         MovieClip(parent).miCursor.startDrag(true);
         MovieClip(parent).miCursorOK.visible = false;
         this.cerrar.removeEventListener(MouseEvent.CLICK,this.Salir);
         stage.removeEventListener(MouseEvent.CLICK,this.Salir);
         removeEventListener(Event.ENTER_FRAME,this.Wait);
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
         MovieClip(parent).FadeClarence();
         MovieClip(parent).inventario.visible = true;
         MovieClip(parent).gotoAndPlay("Direccionador");
      }
      
      public function Wait(param1:Event) : void
      {
         ++this.wait;
         if(this.wait > 5)
         {
            stage.addEventListener(MouseEvent.CLICK,this.Salir);
            MovieClip(parent).miCursor.visible = false;
            MovieClip(parent).miCursorOK.gotoAndStop(2);
            MovieClip(parent).miCursorOK.visible = true;
            MovieClip(parent).miCursorOK.startDrag(true);
         }
      }
      
      internal function frame1() : *
      {
         stop();
         this.dropShadow = new DropShadowFilter();
         this.dropShadow.distance = 4;
         this.dropShadow.angle = 135;
         this.dropShadow.color = 10570787;
         this.dropShadow.alpha = 1;
         this.dropShadow.blurX = 0;
         this.dropShadow.blurY = 0;
         this.Instruccion1.mouseEnabled = false;
         this.Instruccion2.mouseEnabled = false;
         this.i = 1;
         while(this.i < 11)
         {
            this["sticker" + this.i].addEventListener(MouseEvent.MOUSE_DOWN,this.tomar);
            this["sticker" + this.i].addEventListener(MouseEvent.MOUSE_UP,this.soltar);
            ++this.i;
         }
         this.cerrar.addEventListener(MouseEvent.CLICK,this.Salir);
         this.Instruccion1.text = MovieClip(parent).xmlTx.room.(@name == "Interface").char.(@name == "Messages").text.(@id == "5");
         this.Instruccion2.text = MovieClip(parent).xmlTx.room.(@name == "Interface").char.(@name == "Messages").text.(@id == "6");
         MovieClip(parent).deDonde = "Mini1";
         MovieClip(parent).miCursor.gotoAndStop(1);
         MovieClip(parent).inventario.visible = false;
         this.wait = 0;
         if(MP.active)
         {
            MP.reg(this,1);
         }
      }
   }
}

