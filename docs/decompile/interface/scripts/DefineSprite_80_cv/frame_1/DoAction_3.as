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
univers = new Repere3d(500);
var pt = 0;
var pc = "0x000000";
var pa = 0;
var i = 0;
while(i <= 2)
{
   getCube3dPoints(univers,-1000,0,150,150,10,10,pt,pc,pa);
   this.createEmptyMovieClip("cube" + i,10000 + i);
   this["cube" + i].createApi(univers,createPtsArray(i * 8,8),"cube" + i,0,"cube",true,"global");
   this["cube" + i].univers = univers;
   i++;
}
