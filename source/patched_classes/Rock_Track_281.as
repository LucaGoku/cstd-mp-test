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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1013")]
   public dynamic class Rock_Track_281 extends MovieClip
   {
      
      public var tabTemp:Array;
      
      public var tb:uint;
      
      public var tablatura:Array;
      
      public function Rock_Track_281()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,10,this.frame11,26,this.frame27,42,this.frame43,52,this.frame53,73,this.frame74,80,this.frame81,88,this.frame89,96,this.frame97,134,this.frame135,150,this.frame151,166,this.frame167,181,this.frame182,212,this.frame213,220,this.frame221,228,this.frame229,243,this.frame244,251,this.frame252,259,this.frame260,274,this.frame275,290,this.frame291,305,this.frame306,329,this.frame330,334,this.frame335,339,this.frame340,341,this.frame342,345,this.frame346,353,this.frame354,357,this.frame358,371,this.frame372,375,this.frame376,391,this.frame392,405,this.frame406,421,this.frame422,499,this.frame500,507,this.frame508,522,this.frame523,538,this.frame539,562,this.frame563,584,this.frame585,599,this.frame600,607,this.frame608,638,this.frame639,644,this.frame645,648,this.frame649,652,this.frame653,661,this.frame662,686,this.frame687,700,this.frame701,705,this.frame706,710,this.frame711,715,this.frame716,723,this.frame724,731,this.frame732,749,this.frame750,763
         ,this.frame764,769,this.frame770,772,this.frame773,777,this.frame778,786,this.frame787,811,this.frame812,825,this.frame826,830,this.frame831,834,this.frame835,839,this.frame840,847,this.frame848,863,this.frame864,879,this.frame880,894,this.frame895,909,this.frame910,925,this.frame926,940,this.frame941,956,this.frame957,964,this.frame965,979,this.frame980,985,this.frame986,989,this.frame990,995,this.frame996,1003,this.frame1004,1042,this.frame1043,1049,this.frame1050,1057,this.frame1058,1073,this.frame1074,1080,this.frame1081,1089,this.frame1090,1104,this.frame1105,1110,this.frame1111,1114,this.frame1115,1119,this.frame1120,1127,this.frame1128,1166,this.frame1167,1174,this.frame1175,1181,this.frame1182,1189,this.frame1190,1204,this.frame1205,1219,this.frame1220,1227,this.frame1228,1234,this.frame1235,1239,this.frame1240,1244,this.frame1245,1249,this.frame1250,1294,this.frame1295,1298,this.frame1299,1301,this.frame1302,1305,this.frame1306,1309,this.frame1310,1319,this.frame1320,1326,this.frame1327
         ,1344,this.frame1345,1349,this.frame1350,1354,this.frame1355,1360,this.frame1361,1364,this.frame1365,1368,this.frame1369,1373,this.frame1374,1375,this.frame1376,1382,this.frame1383,1390,this.frame1391,1394,this.frame1395,1398,this.frame1399,1406,this.frame1407,1413,this.frame1414,1419,this.frame1420,1424,this.frame1425,1429,this.frame1430,1437,this.frame1438,1441,this.frame1442,1444,this.frame1445,1452,this.frame1453,1460,this.frame1461,1468,this.frame1469,1475,this.frame1476,1483,this.frame1484,1498,this.frame1499,1514,this.frame1515,1529,this.frame1530,1545,this.frame1546,1560,this.frame1561,1576,this.frame1577);
      }
      
      public function crea(param1:String, param2:Boolean = false) : void
      {
         if(MP.active && !param2)
         {
            return;
         }
         var _loc2_:miNota = null;
         if(this.stage != null && !MovieClip(parent).Pausado)
         {
            MovieClip(parent).NotasBels.crea(param1);
            _loc2_ = new miNota();
            addChild(_loc2_);
            _loc2_.nota = param1;
            _loc2_.Iniciar(true);
         }
      }
      
      internal function frame1() : *
      {
         stop();
         this.tabTemp = new Array();
         this.tb = 0;
         while(this.tb < MovieClip(parent).tablatura.length)
         {
            this.tabTemp.push(MovieClip(parent).tablatura[this.tb]);
            ++this.tb;
         }
         this.tablatura = this.tabTemp;
      }
      
      internal function frame2() : *
      {
         MovieClip(parent).moverBel();
      }
      
      internal function frame11() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame27() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame43() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame53() : *
      {
         if(this.stage != null)
         {
            MovieClip(root).SFX("FullRiff");
         }
      }
      
      internal function frame74() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame81() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame89() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame97() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame135() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame151() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame167() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame182() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame213() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame221() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame229() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame244() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame252() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame260() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame275() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame291() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame306() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame330() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame335() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame340() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame342() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame346() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame354() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame358() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame372() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame376() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame392() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame406() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame422() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame500() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame508() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame523() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame539() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame563() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame585() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame600() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame608() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame639() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame645() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame649() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame653() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame662() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame687() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame701() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame706() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame711() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame716() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame724() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame732() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame750() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame764() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame770() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame773() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame778() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame787() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame812() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame826() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame831() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame835() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame840() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame848() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame864() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame880() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame895() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame910() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame926() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame941() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame957() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame965() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame980() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame986() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame990() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame996() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1004() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1043() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1050() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1058() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1074() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1081() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1090() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1105() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1111() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1115() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1120() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1128() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1167() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1175() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1182() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1190() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1205() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1220() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1228() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1235() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1240() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1245() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1250() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1295() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1299() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1302() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1306() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1310() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1320() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1327() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1345() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1350() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1355() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1361() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1365() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1369() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1374() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1376() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1383() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1391() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1395() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1399() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1407() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1414() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1420() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1425() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1430() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1438() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1442() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1445() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1453() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1461() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1469() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1476() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1484() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1499() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1515() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1530() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1546() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1561() : *
      {
         this.crea(this.tablatura.shift());
      }
      
      internal function frame1577() : *
      {
         this.crea(this.tablatura.shift());
      }
   }
}

