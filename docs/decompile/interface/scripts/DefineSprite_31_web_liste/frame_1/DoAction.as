MovieClip.prototype.placeBT = function()
{
   var _loc2_ = this;
   var xInit = 0;
   var _loc3_ = -120;
   var _loc1_ = 0;
   while(_loc1_ < _global.data_web.length)
   {
      _loc2_.attachMovie("web_liste_bt","bt" + _loc1_,1000 + _loc1_);
      _loc2_["bt" + _loc1_]._x = xInit;
      _loc2_["bt" + _loc1_]._y = _loc3_;
      _loc2_["bt" + _loc1_].txt.text = _global.data_web[_loc1_].Nom;
      _loc2_["bt" + _loc1_].id = _loc1_;
      _loc3_ += 12;
      _loc1_ = _loc1_ + 1;
   }
};
