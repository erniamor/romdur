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
var espacement = 110;
var l = 100;
var h = 200;
var p = 10;
var x = - (espacement * 2 + espacement / 2);
var y = 0;
var z = 0;
var i = 0;
while(i <= 5)
{
   getCube3dPoints(univers,x,y,z,l,h,p,pt,pc,pa);
   this.createEmptyMovieClip("cube" + i,10000 + i);
   this["cube" + i].createApi(univers,createPtsArray(i * 8,8),"cube" + i,1,"cube",false,"global");
   this["cube" + i].apiNom = "cube" + i;
   this["cube" + i].idC = i;
   this["cube" + i].idPt = i * 8;
   x += espacement;
   i++;
}
univers.render(500);
this.saveRepere(univers,"save_lien");
