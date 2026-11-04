this.txt.border = false;
this.txt.background = false;
this.txt.textColor = "0x181731";
this.onRollOver = function()
{
   _global.snd_glob_text_over.start();
   this.txt.textColor = "0x494996";
};
this.onRollOut = function()
{
   this.txt.textColor = "0x181731";
};
this.onRelease = function()
{
   var _loc1_ = _root;
   var _loc2_ = _global;
   _loc2_.flash_idActuel = this.id;
   _loc2_.snd_glob_text_press.start();
   _loc1_.bt_retour.onRelease = function()
   {
      var _loc1_ = _root;
      _level66.Mouvement("_alpha",100,0,0,25,"easeInOutSine");
      retardateur(26,2,function()
      {
         unloadMovieNum(66);
      }
      );
      _loc1_.attachMovie("flash_liste_alone","flash_liste_alone",598546);
      _loc1_.flash_liste_alone._x = 490;
      _loc1_.flash_liste_alone._y = 365;
      _loc1_.bt_retour.onRelease = function()
      {
         var _loc1_ = _root;
         _loc1_.flash_liste_alone.Mouvement("_alpha",100,0,0,10,"easeInOutSine");
         retardateur(11,2,function()
         {
            var _loc1_ = _root;
            _loc1_.attachMovie("multimedia","multimedia",12);
            _loc1_.multimedia._x = 490;
            _loc1_.multimedia._y = 365;
            _loc1_.flash_liste_alone.removeMovieClip();
         }
         );
      };
   };
   _loc1_.createEmptyMovieClip("chargeur_swf",8888888838);
   loadMovieNum("externdata/flash/" + _loc2_.data_flash[_loc2_.flash_idActuel].Fichier + ".swf",66);
   _level66._visible = false;
   _loc1_.glob_txt.text = "chargement...";
   _loc1_.chargeur_swf.onEnterFrame = function()
   {
      if(_level66.getBytesTotal() > 0 && _level66.getBytesLoaded() >= _level66.getBytesTotal())
      {
         _root.glob_txt.text = "";
         _level66._visible = true;
         _level66._alpha = 0;
         _level66._x = (980 - _level66._width) / 2;
         _level66._y = (730 - _level66._height) / 2;
         _level66.Mouvement("_alpha",0,100,0,50,"easeInOutSine");
         delete this.onEnterFrame;
      }
   };
   _loc1_.flash_liste_alone.removeMovieClip();
};
txt.embedFonts = true;
