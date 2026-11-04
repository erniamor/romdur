this.setMask(this.flash_quest_mask);
this.flash_quest_mask._yscale = 0;
this.flash_quest_mask.Mouvement("_yscale",0,100,0,6,"easeOutSine");
this.retardateur(15,7,function()
{
   _root.option_quest_mc.flash_quest_mask.Mouvement("_yscale",100,0,0,6,"easeOutSine");
}
,function()
{
   _root.connectionDataOption();
   _root.option_quest_mc.gotoAndStop(1);
}
);
stop();
