stop();
this._txt.embedFonts = true;
this._txt.textColor = "0x181731";
this.onRollOver = function()
{
   var _loc1_ = _global;
   var _loc2_ = this;
   _root.theme_mc.theme_txt.text = "\"" + _loc1_.dataOption[_loc2_.id].nom + "\" enregistré par \"" + _loc1_.dataOption[_loc2_.id].pseudo + "\" le " + _loc1_.dataOption[_loc2_.id].date;
   _loc1_.snd_glob_text_over.start();
   _loc2_._txt.textColor = "0x494996";
};
this.onRollOut = function()
{
   _root.colorPatch.updateThemeText(_global.presetActuel);
   this._txt.textColor = "0x181731";
};
this.onRelease = function()
{
   _global.snd_glob_text_press.start();
   _root.colorPatch.applicPreset(this.id);
};
