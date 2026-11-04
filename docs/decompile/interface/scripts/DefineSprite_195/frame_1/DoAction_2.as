function updateStyle(idStyle, bt, bc, ba, fc, fa)
{
   var _loc1_ = idStyle;
   var _loc2_ = fc;
   var _loc3_ = bc;
   _level0.MoteurApi.style[_loc1_][0] = bt != undefined ? bt : _level0.MoteurApi.style[_loc1_][0];
   _level0.MoteurApi.style[_loc1_][1] = _loc3_ != undefined ? rgbToHexa(_loc3_[0],_loc3_[1],_loc3_[2]) : _level0.MoteurApi.style[_loc1_][1];
   _level0.MoteurApi.style[_loc1_][2] = ba != undefined ? ba : _level0.MoteurApi.style[_loc1_][2];
   _level0.MoteurApi.style[_loc1_][3] = _loc2_ != undefined ? rgbToHexa(_loc2_[0],_loc2_[1],_loc2_[2]) : _level0.MoteurApi.style[_loc1_][3];
   _level0.MoteurApi.style[_loc1_][4] = fa != undefined ? fa : _level0.MoteurApi.style[_loc1_][4];
}
function updateDegrade(ra, va, ba, rb, vb, bb)
{
   _global.colorDegrade = [rgbToHexa(ra,va,ba),rgbToHexa(rb,vb,bb)];
   _root.degrade.update();
}
function rgbToHexa(r, v, b)
{
   var _loc3_ = r << 16 | v << 8 | b;
   var _loc1_ = _loc3_.toString(16);
   var _loc2_ = 6 - _loc1_.length;
   while(_loc2_--)
   {
      _loc1_ = "0" + _loc1_;
   }
   var resultat = "0x" + _loc1_.toUpperCase();
   return Number(resultat);
}
stop();
this.colorControl0.id = 0;
this.colorControl1.id = 1;
this.colorPatchFond._alpha = 30;
