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
stop();
_global.data_info_nom = new Array("I","II","III","IV","V");
var univers = new Repere3d(500);
var i = 0;
while(i <= 4)
{
   univers.array.push(new Particle3d(-200,0,0,this,"info_cube",i));
   univers.rotateObjectZ(i,i + 7,72 * i);
   this["info_cube_" + i].etat = "blanc";
   this["info_cube_" + i].id = i;
   this["info_cube_" + i].info_nom.txt.text = _global.data_info_nom[i];
   i++;
}
getCercle3dPoints(univers,0,0,0,100,100,2,"0x496172",0);
this.createEmptyMovieClip("cercle",66666);
this.cercle.apiNom = "cercle";
this.cercle.colorCercleInfo(univers,0,1,"0xFFFFFF",50,"0xFFFFFF",0,true);
this.cercle.createApi(univers,createPtsArray(5,17),"cercle",0,"cercle",true,"global");
this.saveRepere(univers,"saveInfoRepere");
