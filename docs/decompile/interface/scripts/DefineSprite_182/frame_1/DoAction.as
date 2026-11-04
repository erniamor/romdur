info_retour._visible = false;
this.onRollOver = function()
{
   _global.snd_glob_retour.stop();
   _global.snd_glob_retour.start();
   this._xscale = 120;
   this._yscale = 120;
   info_retour._visible = true;
};
this.onRollOut = function()
{
   this._xscale = 100;
   this._yscale = 100;
   info_retour._visible = false;
};
