stop();
this.potarLigne._alpha = 0;
this.potarCurseur._alpha = 0;
this._parent._txt.embedFonts = true;
this._parent._txt.autoSize = true;
this.potarCase.onPress = function()
{
   var _loc1_ = this;
   _global.presetActuel = -2;
   _root.colorPatch.updateThemeText(_global.presetActuel);
   _loc1_._parent._parent.activeControl();
   _loc1_._parent.potarCurseur.startDrag(false,7,-63,7,63);
   _loc1_._parent.potarLigne._alpha = 100;
   _loc1_._parent.potarCurseur._alpha = 100;
};
this.potarCase.onRelease = this.potarCase.onReleaseOutside = function()
{
   var _loc1_ = this;
   _loc1_._parent.potarCurseur.stopDrag();
   _loc1_._parent._parent.desactiveControl();
   _loc1_._parent.potarCurseur._alpha = 0;
   _loc1_._parent.potarLigne._alpha = 0;
};
