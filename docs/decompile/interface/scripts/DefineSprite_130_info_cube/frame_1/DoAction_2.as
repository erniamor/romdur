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
function changeEtatCubeInfo()
{
   with(this)
   {
      if(etat == "blanc")
      {
         _global["snd_info_amb_" + (this.id + 1)].stop();
         _level0.MoteurApi.apiOn["cube" + this.id].styleId = 0;
         etat = "noir";
      }
      else
      {
         _global["snd_info_amb_" + (this.id + 1)].start(0,9999999999999);
         _level0.MoteurApi.apiOn["cube" + this.id].styleId = 1;
         etat = "blanc";
      }
   }
}
stop();
var univers = new Repere3d(500);
var pt = 0;
var pc = "0x000000";
var pa = 0;
this.getCube3dPoints(univers,0,0,0,50,50,50,pt,pc,pa);
this.createEmptyMovieClip("cube" + this.id,10000);
this["cube" + this.id].createApi(univers,createPtsArray(0,8),"cube" + this.id,1,"cube",true,"global");
this.onEnterFrame = function()
{
   univers.rotateXY(_ymouse / 50,(- _xmouse) / 50);
};
this.cube0.info_nom.txt.text = _global.data_info_nom[this.id];
