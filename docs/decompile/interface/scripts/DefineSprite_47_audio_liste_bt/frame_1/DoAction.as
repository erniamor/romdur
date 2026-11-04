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
   var _loc1_ = _root;
   _global.snd_glob_text_press.start();
   _global.idAudioActuel = this.id;
   _loc1_.multimedia.mcAudio.audio_lanceur.bt_lancer.activeBT();
   _loc1_.multimedia.mcAudio.audio_lanceur.bt_dl.activeBT();
   _loc1_.multimedia.mcAudio.audio_info.updateInfoAudio(this.id);
};
txt.embedFonts = true;
