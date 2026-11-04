if(_global.data_lien[_global.idLienActuel].Site[0].Genre != "")
{
   this.crea_txt.text = "Création";
   this.outil_txt.text = "Outil";
}
else
{
   this.crea_txt.text = "Liste";
   this.outil_txt.text = "";
}
this.liste_outil.typeGenre = "outil";
this.liste_creation.typeGenre = "creation";
this.lien_menu_txt.text = _global.data_lien[_global.idLienActuel].Nom;
lien_menu_txt.embedFonts = true;
outil_txt.embedFonts = true;
crea_txt.embedFonts = true;
