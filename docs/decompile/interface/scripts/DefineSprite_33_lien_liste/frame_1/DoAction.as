MovieClip.prototype.placeBT = function(genre)
{
   var _loc2_ = _global;
   var _loc3_ = this;
   var xInit = 5;
   var yInit = 5;
   var _loc1_ = 0;
   while(_loc1_ < _loc2_.data_lien[_loc2_.idLienActuel].Site.length)
   {
      if(_loc2_.data_lien[_loc2_.idLienActuel].Site[_loc1_].Genre == genre)
      {
         _loc3_.attachMovie("lien_liste_bt","bt" + _loc1_,1000 + _loc1_);
         _loc3_["bt" + _loc1_]._x = xInit;
         _loc3_["bt" + _loc1_]._y = yInit;
         _loc3_["bt" + _loc1_].txt.text = _loc2_.data_lien[_loc2_.idLienActuel].Site[_loc1_].Nom;
         _loc3_["bt" + _loc1_].id = _loc1_;
         yInit += 14;
      }
      else if(genre == "creation" && _loc2_.data_lien[_loc2_.idLienActuel].Site[_loc1_].Genre == "")
      {
         _loc3_.attachMovie("lien_liste_bt","bt" + _loc1_,1000 + _loc1_);
         _loc3_["bt" + _loc1_]._x = xInit;
         _loc3_["bt" + _loc1_]._y = yInit;
         _loc3_["bt" + _loc1_].txt.text = _loc2_.data_lien[_loc2_.idLienActuel].Site[_loc1_].Nom;
         _loc3_["bt" + _loc1_].id = _loc1_;
         yInit += 14;
      }
      _loc1_ = _loc1_ + 1;
   }
};
