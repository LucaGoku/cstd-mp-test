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
   
   [SWF(width="600", height="400", backgroundColor="#666666", frameRate="30")]
   public dynamic class MainTimeline extends MovieClip
   {
      
      public var Instruccion1:TextField;
      
      public var Instruccion2:TextField;
      
      public var botStart:SimpleButton;
      
      public var botonMute:MovieClip;
      
      public var botonPausa:MovieClip;
      
      public var cerrar:SimpleButton;
      
      public var elFade:MovieClip;
      
      public var happy:MovieClip;
      
      public var inventario:MovieClip;
      
      public var miCursor:MovieClip;
      
      public var miCursorOK:MovieClip;
      
      public var miPreloader:MovieClip;
      
      public var skip1:SimpleButton;
      
      public var skip2:SimpleButton;
      
      public var XMLlisto:Boolean;
      
      public var xmlCarga:URLLoader;
      
      public var xmlTx:XML;
      
      public var Debug:Boolean;
      
      public var Espera:Boolean;
      
      public var Pausa:Boolean;
      
      public var deDonde:String;
      
      public var direccion:String;
      
      public var Inventario:Array;
      
      public var cuantosBoletos:uint;
      
      public var ArrayTemp:Array;
      
      public var PosInic:Array;
      
      public var Memoria:Array;
      
      public var mem:uint;
      
      public var Conti:SharedObject;
      
      public var pausePosition:int;
      
      public var mySound:Sound;
      
      public var Mcrypto:Sound;
      
      public var Mmercy:Sound;
      
      public var myChannel:SoundChannel;
      
      public var myChannel2:SoundChannel;
      
      public var fadeMUS:SoundTransform;
      
      public var origMUS:SoundTransform;
      
      public var Callado:Boolean;
      
      public var Spaso1:Sound;
      
      public var Spaso2:Sound;
      
      public var Spaso3:Sound;
      
      public var Spaso4:Sound;
      
      public var Sboton3:Sound;
      
      public var Sboton1:Sound;
      
      public var Smadera1:Sound;
      
      public var Spop:Sound;
      
      public var Spiggy:Sound;
      
      public var Snuevo:Sound;
      
      public var Sexplo:Sound;
      
      public var Sarpa:Sound;
      
      public var Sfeliz:Sound;
      
      public var Sgolpe1:Sound;
      
      public var Sgolpe2:Sound;
      
      public var Spatada1:Sound;
      
      public var Spatada2:Sound;
      
      public var Sperder1:Sound;
      
      public var Sganar1:Sound;
      
      public var Sganar2:Sound;
      
      public var Stono1:Sound;
      
      public var Stono2:Sound;
      
      public var Spapel1:Sound;
      
      public var Spapel2:Sound;
      
      public var Sinventario1:Sound;
      
      public var Salberca:Sound;
      
      public var Scount2:Sound;
      
      public var MFullRiff:Sound;
      
      public var Slapiz:Sound;
      
      public var misEfectos:SoundChannel;
      
      public var trFX10:SoundTransform;
      
      public var trFX20:SoundTransform;
      
      public var trFX50:SoundTransform;
      
      public var trFX65:SoundTransform;
      
      public var trFX35:SoundTransform;
      
      public var crsfd:int;
      
      public var memG:uint;
      
      public var INVE:uint;
      
      public var MEMO:uint;
      
      public function MainTimeline()
      {
         super();
         addFrameScript(0,this.frame1,2,this.frame3,5,this.frame6,12,this.frame13,35,this.frame36,45,this.frame46,55,this.frame56,75,this.frame76,95,this.frame96,105,this.frame106,115,this.frame116,136,this.frame137,145,this.frame146,160,this.frame161,170,this.frame171,180,this.frame181,190,this.frame191,199,this.frame200,215,this.frame216,216,this.frame217);
      }
      
      public function PRELO(param1:Event) : *
      {
         var _loc2_:Number = this.stage.loaderInfo.bytesTotal;
         var _loc3_:Number = this.stage.loaderInfo.bytesLoaded;
         if(_loc3_ < _loc2_)
         {
            this.miPreloader.done_mc.gotoAndStop(Math.ceil(_loc3_ / _loc2_ * 100));
         }
         else if(this.XMLlisto)
         {
            this.miPreloader.gotoAndPlay("fullyLoaded");
            stage.removeEventListener(Event.ENTER_FRAME,this.PRELO);
         }
      }
      
      public function xmlLoadComplete(param1:Event) : void
      {
         this.xmlTx = new XML(this.xmlCarga.data);
         this.XMLlisto = true;
         this.xmlCarga.removeEventListener(Event.COMPLETE,this.xmlLoadComplete);
         this.xmlCarga.removeEventListener(IOErrorEvent.IO_ERROR,this.xmlLoadError);
      }
      
      public function xmlLoadError(param1:IOErrorEvent) : void
      {
         gotoAndStop("xmlError");
      }
      
      public function dialogue(param1:String, param2:String) : String
      {
         var character:String = param1;
         var theID:String = param2;
         return this.xmlTx.room.(@name == currentFrameLabel).char.(@name == character).text.(@id == theID);
      }
      
      public function pausar(param1:MouseEvent) : void
      {
         if(!this.Espera)
         {
            if(this.Pausa)
            {
               this.Pausa = false;
            }
            else
            {
               this.Pausa = true;
            }
         }
      }
      
      public function elClk(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         if(this.stage != null)
         {
            MovieClip(root).SFX("boton3");
         }
         this.botStart.removeEventListener(MouseEvent.CLICK,this.elClk);
         this.elFade.visible = true;
         Tweener.addTween(this.elFade,{
            "alpha":1,
            "time":20,
            "useFrames":true,
            "transition":"easeInOutSine",
            "onComplete":function():*
            {
               gotoAndPlay("Direccionador");
            }
         });
      }
      
      public function elClk1(param1:MouseEvent) : void
      {
         if(this.stage != null)
         {
            MovieClip(root).SFX("boton3");
         }
         this.skip1.removeEventListener(MouseEvent.CLICK,this.elClk1);
         if(this.Conti.data.deDonde == undefined)
         {
            this.Conti.data.deDonde = this.deDonde;
            this.Conti.data.cuantosBoletos = this.cuantosBoletos;
            this.Conti.data.Inventario = this.Inventario;
            this.Conti.data.direccion = this.direccion;
            this.Conti.data.Memoria = this.Memoria;
         }
         else
         {
            this.deDonde = this.Conti.data.deDonde;
            this.cuantosBoletos = this.Conti.data.cuantosBoletos;
            this.Inventario = this.Conti.data.Inventario;
            this.direccion = this.Conti.data.direccion;
            this.Memoria = this.Conti.data.Memoria;
         }
         gotoAndPlay("Direccionador");
      }
      
      public function elClk2(param1:MouseEvent) : void
      {
         this.skip2.removeEventListener(MouseEvent.CLICK,this.elClk2);
         this.deDonde = "RoughRiders";
         this.direccion = "Izquierda";
         this.Memoria[5] = true;
         this.Memoria[6] = true;
         this.Memoria[8] = true;
         this.Memoria[9] = true;
         this.Memoria[10] = true;
         this.Memoria[11] = true;
         this.Memoria[12] = true;
         this.Memoria[13] = true;
         this.Memoria[14] = true;
         this.Memoria[16] = true;
         this.Memoria[17] = true;
         this.Memoria[18] = true;
         this.Memoria[19] = true;
         this.Memoria[21] = true;
         this.Memoria[22] = true;
         this.Memoria[23] = true;
         this.Memoria[24] = true;
         this.Memoria[27] = true;
         this.Memoria[39] = true;
         this.Memoria[40] = true;
         this.Memoria[41] = true;
         this.Memoria[42] = true;
         this.Memoria[43] = true;
         this.Memoria[44] = true;
         this.Memoria[46] = true;
         this.Memoria[47] = true;
         this.Memoria[48] = true;
         this.Memoria[49] = true;
         this.Memoria[50] = true;
         this.Memoria[51] = true;
         this.Memoria[52] = true;
         this.Memoria[54] = true;
         this.Memoria[55] = true;
         this.Inventario[0] = "Token";
         this.cuantosBoletos = 4;
         this.Inventario[1] = "Boletos";
         gotoAndPlay("Direccionador");
      }
      
      public function elOver(param1:MouseEvent) : void
      {
         if(this.stage != null)
         {
            MovieClip(root).SFX("boton1");
         }
      }
      
      public function onMute(param1:MouseEvent) : void
      {
         if(this.Callado)
         {
            SoundMixer.soundTransform = new SoundTransform(1,0);
            this.botonMute.gotoAndStop(1);
            this.Callado = false;
         }
         else
         {
            SoundMixer.soundTransform = new SoundTransform(0,0);
            this.botonMute.gotoAndStop(2);
            this.Callado = true;
         }
      }
      
      public function pararCanal() : void
      {
         this.misEfectos.stop();
      }
      
      public function SFX(param1:String = "") : *
      {
         switch(param1)
         {
            case "paso1":
               this.misEfectos = this.Spaso1.play(0,1,this.trFX10);
               break;
            case "paso2":
               this.misEfectos = this.Spaso2.play(0,1,this.trFX10);
               break;
            case "paso3":
               this.misEfectos = this.Spaso3.play(0,1,this.trFX10);
               break;
            case "paso4":
               this.misEfectos = this.Spaso4.play(0,1,this.trFX10);
               break;
            case "boton3":
               this.misEfectos = this.Sboton3.play(0,1,this.trFX10);
               break;
            case "boton1":
               this.misEfectos = this.Sboton1.play(0,1,this.trFX10);
               break;
            case "madera1":
               this.misEfectos = this.Smadera1.play(0,1,this.trFX10);
               break;
            case "nuevo":
               this.misEfectos = this.Snuevo.play(0,1,this.trFX20);
               break;
            case "pop":
               this.misEfectos = this.Spop.play(0,1,this.trFX20);
               break;
            case "piggy":
               this.misEfectos = this.Spiggy.play(0,1,this.trFX20);
               break;
            case "explo":
               this.misEfectos = this.Sexplo.play(0,1,this.trFX20);
               break;
            case "arpa":
               this.misEfectos = this.Sarpa.play(0,1,this.trFX35);
               break;
            case "feliz":
               this.misEfectos = this.Sfeliz.play(0,1,this.trFX65);
               break;
            case "patada1":
               this.misEfectos = this.Spatada1.play(0,1,this.trFX65);
               break;
            case "patada2":
               this.misEfectos = this.Spatada2.play(0,1,this.trFX65);
               break;
            case "golpe1":
               this.misEfectos = this.Sgolpe1.play(0,1,this.trFX65);
               break;
            case "golpe2":
               this.misEfectos = this.Sgolpe2.play(0,1,this.trFX65);
               break;
            case "ganar1":
               this.misEfectos = this.Sganar1.play(0,1,this.trFX65);
               break;
            case "ganar2":
               this.misEfectos = this.Sganar2.play(0,1,this.trFX65);
               break;
            case "perder1":
               this.misEfectos = this.Sperder1.play(0,1,this.trFX65);
               break;
            case "tono1":
               this.misEfectos = this.Stono1.play(0,1);
               break;
            case "tono2":
               this.misEfectos = this.Stono2.play(0,1);
               break;
            case "papel1":
               this.misEfectos = this.Spapel1.play(0,1,this.trFX35);
               break;
            case "papel2":
               this.misEfectos = this.Spapel2.play(0,1,this.trFX35);
               break;
            case "inventario1":
               this.misEfectos = this.Sinventario1.play(0,1,this.trFX35);
               break;
            case "alberca":
               this.misEfectos = this.Salberca.play(0,1,this.trFX65);
               break;
            case "FullRiff":
               this.misEfectos = this.MFullRiff.play(0,1);
               break;
            case "count2":
               this.misEfectos = this.Scount2.play(0,1,this.trFX65);
               break;
            case "lapiz":
               this.misEfectos = this.Slapiz.play(0,1);
         }
      }
      
      public function FadeMercy() : void
      {
         this.crsfd = 0;
         this.fadeMUS.volume = 0;
         this.myChannel2 = this.Mmercy.play(0,int.MAX_VALUE,this.fadeMUS);
         stage.addEventListener(Event.ENTER_FRAME,this.crossFadeUp);
      }
      
      public function FadeCrypto() : void
      {
         this.crsfd = 0;
         this.fadeMUS.volume = 0;
         this.myChannel2 = this.Mcrypto.play(0,int.MAX_VALUE,this.fadeMUS);
         stage.addEventListener(Event.ENTER_FRAME,this.crossFadeUp);
      }
      
      public function FadeJoshua() : void
      {
         this.crsfd = 0;
         this.fadeMUS.volume = 0;
         stage.addEventListener(Event.ENTER_FRAME,this.crossFadeUp);
      }
      
      public function FadeClarence() : void
      {
         this.crsfd = 0;
         this.origMUS.volume = 0;
         this.myChannel = this.mySound.play(0,int.MAX_VALUE,this.origMUS);
         stage.addEventListener(Event.ENTER_FRAME,this.crossFadeDown);
      }
      
      public function crossFadeUp(param1:Event) : void
      {
         if(this.crsfd < 100)
         {
            this.crsfd += 2;
            this.fadeMUS.volume = this.crsfd / 100;
            this.origMUS.volume = 1 - this.crsfd / 100;
            this.myChannel2.soundTransform = this.fadeMUS;
            this.myChannel.soundTransform = this.origMUS;
         }
         else
         {
            this.myChannel.stop();
            stage.removeEventListener(Event.ENTER_FRAME,this.crossFadeUp);
         }
      }
      
      public function crossFadeDown(param1:Event) : void
      {
         if(this.crsfd < 100)
         {
            this.crsfd += 2;
            this.fadeMUS.volume = 1 - this.crsfd / 100;
            this.origMUS.volume = this.crsfd / 100;
            this.myChannel2.soundTransform = this.fadeMUS;
            this.myChannel.soundTransform = this.origMUS;
         }
         else
         {
            this.myChannel2.stop();
            stage.removeEventListener(Event.ENTER_FRAME,this.crossFadeDown);
         }
      }
      
      public function ocultarFade() : void
      {
         this.elFade.visible = false;
      }
      
      internal function frame1() : *
      {
         this.XMLlisto = false;
         stage.addEventListener(Event.ENTER_FRAME,this.PRELO);
      }
      
      internal function frame3() : *
      {
         stop();
         SoundMixer.stopAll();
         Mouse.hide();
         this.miCursor.mouseEnabled = false;
         this.miCursorOK.mouseEnabled = false;
         this.miCursorOK.visible = false;
         this.miCursorOK.mouseChildren = false;
         this.miCursor.startDrag(true);
         this.xmlCarga = new URLLoader();
         this.xmlCarga.addEventListener(Event.COMPLETE,this.xmlLoadComplete);
         this.xmlCarga.addEventListener(IOErrorEvent.IO_ERROR,this.xmlLoadError);
         this.xmlCarga.load(new URLRequest("dialogues.xml"));
      }
      
      internal function frame6() : *
      {
         stop();
         this.skip2.alpha = 0;
         this.inventario.visible = true;
         Tweener.addTween(this.elFade,{
            "alpha":0,
            "time":20,
            "useFrames":true,
            "transition":"easeInOutSine",
            "onComplete":function():*
            {
               elFade.visible = false;
            }
         });
         this.Debug = false;
         this.Espera = false;
         this.Pausa = false;
         this.deDonde = "";
         this.direccion = "";
         this.Inventario = ["no","no","no","no","no","no","no","no","no","no"];
         this.cuantosBoletos = 0;
         this.ArrayTemp = new Array();
         this.inventario.mouseEnabled = false;
         this.botonPausa.addEventListener(MouseEvent.CLICK,this.pausar);
         this.PosInic = [[50,380,700,0],[0,150,1500,0],[0,150,1200,1]];
         this.Memoria = new Array();
         this.mem = 0;
         while(this.mem < 60)
         {
            this.Memoria.push(false);
            ++this.mem;
         }
         this.Conti = SharedObject.getLocal("gameNameSaves","/");
         if(this.Conti.data.deDonde == undefined)
         {
            this.ArrayTemp = new Array();
            this.ArrayTemp = this.Inventario;
            this.Conti.data.deDonde = this.deDonde;
            this.Conti.data.cuantosBoletos = this.cuantosBoletos;
            this.Conti.data.Inventario = this.ArrayTemp;
            this.Conti.data.direccion = this.direccion;
            this.ArrayTemp = new Array();
            this.ArrayTemp = this.Memoria;
            this.Conti.data.Memoria = this.ArrayTemp;
         }
         this.botStart.addEventListener(MouseEvent.CLICK,this.elClk);
         this.botStart.addEventListener(MouseEvent.MOUSE_OVER,this.elOver);
         this.skip1.addEventListener(MouseEvent.CLICK,this.elClk1);
         this.skip1.addEventListener(MouseEvent.MOUSE_OVER,this.elOver);
         this.skip2.addEventListener(MouseEvent.CLICK,this.elClk2);
         this.pausePosition = 0;
         this.mySound = new MiMusica();
         this.Mcrypto = new MUScrypto();
         this.Mmercy = new MUSmercy();
         this.myChannel = new SoundChannel();
         this.myChannel2 = new SoundChannel();
         this.fadeMUS = new SoundTransform();
         this.origMUS = new SoundTransform();
         this.myChannel = this.mySound.play(0,int.MAX_VALUE,this.origMUS);
         this.botonMute.gotoAndStop(1);
         this.botonMute.addEventListener(MouseEvent.CLICK,this.onMute);
         this.Callado = false;
         this.Spaso1 = new SFXpaso1();
         this.Spaso2 = new SFXpaso2();
         this.Spaso3 = new SFXpaso3();
         this.Spaso4 = new SFXpaso4();
         this.Sboton3 = new SFXboton3();
         this.Sboton1 = new SFXboton1();
         this.Smadera1 = new SFXmadera1();
         this.Spop = new SFXpop();
         this.Spiggy = new SFXpiggy();
         this.Snuevo = new SFXnuevo();
         this.Sexplo = new SFXexplo();
         this.Sarpa = new SFXarpa();
         this.Sfeliz = new SFXfeliz();
         this.Sgolpe1 = new SFXgolpe1();
         this.Sgolpe2 = new SFXgolpe2();
         this.Spatada1 = new SFXpatada1();
         this.Spatada2 = new SFXpatada2();
         this.Sperder1 = new SFXperder1();
         this.Sganar1 = new SFXganar1();
         this.Sganar2 = new SFXganar2();
         this.Stono1 = new SFXtono1();
         this.Stono2 = new SFXtono2();
         this.Spapel1 = new SFXpapel1();
         this.Spapel2 = new SFXpapel2();
         this.Sinventario1 = new SFXinventario1();
         this.Salberca = new SFXalberca();
         this.Scount2 = new SFXcount2();
         this.MFullRiff = new FullRiff();
         this.Slapiz = new SFXlapiz();
         this.misEfectos = new SoundChannel();
         this.trFX10 = new SoundTransform(0.1,0);
         this.trFX20 = new SoundTransform(0.2,0);
         this.trFX50 = new SoundTransform(0.5,0);
         this.trFX65 = new SoundTransform(0.65,0);
         this.trFX35 = new SoundTransform(0.35,0);
         this.crsfd = 0;
         MP.init(this);
      }
      
      internal function frame13() : *
      {
         stop();
         if(MP.intercept(this))
         {
            return;
         }
         this.memG = 0;
         while(this.memG < this.Memoria.length)
         {
            ++this.memG;
         }
         this.Conti.data.deDonde = this.deDonde + "";
         this.Conti.data.cuantosBoletos = this.cuantosBoletos + 0;
         this.ArrayTemp = new Array();
         this.INVE = 0;
         while(this.INVE < this.Inventario.length)
         {
            this.ArrayTemp.push(this.Inventario[this.INVE]);
            ++this.INVE;
         }
         this.Conti.data.Inventario = this.ArrayTemp;
         this.Conti.data.direccion = this.direccion + "";
         this.ArrayTemp = new Array();
         this.MEMO = 0;
         while(this.MEMO < this.Memoria.length)
         {
            this.ArrayTemp.push(this.Memoria[this.MEMO]);
            ++this.MEMO;
         }
         this.Conti.data.Memoria = this.ArrayTemp;
         this.Conti.flush();
         Tweener.addTween(this.elFade,{
            "alpha":0,
            "time":10,
            "useFrames":true,
            "transition":"easeInOutSine",
            "onComplete":this.ocultarFade
         });
         if(this.deDonde == "")
         {
            gotoAndStop("ClarenceRoom");
         }
         else if(this.deDonde == "ClarenceRoom")
         {
            gotoAndStop("RoughRiders");
         }
         else if(this.deDonde == "RoughRiders")
         {
            if(this.direccion == "Derecha")
            {
               gotoAndStop("Park");
            }
            else if(this.direccion == "Izquierda")
            {
               gotoAndStop("FunDungeon");
            }
            else if(this.direccion == "Mini1")
            {
               gotoAndStop("Mini1");
            }
         }
         else if(this.deDonde == "Park")
         {
            if(this.direccion == "Izquierda")
            {
               gotoAndStop("RoughRiders");
            }
            else
            {
               gotoAndStop("PizzaSwamp");
            }
         }
         else if(this.deDonde == "Mini1")
         {
            gotoAndStop("RoughRiders");
         }
         else if(this.deDonde == "Mini2")
         {
            gotoAndStop("PizzaSwamp");
         }
         else if(this.deDonde == "Mini3")
         {
            gotoAndStop("PizzaSwamp");
         }
         else if(this.deDonde == "Mini4")
         {
            gotoAndStop("PizzaSwamp");
         }
         else if(this.deDonde == "Mini5")
         {
            gotoAndStop("PizzaSwamp");
         }
         else if(this.deDonde == "PizzaSwamp")
         {
            if(this.direccion == "Izquierda")
            {
               gotoAndStop("Park");
            }
            else if(this.direccion == "Mini2")
            {
               gotoAndStop("Mini2");
            }
            else if(this.direccion == "Mini3")
            {
               gotoAndStop("Mini3");
            }
            else if(this.direccion == "Mini4")
            {
               gotoAndStop("Mini4");
            }
            else if(this.direccion == "Mini5")
            {
               gotoAndStop("Mini5");
            }
            else if(this.direccion == "Chicle")
            {
               gotoAndStop("PizzaSwamp");
            }
            else
            {
               gotoAndStop("Office");
            }
         }
         else if(this.deDonde == "FunDungeon")
         {
            if(this.direccion == "Pelotas")
            {
               this.inventario.visible = false;
               gotoAndPlay("Later");
            }
            else if(this.direccion == "Later")
            {
               gotoAndStop("FunDungeon");
            }
            else if(this.direccion == "Elipsis")
            {
               gotoAndStop("PizzaSwamp");
            }
            else
            {
               gotoAndStop("RoughRiders");
            }
         }
         else if(this.deDonde == "Office")
         {
            gotoAndStop("PizzaSwamp");
         }
      }
      
      internal function frame36() : *
      {
         stop();
      }
      
      internal function frame46() : *
      {
         stop();
      }
      
      internal function frame56() : *
      {
         stop();
      }
      
      internal function frame76() : *
      {
         stop();
      }
      
      internal function frame96() : *
      {
         this.FadeJoshua();
      }
      
      internal function frame106() : *
      {
         this.FadeMercy();
      }
      
      internal function frame116() : *
      {
         this.FadeCrypto();
      }
      
      internal function frame137() : *
      {
         this.FadeJoshua();
      }
      
      internal function frame146() : *
      {
         SoundMixer.stopAll();
      }
      
      internal function frame161() : *
      {
         SoundMixer.stopAll();
      }
      
      internal function frame171() : *
      {
         SoundMixer.stopAll();
      }
      
      internal function frame181() : *
      {
         SoundMixer.stopAll();
      }
      
      internal function frame191() : *
      {
         SoundMixer.stopAll();
      }
      
      internal function frame200() : *
      {
         SoundMixer.stopAll();
      }
      
      internal function frame216() : *
      {
         stop();
         this.direccion = "Later";
         this.elFade.visible = true;
         Tweener.addTween(this.elFade,{
            "alpha":1,
            "time":20,
            "useFrames":true,
            "transition":"easeInOutSine",
            "onComplete":function():*
            {
               inventario.visible = true;
               gotoAndPlay("Direccionador");
               myChannel = mySound.play(0,int.MAX_VALUE,origMUS);
            }
         });
      }
      
      internal function frame217() : *
      {
         this.FadeJoshua();
         stop();
         this.inventario.visible = false;
         Tweener.addTween(this.elFade,{
            "alpha":0,
            "time":20,
            "useFrames":true,
            "transition":"easeInOutSine",
            "onComplete":function():*
            {
            }
         });
      }
   }
}

