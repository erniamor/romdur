info_quitter._visible = false;
this.onRollOver = function()
{
   _global.snd_glob_fin.stop();
   _global.snd_glob_fin.start();
   this._xscale = 120;
   this._yscale = 120;
   info_quitter._visible = true;
};
this.onRollOut = function()
{
   this._xscale = 100;
   this._yscale = 100;
   info_quitter._visible = false;
};
this.onRelease = function()
{
   getURL("javascript: window.close()");
};
