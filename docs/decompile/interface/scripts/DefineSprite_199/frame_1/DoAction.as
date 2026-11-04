function soundAmbient_accueil()
{
   var _loc3_ = _root;
   _loc3_.sample.onEnterFrame = function()
   {
      var _loc2_ = _root.E.univers.array[87].position.x / 3;
      _global.snd_menu_amb_1.setPan(_loc2_);
      var _loc1_ = (_root.E.univers.array[87].position.x + 300) / 6;
      _global.snd_menu_amb_2.setVolume(_loc1_);
   };
}
function soundAmbient_multi()
{
   var _loc1_ = _root;
   var _loc2_ = _global;
   trace("soundAmbient_accueil");
   _loc1_.sample.onEnterFrame = function()
   {
      var _loc1_ = _global;
      var _loc2_ = _root;
      var p1 = (- _loc2_.multimedia.univers.array[4].position.z) / 2;
      var v1 = (p1 + 100) / 2;
      _loc1_.snd_multi_amb_1.setVolume(v1);
      var p2 = (- _loc2_.multimedia.univers.array[12].position.z) / 2;
      var v2 = (p2 + 100) / 2;
      _loc1_.snd_multi_amb_2.setVolume(v2);
      var p3 = (- _loc2_.multimedia.univers.array[20].position.z) / 2;
      var v3 = (p3 + 100) / 2;
      _loc1_.snd_multi_amb_3.setVolume(v3);
      var _loc3_ = (- _loc2_.multimedia.univers.array[28].position.z) / 2;
      var v4 = _loc3_ + 100;
      _loc1_.snd_multi_amb_4.setVolume(v4);
   };
}
function soundAmbient_flash()
{
   _root.sample.onEnterFrame = function()
   {
      var _loc2_ = (- _root.multimedia.univers.array[32].position.z) / 3;
      var _loc1_ = Math.round((_loc2_ + 150) / 2);
      _global.snd_multi_flash_amb.setVolume(_loc1_);
   };
}
function soundAmbient_web()
{
   _root.sample.onEnterFrame = function()
   {
      var _loc2_ = (- _root.multimedia.univers.array[32].position.z) / 3;
      var _loc1_ = Math.round((_loc2_ + 150) / 2);
      _global.snd_multi_web_amb.setVolume(_loc1_);
      trace(_global.snd_multi_web_amb.getVolume());
   };
}
function soundAmbient_cv()
{
   _root.sample.onEnterFrame = function()
   {
      var _loc1_ = _ymouse / 2;
      var _loc3_ = _loc1_ < 0 ? Math.abs(_loc1_) : 0;
      var _loc2_ = _loc1_ < 0 ? 0 : _loc1_;
      _global.snd_cv_rot_2.setVolume(_loc3_);
      _global.snd_cv_rot_1.setVolume(_loc2_);
   };
}
function soundAmbient_lien()
{
   var _loc1_ = _global;
   var _loc2_ = _root;
   _loc2_.sample.onEnterFrame = function()
   {
      var _loc1_ = _global;
      var _loc2_ = _root;
      var p1 = _loc2_.lien.univers.array[4].position.z / 3;
      var p1x = _loc2_.lien.univers.array[4].position.x / 3;
      var v1 = Math.round(-15 * (p1 + 110) / 22 + 150);
      _loc1_.snd_lien_pos_1.setVolume(v1);
      _loc1_.snd_lien_pos_1.setPan(p1x);
      var p2 = _loc2_.lien.univers.array[45].position.z / 3;
      var _loc3_ = _loc2_.lien.univers.array[45].position.x / 3;
      var v2 = Math.round(-15 * (p2 + 110) / 22 + 150);
      _loc1_.snd_lien_pos_2.setVolume(v2);
      _loc1_.snd_lien_pos_2.setPan(_loc3_);
      var r1 = Math.max((_xmouse / 3 + 50) / 2,0);
      var r2 = Math.max(((- _xmouse) / 3 + 50) / 2,0);
      _loc1_.snd_lien_rot_1.setVolume(r2);
      _loc1_.snd_lien_rot_2.setVolume(r1);
   };
}
function soundAmbient_info()
{
   _root.sample.onEnterFrame = function()
   {
      var _loc1_ = 0;
      var _loc3_;
      var _loc2_;
      while(_loc1_ <= 4)
      {
         _loc3_ = (- _root.info.univers.array[_loc1_].position.z) / 2;
         _loc2_ = Math.round((_loc3_ + 100) / 2);
         var x = _root.info.univers.array[_loc1_].position.x / 2;
         _global["snd_info_amb_" + (_loc1_ + 1)].setVolume(_loc2_);
         _global["snd_info_amb_" + (_loc1_ + 1)].setPan(x);
         _loc1_ = _loc1_ + 1;
      }
   };
}
