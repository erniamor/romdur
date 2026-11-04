this._txt.textColor = "0x181731";
this.onRollOver = function()
{
   _global.snd_glob_text_over.start();
   this._txt.textColor = "0x494996";
};
this.onRollOut = function()
{
   this._txt.textColor = "0x181731";
};
this._txt.embedFonts = true;
stop();
