MovieClip.prototype.updateInfoAudio = function(i)
{
   var _loc1_ = _global;
   var _loc2_ = this;
   var _loc3_ = i;
   _loc2_.nom_txt.text = _loc1_.data_audio[_loc3_].Nom;
   _loc2_.auteur_txt.text = _loc1_.data_audio[_loc3_].Auteur;
   _loc2_.annee_txt.text = _loc1_.data_audio[_loc3_].Annee;
   _loc2_.genre_txt.text = _loc1_.data_audio[_loc3_].Genre;
   _loc2_.note_txt.text = _loc1_.data_audio[_loc3_].Note;
   _loc2_.temps_txt.text = _loc1_.data_audio[_loc3_].Temps;
   _loc2_.poids_txt.text = _loc1_.data_audio[_loc3_].Poids;
};
this.nom_txt.embedFonts = true;
this.auteur_txt.embedFonts = true;
this.annee_txt.embedFonts = true;
this.genre_txt.embedFonts = true;
this.note_txt.embedFonts = true;
this.temps_txt.embedFonts = true;
this.poids_txt.embedFonts = true;
