package Clarence_fla
{
   import adobe.utils.*;
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
   import miCodo.CryptoCubo;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol927")]
   public dynamic class Crypto_Boxes_251 extends MovieClip
   {
      
      public var distancia:Number;
      
      public var ArrBox:Array;
      
      public function Crypto_Boxes_251()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function Iniciar() : void
      {
         addEventListener(Event.ENTER_FRAME,this.Lector);
      }
      
      public function Lector(param1:Event) : void
      {
         this.distancia += MovieClip(parent).Velocidad;
         if(this.distancia > 400)
         {
            this.Linea();
            this.distancia -= 400;
         }
      }
      
      public function Linea() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:CryptoCubo = null;
         if(this.ArrBox.length > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < 6)
            {
               if(this.ArrBox[0][_loc1_] == 0)
               {
                  _loc2_ = new CryptoCubo();
                  addChild(_loc2_);
                  _loc2_.Iniciar(_loc1_ * 100 - MovieClip(parent).Espec);
               }
               _loc1_++;
            }
            this.ArrBox.shift();
         }
         else
         {
            MovieClip(parent).elGo.gotoAndPlay("Win");
            this.Parar();
         }
      }
      
      public function Parar() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.Lector);
      }
      
      internal function frame1() : *
      {
         stop();
         this.distancia = 0;
         this.ArrBox = MP.cryptoRows();
      }
   }
}

