function createPtsArray(idInit, nbElt)
{
   var _loc2_ = idInit;
   var _loc3_ = new Array();
   var _loc1_ = _loc2_;
   while(_loc1_ < _loc2_ + nbElt)
   {
      _loc3_.push(_loc1_);
      _loc1_ = _loc1_ + 1;
   }
   return _loc3_;
}
univers = new Repere3d();
this.colorType1 = "0x3E4A4D";
this.colorFillType1 = "0xD3D6D6";
this.pointTrait = 2;
this.pointAlpha = 100;
this.pointColor = "0x475656";
this.getCube3dPoints(univers,0,0,0,900,20,20,pointTrait,pointColor,pointAlpha);
this.createEmptyMovieClip("api0",1000);
this.api0.createApi(univers,[0,1,2,3],"api0",0,"standardFillLine",false,"global");
this.createEmptyMovieClip("api1",1001);
this.api1.createApi(univers,[4,5,6,7],"api1",0,"standardFillLine",false,"global");
this.createEmptyMovieClip("api2",1002);
this.api2.createApi(univers,[0,4,7,3],"api2",0,"standardFillLine",false,"global");
this.createEmptyMovieClip("api3",1003);
this.api3.createApi(univers,[1,5,6,2],"api3",0,"standardFillLine",false,"global");
this.getEtoile3dPoints(univers,0,0,0,80,80,0,pointTrait,pointColor,pointAlpha);
univers.rotateObjectY(8,12,90);
univers.translateObject(8,12,{x:-370});
this.createEmptyMovieClip("api4",10001);
this.api4.createApi(univers,[8,9,10,11],"api4",0,"standardFillLine",false,"global");
var inc = univers.array.length;
univers.array.push(new Point3d(-290,0,0,this,pointTrait,pointColor,pointAlpha,inc++));
this.getEtoile3dPoints(univers,0,0,0,320,320,0,pointTrait,pointColor,pointAlpha);
univers.rotateObjectY(14,18,90);
univers.translateObject(14,18,{x:-380});
this.createEmptyMovieClip("api5",10002);
this.api5.createApi(univers,createPtsArray(13,5),"api5",0,"etoile",false,"global");
var theta = 360 / _global.Data.length;
var i = 0;
while(i < _global.Data.length)
{
   var id = univers.array.length;
   univers.array.push(new Particle3d(-380,0,230,this,"BT",id));
   univers.rotateObjectX(id,id,45 + theta * i);
   var newBT = "BT_" + id;
   this[newBT].id = id;
   this[newBT].BT_txt.text = _global.Data[i];
   i++;
}
this.getCarre3dPoints(univers,0,0,0,80,80,0,pointTrait,pointColor,pointAlpha);
univers.rotateObjectY(23,26,90);
univers.translateObject(23,26,{x:400});
this.createEmptyMovieClip("api6",10003);
this.api6.createApi(univers,[23,24,25,26],"api6",0,"standardFillLine",false,"global");
this.getCercle3dPoints(univers,0,0,0,200,200,pointTrait,pointColor,pointAlpha);
univers.rotateObjectY(27,44,90);
univers.translateObject(27,44,{x:400});
this.createEmptyMovieClip("api7",10004);
this.api7.createApi(univers,createPtsArray(univers.idObjet[4],17),"api7",0,"standardCurve",false,"global");
var inc = univers.array.length;
univers.array.push(new Point3d(330,0,0,this,pointTrait,pointColor,pointAlpha,inc++));
this.getEtoile3dPoints(univers,0,0,0,280,280,0,pointTrait,pointColor,pointAlpha);
univers.rotateObjectY(46,50,90);
univers.translateObject(46,50,{x:400});
this.createEmptyMovieClip("api8",10005);
this.api8.createApi(univers,createPtsArray(45,5),"api8",0,"etoile",false,"global");
delete i;
delete id;
delete inc;
delete newBT;
delete theta;
