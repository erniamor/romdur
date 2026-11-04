MovieClip.prototype.activeCvBt = function()
{
   var _loc1_ = _global;
   var _loc2_ = this;
   _loc2_.cube0.onRollOver = function()
   {
      _global.snd_cv_over_1.start();
      _level0.MoteurApi.apiOn.cube0.styleId = 1;
      etireCvCubeX(0);
   };
   _loc2_.cube0.onRollOut = function()
   {
      _level0.MoteurApi.apiOn.cube0.styleId = 0;
      _global.snd_cv_out_1.start();
      retractCvCubeX(0);
   };
   _loc2_.cube1.onRollOver = function()
   {
      _level0.MoteurApi.apiOn.cube1.styleId = 1;
      _global.snd_cv_over_2.start();
      etireCvCubeX(8);
   };
   _loc2_.cube1.onRollOut = function()
   {
      _level0.MoteurApi.apiOn.cube1.styleId = 0;
      _global.snd_cv_out_2.start();
      retractCvCubeX(8);
   };
   _loc2_.cube2.onRollOver = function()
   {
      _level0.MoteurApi.apiOn.cube2.styleId = 1;
      _global.snd_cv_over_3.start();
      etireCvCubeX(16);
   };
   _loc2_.cube2.onRollOut = function()
   {
      _level0.MoteurApi.apiOn.cube2.styleId = 0;
      _global.snd_cv_out_3.start();
      retractCvCubeX(16);
   };
   _root.bt_retour.onRelease = function()
   {
      _root.cv.cvSortie();
   };
};
MovieClip.prototype.deactiveCvBt = function()
{
   var _loc1_ = this;
   delete _loc1_.cube0.onRollOver;
   delete _loc1_.cube0.onRollOut;
   delete _loc1_.cube0.onPress;
   delete _loc1_.cube1.onRollOver;
   delete _loc1_.cube1.onRollOut;
   delete _loc1_.cube1.onPress;
   delete _loc1_.cube2.onRollOver;
   delete _loc1_.cube2.onRollOut;
   delete _loc1_.cube2.onPress;
   delete _root.bt_retour.onRelease;
};
