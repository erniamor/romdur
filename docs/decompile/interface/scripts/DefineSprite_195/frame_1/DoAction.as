function updateThemeText(argId)
{
   var _loc1_ = argId;
   var _loc2_ = _global;
   var _loc3_ = _root;
   if(_loc1_ == -1)
   {
      _loc3_.theme_mc.theme_txt.text = "theme aléatoire";
   }
   else if(_loc1_ < -1)
   {
      _loc3_.theme_mc.theme_txt.text = "theme modifié";
   }
   else
   {
      _loc3_.theme_mc.theme_txt.text = "theme actuel : \"" + _loc2_.dataOption[_loc1_].nom + "\" enregistré par \"" + _loc2_.dataOption[_loc1_].pseudo + "\" le " + _loc2_.dataOption[_loc1_].date;
   }
}
function applicPreset(argId)
{
   var _loc1_ = this;
   var _loc2_ = _global;
   var _loc3_ = argId;
   _loc2_.presetActuel = _loc3_;
   _loc1_._parent.updateThemeText(_loc2_.presetActuel);
   _loc1_.colorControl0.activeControl();
   _loc1_.colorControl1.activeControl();
   _loc1_.colorControl_degrade.activeControl_degrade();
   _loc1_.colorControl0.bt_slider.potarCurseur.mouvement("_y",undefined,_loc2_.dataOption[_loc3_].config[0],0,25,"linearTween");
   _loc1_.colorControl0.br_slider.potarCurseur.mouvement("_y",undefined,_loc2_.dataOption[_loc3_].config[1],0,25,"linearTween");
   _loc1_.colorControl0.bv_slider.potarCurseur.mouvement("_y",undefined,_loc2_.dataOption[_loc3_].config[2],0,25,"linearTween");
   _loc1_.colorControl0.bb_slider.potarCurseur.mouvement("_y",undefined,_loc2_.dataOption[_loc3_].config[3],0,25,"linearTween");
   _loc1_.colorControl0.ba_slider.potarCurseur.mouvement("_y",undefined,_loc2_.dataOption[_loc3_].config[4],0,25,"linearTween");
   _loc1_.colorControl0.fr_slider.potarCurseur.mouvement("_y",undefined,_loc2_.dataOption[_loc3_].config[5],0,25,"linearTween");
   _loc1_.colorControl0.fv_slider.potarCurseur.mouvement("_y",undefined,_loc2_.dataOption[_loc3_].config[6],0,25,"linearTween");
   _loc1_.colorControl0.fb_slider.potarCurseur.mouvement("_y",undefined,_loc2_.dataOption[_loc3_].config[7],0,25,"linearTween");
   _loc1_.colorControl0.fa_slider.potarCurseur.mouvement("_y",undefined,_loc2_.dataOption[_loc3_].config[8],0,25,"linearTween");
   _loc1_.colorControl1.bt_slider.potarCurseur.mouvement("_y",undefined,_loc2_.dataOption[_loc3_].config[9],0,25,"linearTween");
   _loc1_.colorControl1.br_slider.potarCurseur.mouvement("_y",undefined,_loc2_.dataOption[_loc3_].config[10],0,25,"linearTween");
   _loc1_.colorControl1.bv_slider.potarCurseur.mouvement("_y",undefined,_loc2_.dataOption[_loc3_].config[11],0,25,"linearTween");
   _loc1_.colorControl1.bb_slider.potarCurseur.mouvement("_y",undefined,_loc2_.dataOption[_loc3_].config[12],0,25,"linearTween");
   _loc1_.colorControl1.ba_slider.potarCurseur.mouvement("_y",undefined,_loc2_.dataOption[_loc3_].config[13],0,25,"linearTween");
   _loc1_.colorControl1.fr_slider.potarCurseur.mouvement("_y",undefined,_loc2_.dataOption[_loc3_].config[14],0,25,"linearTween");
   _loc1_.colorControl1.fv_slider.potarCurseur.mouvement("_y",undefined,_loc2_.dataOption[_loc3_].config[15],0,25,"linearTween");
   _loc1_.colorControl1.fb_slider.potarCurseur.mouvement("_y",undefined,_loc2_.dataOption[_loc3_].config[16],0,25,"linearTween");
   _loc1_.colorControl1.fa_slider.potarCurseur.mouvement("_y",undefined,_loc2_.dataOption[_loc3_].config[17],0,25,"linearTween");
   _loc1_.colorControl_degrade.ra_mc.potarCurseur.mouvement("_y",undefined,_loc2_.dataOption[_loc3_].config[18],0,25,"linearTween");
   _loc1_.colorControl_degrade.va_mc.potarCurseur.mouvement("_y",undefined,_loc2_.dataOption[_loc3_].config[19],0,25,"linearTween");
   _loc1_.colorControl_degrade.ba_mc.potarCurseur.mouvement("_y",undefined,_loc2_.dataOption[_loc3_].config[20],0,25,"linearTween");
   _loc1_.colorControl_degrade.rb_mc.potarCurseur.mouvement("_y",undefined,_loc2_.dataOption[_loc3_].config[21],0,25,"linearTween");
   _loc1_.colorControl_degrade.vb_mc.potarCurseur.mouvement("_y",undefined,_loc2_.dataOption[_loc3_].config[22],0,25,"linearTween");
   _loc1_.colorControl_degrade.bb_mc.potarCurseur.mouvement("_y",undefined,_loc2_.dataOption[_loc3_].config[23],0,25,"linearTween");
   retardateur(26,2,function()
   {
      var _loc1_ = _root;
      _loc1_.colorPatch.colorControl0.desactiveControl();
      _loc1_.colorPatch.colorControl1.desactiveControl();
      _loc1_.colorPatch.colorControl_degrade.desactiveControl_degrade();
   }
   );
}
function recupOptionValue()
{
   var _loc2_ = this;
   var _loc1_ = new Array();
   _loc1_.push(_loc2_.colorControl0.bt_slider.potarCurseur._y);
   _loc1_.push(_loc2_.colorControl0.br_slider.potarCurseur._y);
   _loc1_.push(_loc2_.colorControl0.bv_slider.potarCurseur._y);
   _loc1_.push(_loc2_.colorControl0.bb_slider.potarCurseur._y);
   _loc1_.push(_loc2_.colorControl0.ba_slider.potarCurseur._y);
   _loc1_.push(_loc2_.colorControl0.fr_slider.potarCurseur._y);
   _loc1_.push(_loc2_.colorControl0.fv_slider.potarCurseur._y);
   _loc1_.push(_loc2_.colorControl0.fb_slider.potarCurseur._y);
   _loc1_.push(_loc2_.colorControl0.fa_slider.potarCurseur._y);
   _loc1_.push(_loc2_.colorControl1.bt_slider.potarCurseur._y);
   _loc1_.push(_loc2_.colorControl1.br_slider.potarCurseur._y);
   _loc1_.push(_loc2_.colorControl1.bv_slider.potarCurseur._y);
   _loc1_.push(_loc2_.colorControl1.bb_slider.potarCurseur._y);
   _loc1_.push(_loc2_.colorControl1.ba_slider.potarCurseur._y);
   _loc1_.push(_loc2_.colorControl1.fr_slider.potarCurseur._y);
   _loc1_.push(_loc2_.colorControl1.fv_slider.potarCurseur._y);
   _loc1_.push(_loc2_.colorControl1.fb_slider.potarCurseur._y);
   _loc1_.push(_loc2_.colorControl1.fa_slider.potarCurseur._y);
   _loc1_.push(_loc2_.colorControl_degrade.ra_mc.potarCurseur._y);
   _loc1_.push(_loc2_.colorControl_degrade.va_mc.potarCurseur._y);
   _loc1_.push(_loc2_.colorControl_degrade.ba_mc.potarCurseur._y);
   _loc1_.push(_loc2_.colorControl_degrade.rb_mc.potarCurseur._y);
   _loc1_.push(_loc2_.colorControl_degrade.vb_mc.potarCurseur._y);
   _loc1_.push(_loc2_.colorControl_degrade.bb_mc.potarCurseur._y);
   var _loc3_ = _loc1_.join("_");
   return _loc3_;
}
function startRandomOption()
{
   var _loc1_ = this;
   var _loc2_ = _root;
   _loc1_.colorControl0.activeControl();
   _loc1_.colorControl1.activeControl();
   _loc1_.colorControl_degrade.activeControl_degrade();
   _loc1_.colorControl0.bt_slider.potarCurseur.mouvement("_y",undefined,random(66) - 34,0,25,"linearTween");
   _loc1_.colorControl0.br_slider.potarCurseur.mouvement("_y",undefined,random(64) - 32,0,25,"linearTween");
   _loc1_.colorControl0.bv_slider.potarCurseur.mouvement("_y",undefined,random(64) - 32,0,25,"linearTween");
   _loc1_.colorControl0.bb_slider.potarCurseur.mouvement("_y",undefined,random(64) - 32,0,25,"linearTween");
   _loc1_.colorControl0.ba_slider.potarCurseur.mouvement("_y",undefined,random(64) - 32,0,25,"linearTween");
   _loc1_.colorControl0.fr_slider.potarCurseur.mouvement("_y",undefined,random(64) - 32,0,25,"linearTween");
   _loc1_.colorControl0.fv_slider.potarCurseur.mouvement("_y",undefined,random(64) - 32,0,25,"linearTween");
   _loc1_.colorControl0.fb_slider.potarCurseur.mouvement("_y",undefined,random(64) - 32,0,25,"linearTween");
   _loc1_.colorControl0.fa_slider.potarCurseur.mouvement("_y",undefined,random(64) - 32,0,25,"linearTween");
   _loc1_.colorControl1.bt_slider.potarCurseur.mouvement("_y",undefined,random(66) - 34,0,25,"linearTween");
   _loc1_.colorControl1.br_slider.potarCurseur.mouvement("_y",undefined,random(64) - 32,0,25,"linearTween");
   _loc1_.colorControl1.bv_slider.potarCurseur.mouvement("_y",undefined,random(64) - 32,0,25,"linearTween");
   _loc1_.colorControl1.bb_slider.potarCurseur.mouvement("_y",undefined,random(64) - 32,0,25,"linearTween");
   _loc1_.colorControl1.ba_slider.potarCurseur.mouvement("_y",undefined,random(64) - 32,0,25,"linearTween");
   _loc1_.colorControl1.fr_slider.potarCurseur.mouvement("_y",undefined,random(64) - 32,0,25,"linearTween");
   _loc1_.colorControl1.fv_slider.potarCurseur.mouvement("_y",undefined,random(64) - 32,0,25,"linearTween");
   _loc1_.colorControl1.fb_slider.potarCurseur.mouvement("_y",undefined,random(64) - 32,0,25,"linearTween");
   _loc1_.colorControl1.fa_slider.potarCurseur.mouvement("_y",undefined,random(64) - 32,0,25,"linearTween");
   _loc1_.colorControl_degrade.ra_mc.potarCurseur.mouvement("_y",undefined,random(64) - 32,0,25,"linearTween");
   _loc1_.colorControl_degrade.va_mc.potarCurseur.mouvement("_y",undefined,random(64) - 32,0,25,"linearTween");
   _loc1_.colorControl_degrade.ba_mc.potarCurseur.mouvement("_y",undefined,random(64) - 32,0,25,"linearTween");
   _loc1_.colorControl_degrade.rb_mc.potarCurseur.mouvement("_y",undefined,random(64) - 32,0,25,"linearTween");
   _loc1_.colorControl_degrade.vb_mc.potarCurseur.mouvement("_y",undefined,random(64) - 32,0,25,"linearTween");
   _loc1_.colorControl_degrade.bb_mc.potarCurseur.mouvement("_y",undefined,random(64) - 32,0,25,"linearTween");
   retardateur(26,2,function()
   {
      var _loc1_ = _root;
      _loc1_.colorPatch.colorControl0.desactiveControl();
      _loc1_.colorPatch.colorControl1.desactiveControl();
      _loc1_.colorPatch.colorControl_degrade.desactiveControl_degrade();
   }
   );
}
this._txt.embedFonts = true;
stop();
_global.presetActuel = 0;
this.saveOption_btn._txt.text = "sauvegarder";
this.saveOption_btn.onRelease = function()
{
   _root.option_quest_mc.gotoAndStop(2);
};
this.randomOption_btn._txt.text = "aléatoire";
this.randomOption_btn.onRelease = function()
{
   _global.presetActuel = -1;
   this._parent.updateThemeText(_global.presetActuel);
   this._parent.startRandomOption();
};
