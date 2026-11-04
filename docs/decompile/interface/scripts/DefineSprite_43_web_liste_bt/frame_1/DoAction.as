this.txt.border = false;
this.txt.background = false;
this.txt.textColor = "0x181731";
this.onRollOver = function()
{
   _global.snd_glob_text_over.start();
   this.txt.textColor = "0x494996";
};
this.onRollOut = function()
{
   this.txt.textColor = "0x181731";
};
this.onRelease = function()
{
   _global.snd_glob_text_press.start();
   _root.multimedia.mcWeb.web_info.updateInfoWeb(this.id);
};
txt.embedFonts = true;
stop();
