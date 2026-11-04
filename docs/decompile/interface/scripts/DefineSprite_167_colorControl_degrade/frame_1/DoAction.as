function activeControl_degrade()
{
   var _loc1_ = this;
   _loc1_.onEnterFrame = function()
   {
      var _loc1_ = this;
      var _loc3_ = Math.round(- _loc1_.ra_mc.potarCurseur._y * 2 + 128);
      var $bv = Math.round(- _loc1_.va_mc.potarCurseur._y * 2 + 128);
      var _loc2_ = Math.round(- _loc1_.ba_mc.potarCurseur._y * 2 + 128);
      var $fr = Math.round(- _loc1_.rb_mc.potarCurseur._y * 2 + 128);
      var $fv = Math.round(- _loc1_.vb_mc.potarCurseur._y * 2 + 128);
      var $fb = Math.round(- _loc1_.bb_mc.potarCurseur._y * 2 + 128);
      _loc1_.ra_mc.potarCurseur._txt.text = _loc3_;
      _loc1_.va_mc.potarCurseur._txt.text = $bv;
      _loc1_.ba_mc.potarCurseur._txt.text = _loc2_;
      _loc1_.rb_mc.potarCurseur._txt.text = $fr;
      _loc1_.vb_mc.potarCurseur._txt.text = $fv;
      _loc1_.bb_mc.potarCurseur._txt.text = $fb;
      _root.colorPatch.updateDegrade(_loc3_,$bv,_loc2_,$fr,$fv,$fb);
   };
}
function desactiveControl_degrade()
{
   delete this.onEnterFrame;
}
function hexaToRgb(hexa)
{
   hex = hexa.toString(16);
   var bhex = hex.substr(-2,2);
   var _loc2_ = hex.substr(-4,2);
   var _loc3_ = hex.substr(-6,2);
   var _loc1_ = [parseInt(_loc3_,16),parseInt(_loc2_,16),parseInt(bhex,16)];
   return _loc1_;
}
stop();
MovieClip.prototype.actualiseControl_degrade = function()
{
   var _loc1_ = this;
   var _loc3_ = hexaToRgb(_global.colorDegrade[0]);
   var _loc2_ = hexaToRgb(_global.colorDegrade[1]);
   _loc1_.ra_mc.potarCurseur._txt.text = _loc3_[0];
   _loc1_.va_mc.potarCurseur._txt.text = _loc3_[1];
   _loc1_.ba_mc.potarCurseur._txt.text = _loc3_[2];
   _loc1_.rb_mc.potarCurseur._txt.text = _loc2_[0];
   _loc1_.vb_mc.potarCurseur._txt.text = _loc2_[1];
   _loc1_.bb_mc.potarCurseur._txt.text = _loc2_[2];
   var $$ra = _loc3_[0] / 2;
   var $$va = _loc3_[1] / 2;
   var $$ba = _loc3_[2] / 2;
   var $$rb = _loc2_[0] / 2;
   var $$vb = _loc2_[1] / 2;
   var $$bb = _loc2_[2] / 2;
   _loc1_.ra_mc.potarCurseur._y = 64 - $$ra;
   _loc1_.va_mc.potarCurseur._y = 64 - $$va;
   _loc1_.ba_mc.potarCurseur._y = 64 - $$ba;
   _loc1_.rb_mc.potarCurseur._y = 64 - $$rb;
   _loc1_.vb_mc.potarCurseur._y = 64 - $$vb;
   _loc1_.bb_mc.potarCurseur._y = 64 - $$bb;
};
this.ra_mc.potarCase.gotoAndStop(2);
this.va_mc.potarCase.gotoAndStop(3);
this.ba_mc.potarCase.gotoAndStop(4);
this.rb_mc.potarCase.gotoAndStop(2);
this.vb_mc.potarCase.gotoAndStop(3);
this.bb_mc.potarCase.gotoAndStop(4);
this.actualiseControl_degrade();
