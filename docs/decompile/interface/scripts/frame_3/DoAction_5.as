function connectionDataOption()
{
   var _loc1_ = _root;
   _loc1_.varCible.text = "";
   loadVariables("concat.php","","POST");
   _loc1_.createEmptyMovieClip("timedataoption",-5445454);
   _loc1_.timedataoption.onEnterFrame = function()
   {
      if(_root.varCible.text != "")
      {
         _root.recupDataOption();
         delete this.onEnterFrame;
      }
   };
}
function recupDataOption()
{
   var _loc3_ = _global;
   var donnees_str = this.varCible.text;
   var donnees_str_tronk = donnees_str.substring(0,donnees_str.length - 1);
   var _loc2_ = donnees_str_tronk.split("§");
   _loc3_.dataOption = new Array();
   var _loc1_ = 0;
   while(_loc1_ < _loc2_.length)
   {
      _loc3_.dataOption[_loc1_] = new presetItem(_loc2_[_loc1_].split("|"));
      _loc1_ = _loc1_ + 1;
   }
   _root.colorPatch.preset_mc.initPreset();
}
function presetItem(argElem)
{
   var _loc1_ = argElem;
   var _loc2_ = this;
   _loc2_.id = _loc1_[0];
   _loc2_.nom = _loc1_[1];
   _loc2_.pseudo = _loc1_[2];
   _loc2_.config = _loc1_[3].split("_");
   _loc2_.date = _loc1_[4];
}
this.varCible.embedFonts = true;
this.varCible.autoSize = true;
_root.attachMovie("option_quest_mc","option_quest_mc",99999999999);
this.option_quest_mc._x = 490;
this.option_quest_mc._y = 365;
connectionDataOption();
donnees = "I§II§III§IV";
donneesMultimedia = "I§II§III§IV";
_global.Data = donnees.split("§");
_global.DataMultimedia = donneesMultimedia.split("§");
_root.theme_mc._alpha = 0;
this.option_btn.valid = false;
this.option_btn.onRollOver = function()
{
   var _loc1_ = this;
   _loc1_._xscale = 120;
   _loc1_._yscale = 120;
   _loc1_._txt._visible = true;
};
this.option_btn.onRollOut = function()
{
   var _loc1_ = this;
   _loc1_._xscale = 100;
   _loc1_._yscale = 100;
   _loc1_._txt._visible = false;
};
this.option_btn.onRelease = function()
{
   var _loc1_ = this;
   if(_loc1_.valid == true)
   {
      _root.theme_mc.mouvement("_alpha",undefined,0,0,10,"easeInOutSine");
      _loc1_._parent.colorPatch.mouvement("_x",undefined,1100,0,10,"easeInCubic");
      _loc1_.valid = false;
   }
   else
   {
      _root.theme_mc.mouvement("_alpha",undefined,100,0,10,"easeInOutSine");
      _loc1_._parent.colorPatch.mouvement("_x",undefined,865,0,10,"easeOutCubic");
      _loc1_.valid = true;
   }
};
_global.firstEnter = true;
_root.option_btn.Mouvement("_alpha",0,100,0,25,"easeInOutSine");
_root.bt_retour.Mouvement("_alpha",0,100,0,25,"easeInOutSine");
_root.bt_quitter.Mouvement("_alpha",0,100,0,25,"easeInOutSine");
_root.attachMovie("E","E",10);
stop();
