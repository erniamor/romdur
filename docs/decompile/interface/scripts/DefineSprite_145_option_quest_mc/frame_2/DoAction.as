this.setMask(this.flash_quest_mask);
this.flash_quest_mask._yscale = 0;
this.flash_quest_mask.Mouvement("_yscale",0,100,0,6,"easeOutSine");
this.nom_txt.embedFonts = true;
this.pseudo_txt.embedFonts = true;
stop();
this.oui_btn.onRelease = function()
{
   var _loc3_ = this;
   var nomTmp = _loc3_._parent.nom_txt.text;
   var pseudoTmp = _loc3_._parent.pseudo_txt.text;
   var _loc2_ = _root.colorPatch.recupOptionValue();
   var _loc1_ = new LoadVars();
   _loc1_.var0 = nomTmp;
   _loc1_.var1 = pseudoTmp;
   _loc1_.var2 = _loc2_;
   _loc1_.sendAndLoad("ajoption.php",_loc1_,"POST");
   _loc3_._parent.flash_quest_mask.Mouvement("_yscale",100,0,0,6,"easeOutSine");
   retardateur(7,2,function()
   {
      _root.option_quest_mc.gotoAndStop(3);
   }
   );
};
this.non_btn.onRelease = function()
{
   this._parent.flash_quest_mask.Mouvement("_yscale",100,0,0,6,"easeOutSine");
   retardateur(7,2,function()
   {
      _root.option_quest_mc.flash_quest_mc.gotoAndStop(1);
   }
   );
};
