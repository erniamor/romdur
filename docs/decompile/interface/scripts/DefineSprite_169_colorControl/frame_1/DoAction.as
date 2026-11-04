function activeControl()
{
   var _loc1_ = this;
   _loc1_.onEnterFrame = function()
   {
      var _loc1_ = this;
      var _loc2_ = Math.round(- _loc1_.bt_slider.potarCurseur._y / 12.7 + 5);
      var $br = Math.round(- _loc1_.br_slider.potarCurseur._y * 2 + 128);
      var $bv = Math.round(- _loc1_.bv_slider.potarCurseur._y * 2 + 128);
      var _loc3_ = Math.round(- _loc1_.bb_slider.potarCurseur._y * 2 + 128);
      var $ba = Math.round(- _loc1_.ba_slider.potarCurseur._y * 100 / 127 + 50);
      var $fr = Math.round(- _loc1_.fr_slider.potarCurseur._y * 2 + 128);
      var $fv = Math.round(- _loc1_.fv_slider.potarCurseur._y * 2 + 128);
      var $fb = Math.round(- _loc1_.fb_slider.potarCurseur._y * 2 + 128);
      var $fa = Math.round(- _loc1_.fa_slider.potarCurseur._y * 100 / 127 + 50);
      _loc1_.bt_slider.potarCurseur._txt.text = _loc2_;
      _loc1_.br_slider.potarCurseur._txt.text = $br;
      _loc1_.bv_slider.potarCurseur._txt.text = $bv;
      _loc1_.bb_slider.potarCurseur._txt.text = _loc3_;
      _loc1_.ba_slider.potarCurseur._txt.text = $ba;
      _loc1_.fr_slider.potarCurseur._txt.text = $fr;
      _loc1_.fv_slider.potarCurseur._txt.text = $fv;
      _loc1_.fb_slider.potarCurseur._txt.text = $fb;
      _loc1_.fa_slider.potarCurseur._txt.text = $fa;
      _root.colorPatch.updateStyle(_loc1_.id,_loc2_,[$br,$bv,_loc3_],$ba,[$fr,$fv,$fb],$fa);
   };
}
function desactiveControl()
{
   delete this.onEnterFrame;
}
function hexaToRgb(hexa)
{
   var _loc1_ = hexa;
   var bhex = _loc1_.substr(-2,2);
   var _loc3_ = _loc1_.substr(-4,2);
   var rhex = _loc1_.substr(-6,2);
   var _loc2_ = [parseInt(rhex,16),parseInt(_loc3_,16),parseInt(bhex,16)];
   return _loc2_;
}
stop();
MovieClip.prototype.actualiseControl = function(id)
{
   var _loc1_ = this;
   var $bt = _level0.MoteurApi.style[id][0];
   var _loc2_ = hexaToRgb(_level0.MoteurApi.style[id][1]);
   var $ba = _level0.MoteurApi.style[id][2];
   var _loc3_ = hexaToRgb(_level0.MoteurApi.style[id][3]);
   var $fa = _level0.MoteurApi.style[id][4];
   _loc1_.bt_slider.potarCurseur._txt.text = $bt;
   _loc1_.br_slider.potarCurseur._txt.text = _loc2_[0];
   _loc1_.bv_slider.potarCurseur._txt.text = _loc2_[1];
   _loc1_.bb_slider.potarCurseur._txt.text = _loc2_[2];
   _loc1_.ba_slider.potarCurseur._txt.text = $ba;
   _loc1_.fr_slider.potarCurseur._txt.text = _loc3_[0];
   _loc1_.fv_slider.potarCurseur._txt.text = _loc3_[1];
   _loc1_.fb_slider.potarCurseur._txt.text = _loc3_[2];
   _loc1_.fa_slider.potarCurseur._txt.text = $fa;
   var $$bt = $bt * 12.7;
   var $$br = _loc2_[0] / 2;
   var $$bv = _loc2_[1] / 2;
   var $$bb = _loc2_[2] / 2;
   var $$ba = $ba * 127 / 100;
   var $$fr = _loc3_[0] / 2;
   var $$fv = _loc3_[1] / 2;
   var $$fb = _loc3_[2] / 2;
   var $$fa = $fa * 127 / 100;
   _loc1_.bt_slider.potarCurseur._y = 64 - $$bt;
   _loc1_.br_slider.potarCurseur._y = 64 - $$br;
   _loc1_.bv_slider.potarCurseur._y = 64 - $$bv;
   _loc1_.bb_slider.potarCurseur._y = 64 - $$bb;
   _loc1_.ba_slider.potarCurseur._y = 64 - $$ba;
   _loc1_.fr_slider.potarCurseur._y = 64 - $$fr;
   _loc1_.fv_slider.potarCurseur._y = 64 - $$fv;
   _loc1_.fb_slider.potarCurseur._y = 64 - $$fb;
   _loc1_.fa_slider.potarCurseur._y = 64 - $$fa;
};
this.bt_slider.potarCase.gotoAndStop(1);
this.br_slider.potarCase.gotoAndStop(2);
this.bv_slider.potarCase.gotoAndStop(3);
this.bb_slider.potarCase.gotoAndStop(4);
this.ba_slider.potarCase.gotoAndStop(5);
this.fr_slider.potarCase.gotoAndStop(2);
this.fv_slider.potarCase.gotoAndStop(3);
this.fb_slider.potarCase.gotoAndStop(4);
this.fa_slider.potarCase.gotoAndStop(5);
this.actualiseControl(this.id);
