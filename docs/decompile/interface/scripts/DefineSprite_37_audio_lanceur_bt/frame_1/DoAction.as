function activeBT()
{
   var _loc1_ = this;
   _loc1_.txt.textColor = "0x181731";
   _loc1_.onRollOver = function()
   {
      _global.snd_glob_text_over.start();
      this.txt.textColor = "0x494996";
   };
   _loc1_.onRollOut = function()
   {
      this.txt.textColor = "0x181731";
   };
   _loc1_.onRelease = function()
   {
      _global.snd_glob_text_press.start();
      funct();
   };
}
function deactiveBT()
{
   var _loc1_ = this;
   _loc1_.txt.textColor = "0x9B9AA0";
   delete _loc1_.onRollOver;
   delete _loc1_.onRollOut;
   delete _loc1_.onRelease;
}
deactiveBT();
txt.embedFonts = true;
stop();
