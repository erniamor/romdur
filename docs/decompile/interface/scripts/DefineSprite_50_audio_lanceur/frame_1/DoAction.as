this.bt_lancer.txt.text = "écouter";
this.bt_lancer.funct = function()
{
   _global.idAudioInPlay = _global.idAudioActuel;
   _root.multimedia.mcAudio.audio_lecteur.activeLecteur();
};
this.bt_dl.txt.text = "télécharger";
this.bt_dl.funct = function()
{
   getURL("externdata/audio/" + _global.data_audio[_global.idAudioActuel].Fichier + ".rar","");
};
