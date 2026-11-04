this.setMask(this.flash_quest_mask);
this.flash_quest_mask._yscale = 0;
this.flash_quest_mask.Mouvement("_yscale",0,100,0,6,"easeOutSine");
stop();
this.annuler_btn.onRelease = function()
{
   this._parent.flash_quest_mask.Mouvement("_yscale",100,0,0,6,"easeOutSine");
   retardateur(7,2,function()
   {
      _root.multimedia.flash_quest_mc.gotoAndStop(1);
   }
   );
};
