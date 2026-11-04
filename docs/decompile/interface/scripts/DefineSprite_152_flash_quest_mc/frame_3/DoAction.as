this.setMask(this.flash_quest_mask);
this.flash_quest_mask._yscale = 0;
this.flash_quest_mask.Mouvement("_yscale",0,100,0,6,"easeOutSine");
stop();
this.fla_btn.onRelease = function()
{
   var _loc1_ = _global;
   if(_loc1_.data_flash[_loc1_.flash_idActuel].Poids == "")
   {
      this._parent.flash_quest_mask.Mouvement("_yscale",100,0,0,6,"easeOutSine");
      retardateur(7,2,function()
      {
         _root.multimedia.flash_quest_mc.gotoAndStop(4);
      }
      );
   }
   else
   {
      getURL("externdata/flash/" + _loc1_.data_flash[_loc1_.flash_idActuel].Poids,"");
      this._parent.flash_quest_mask.Mouvement("_yscale",100,0,0,6,"easeOutSine");
      retardateur(7,2,function()
      {
         _root.multimedia.flash_quest_mc.gotoAndStop(1);
      }
      );
   }
};
this.exe_btn.onRelease = function()
{
   getURL("externdata/flash/" + _global.data_flash[_global.flash_idActuel].Fichier + "_exe.rar","");
   this._parent.flash_quest_mask.Mouvement("_yscale",100,0,0,6,"easeOutSine");
   retardateur(7,2,function()
   {
      _root.multimedia.flash_quest_mc.gotoAndStop(1);
   }
   );
};
this.annuler_btn.onRelease = function()
{
   this._parent.flash_quest_mask.Mouvement("_yscale",100,0,0,6,"easeOutSine");
   retardateur(7,2,function()
   {
      _root.multimedia.flash_quest_mc.gotoAndStop(1);
   }
   );
};
