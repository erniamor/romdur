MovieClip.prototype.updateInfoWeb = function(i)
{
   var _loc1_ = this;
   var _loc2_ = _global;
   if(i < 0)
   {
      _loc1_.nom_txt.text = "";
      _loc1_.lien_txt.text = "";
      _loc1_.date_txt.text = "";
      _loc1_.info_txt.text = "";
      _loc1_.introTechnique_txt.text = "";
      _loc1_.technique_txt.text = "";
      _loc1_.cible.unloadMovie();
   }
   else
   {
      _loc1_.nom_txt.text = _loc2_.data_web[i].Nom;
      _loc1_.lien_txt.text = _loc2_.data_web[i].Lien;
      _loc1_.date_txt.text = "date de mise en ligne : " + _loc2_.data_web[i].Date;
      _loc1_.info_txt.text = _loc2_.data_web[i].Info;
      _loc1_.introTechnique_txt.text = "caractéristiques techniques :";
      _loc1_.technique_txt.text = _loc2_.data_web[i].Technique;
      _loc1_.createEmptyMovieClip("capture_mc",4465);
      _loc1_.capture_mc._x = 0;
      _loc1_.capture_mc._y = -71;
      _loc1_.capture_mc.createEmptyMovieClip("cible",4535);
      _loc1_.capture_mc.cible.loadMovie("externdata/web/" + _loc2_.data_web[i].Fichier);
      _loc1_.capture_mc.onPress = function()
      {
         getURL(_global.data_web[i].Lien,"_blank");
      };
      _loc1_.capture_mc.onRollOver = function()
      {
         var _loc1_ = this;
         _loc1_._parent.lien_txt.textColor = "0xFFFFFF";
         _loc1_._parent.lien_txt.background = true;
         _loc1_._parent.lien_txt.border = true;
      };
      _loc1_.capture_mc.onRollOut = function()
      {
         var _loc1_ = this;
         _loc1_._parent.lien_txt.textColor = "0x000000";
         _loc1_._parent.lien_txt.background = false;
         _loc1_._parent.lien_txt.border = false;
      };
      _loc1_.onEnterFrame = function()
      {
         var _loc1_ = this;
         var _loc2_ = _loc1_.capture_mc.cible.getBytesLoaded() / 1000;
         var _loc3_ = _loc1_.capture_mc.cible.getBytesTotal() / 1000;
         _loc1_.percent_txt.text = "chargement ... " + 100 * _loc2_ / _loc3_ + " %";
         if(_loc2_ > 0 && _loc2_ >= _loc3_)
         {
            _loc1_.percent_txt.text = "";
            _loc1_.capture_mc.cible._x = - int(_loc1_.capture_mc.cible._width / 2);
            _loc1_.capture_mc.cible._y = - int(_loc1_.capture_mc.cible._height / 2);
            delete _loc1_.onEnterFrame;
         }
      };
   }
};
