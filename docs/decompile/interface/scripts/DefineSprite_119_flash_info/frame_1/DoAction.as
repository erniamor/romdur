MovieClip.prototype.updateInfoFlash = function(i)
{
   var _loc1_ = this;
   var _loc2_ = i;
   var _loc3_ = _global;
   _loc3_.flash_idActuel = _loc2_;
   if(_loc2_ < 0)
   {
      _loc1_.nom_txt.text = "";
      _loc1_.genre_txt.text = "";
      _loc1_.description_txt.text = "";
      _loc1_.percent_txt.text = "";
      _loc1_.poids_txt.text = "";
      _loc1_.flash_lancer_btn.txt.text = "";
      _loc1_.flash_telecharger_btn.txt.text = "";
      _loc1_.capture_mc.cible.unloadMovie();
   }
   else
   {
      _loc1_.flash_lancer_btn.txt.text = "lancer";
      _loc1_.flash_telecharger_btn.txt.text = "télécharger";
      _loc1_.nom_txt.text = _loc3_.data_flash[_loc2_].Nom;
      _loc1_.genre_txt.text = _loc3_.data_flash[_loc2_].Genre;
      _loc1_.description_txt.text = _loc3_.data_flash[_loc2_].Description;
      _loc1_.poids_txt.text = "Poids de l\'animation : " + _loc3_.data_flash[_loc2_].Poids;
      _loc1_.createEmptyMovieClip("capture_mc",4470);
      _loc1_.capture_mc._x = 0;
      _loc1_.capture_mc._y = -65;
      _loc1_.capture_mc.createEmptyMovieClip("cible",4535);
      _loc1_.capture_mc.cible.loadMovie("externdata/flash/" + _loc3_.data_flash[_loc2_].Image + ".jpg");
      _loc1_.capture_mc.id = _loc2_;
      _loc1_.capture_mc.onPress = function()
      {
         _root.multimedia.flash_quest_mc.gotoAndStop(2);
      };
      _loc1_.capture_mc.onRollOver = function()
      {
         this._parent.nom_txt._yscale = 120;
      };
      _loc1_.capture_mc.onRollOut = function()
      {
         this._parent.nom_txt._yscale = 100;
      };
      _loc1_.onEnterFrame = function()
      {
         var _loc1_ = this;
         var _loc2_ = _loc1_.capture_mc.cible.getBytesLoaded() / 1000;
         var _loc3_ = _loc1_.capture_mc.cible.getBytesTotal() / 1000;
         _loc1_.percent_txt.text = "chargement ... " + Math.round(100 * _loc2_ / _loc3_) + " %";
         if(_loc2_ > 0 && _loc2_ >= _loc3_)
         {
            _loc1_.percent_txt.text = "";
            _loc1_.capture_mc.cible._alpha = 0;
            _loc1_.capture_mc.cible._x = - int(_loc1_.capture_mc.cible._width / 2);
            _loc1_.capture_mc.cible._y = - int(_loc1_.capture_mc.cible._height / 2);
            _loc1_.capture_mc.cible.Mouvement("_alpha",0,100,0,10,"easeInOutSine");
            delete _loc1_.onEnterFrame;
         }
      };
   }
};
