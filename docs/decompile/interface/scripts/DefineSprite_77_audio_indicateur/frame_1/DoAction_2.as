function activeIndicateur()
{
   if(_global.data_audio[_global.idAudioInPlay].Nom.length > 40)
   {
      var nomTmp = _global.data_audio[_global.idAudioInPlay].Nom.slice(0,40) + "...";
      this.nom_txt.text = nomTmp;
   }
   else
   {
      this.nom_txt.text = _global.data_audio[_global.idAudioInPlay].Nom;
   }
   this.onEnterFrame = function()
   {
      with(_root.multimedia.mcAudio.audio_lecteur.piste)
      {
         var tempsCAff = Math.round(position / 1000);
         var tempsTAff = _global.data_audio[_global.idAudioInPlay].TempsSec;
         var tempsPc = tempsCAff / tempsTAff * 100;
         var loadC = getBytesLoaded();
         var loadT = getBytesTotal();
         var loadPc = loadC / loadPc * 100;
         var loadCAff = Math.round(loadC / 1024);
         var loadTAff = Math.round(loadT / 1024);
      }
      this.lu_recu_txt.text = tempsCAff + "/" + tempsTAff + " (s) - " + loadCAff + "/" + loadTAff + " (ko)";
      this.lu_barre._xscale = tempsPc;
      this.recu_barre._xscale = loadCAff / loadTAff * 100;
   };
}
this.lu_barre._alpha = 50;
this.recu_barre._alpha = 50;
this.recu_barre._xscale = 0;
this.lu_barre._xscale = 0;
