function activeAllInfoBtInit()
{
   with(_root.info)
   {
      var q = 0;
      while(q <= 4)
      {
         this["info_cube_" + q].onRollOver = function()
         {
            this.changeEtatCubeInfo();
         };
         this["info_cube_" + q].onRollOut = function()
         {
            this.changeEtatCubeInfo();
         };
         this["info_cube_" + q].onPress = function()
         {
            delete _root.info.onEnterFrame;
            selectInfoCube(this.id);
         };
         q++;
      }
   }
}
function activeAllInfoAutreBt()
{
   with(_root.info)
   {
      var p = 0;
      while(p <= 4)
      {
         this["info_cube_" + p].onRollOver = function()
         {
            this.changeEtatCubeInfo();
         };
         this["info_cube_" + p].onRollOut = function()
         {
            this.changeEtatCubeInfo();
         };
         this["info_cube_" + p].onPress = function()
         {
            selectInfoAutreCube(this.id);
         };
         p++;
      }
   }
}
function deactiveAllInfoBt()
{
   var _loc2_ = _root;
   var _loc1_ = 0;
   while(_loc1_ <= 4)
   {
      delete _loc2_.info["info_cube_" + _loc1_].onRollOver;
      delete _loc2_.info["info_cube_" + _loc1_].onRollOut;
      delete _loc2_.info["info_cube_" + _loc1_].onPress;
      _loc1_ = _loc1_ + 1;
   }
   delete _loc2_.bt_retour.onRelease;
}
