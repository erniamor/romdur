MovieClip.prototype.updateInfoLien = function(i)
{
   var _loc1_ = this;
   var _loc2_ = _global;
   if(i < 0)
   {
      _loc1_.lien_nom_mc.nom_txt.text = "";
      _loc1_.lien_txt.text = "";
      _loc1_.info_txt.text = "";
      _loc1_.capture_mc.cible.unloadMovie();
      _loc1_.capture_mc.removeMovieClip();
   }
   else
   {
      _loc1_.lien_nom_mc.nom_txt.text = _loc2_.data_lien[_loc2_.idLienActuel].Site[i].Nom;
      _loc1_.lien_txt.text = _loc2_.data_lien[_loc2_.idLienActuel].Site[i].Lien;
      _loc1_.info_txt.text = _loc2_.data_lien[_loc2_.idLienActuel].Site[i].Info;
      _loc1_.lien_nom_mc.onPress = function()
      {
         getURL(_global.data_lien[_global.idLienActuel].Site[i].Lien,"_blank");
      };
      _loc1_.lien_nom_mc.onRollOver = function()
      {
         var _loc1_ = this;
         _loc1_._parent.lien_txt.textColor = "0xFFFFFF";
         _loc1_._parent.lien_txt.background = true;
         _loc1_._parent.lien_txt.border = true;
      };
      _loc1_.lien_nom_mc.onRollOut = function()
      {
         var _loc1_ = this;
         _loc1_._parent.lien_txt.textColor = "0x111111";
         _loc1_._parent.lien_txt.background = false;
         _loc1_._parent.lien_txt.border = false;
      };
      if(_loc2_.data_lien[_loc2_.idLienActuel].Site[i].Capture != "")
      {
         _loc1_.createEmptyMovieClip("capture_mc",4465);
         _loc1_.capture_mc._x = 0;
         _loc1_.capture_mc._y = -77;
         _loc1_.capture_mc.createEmptyMovieClip("cible",4535);
         _loc1_.capture_mc.cible.loadMovie("externdata/lien/" + _loc2_.data_lien[_loc2_.idLienActuel].Site[i].Capture);
         _loc1_.capture_mc.onPress = function()
         {
            getURL(_global.data_lien[_global.idLienActuel].Site[i].Lien,"_blank");
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
            _loc1_._parent.lien_txt.textColor = "0x111111";
            _loc1_._parent.lien_txt.background = false;
            _loc1_._parent.lien_txt.border = false;
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
               _loc1_.capture_mc.cible.Mouvement("_alpha",0,100,0,10,"easeInOutCubic");
               delete _loc1_.onEnterFrame;
            }
         };
      }
      else
      {
         _loc1_.capture_mc.cible.unloadMovie();
         _loc1_.percent_txt.text = "pas d\'image";
      }
   }
};
