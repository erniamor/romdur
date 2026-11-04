function decalageFlash()
{
   var i = 0;
   while(i <= 15)
   {
      univers.array[i].rotation.x = univers.array[i].rotation.x %= 360;
      RRotation(univers,i,undefined,{x:-90,y:undefined,z:undefined},0,20,"easeOutSine");
      i++;
   }
   var _loc2_ = 24;
   while(_loc2_ <= 31)
   {
      univers.array[_loc2_].rotation.x = univers.array[_loc2_].rotation.x %= 360;
      RRotation(univers,_loc2_,undefined,{x:-90,y:undefined,z:undefined},0,20,"easeOutSine");
      _loc2_ = _loc2_ + 1;
   }
   var _loc3_ = 16;
   while(_loc3_ <= 23)
   {
      univers.array[_loc3_].rotation.x = univers.array[_loc3_].rotation.x %= 360;
      RRotation(univers,_loc3_,undefined,{x:90,y:undefined,z:undefined},0,20,"easeOutSine");
      _loc3_ = _loc3_ + 1;
   }
   var l = 32;
   while(l <= 33)
   {
      RMouvement(univers,l,undefined,[-320,undefined,undefined],0,20,"easeOutSine");
      l++;
   }
   retardateur(21,21,function()
   {
      _global.snd_multi_transition.start();
      var _loc1_ = 0;
      while(_loc1_ <= 31)
      {
         if(_loc1_ >= 16 && _loc1_ <= 23)
         {
            RMouvement(univers,_loc1_,undefined,[undefined,univers.array[_loc1_].position.y - 80,undefined],0,20,"easeOutExpo");
         }
         else
         {
            RMouvement(univers,_loc1_,undefined,[undefined,univers.array[_loc1_].position.y + 80,undefined],0,20,"easeOutExpo");
         }
         _loc1_ = _loc1_ + 1;
      }
   }
   ,function()
   {
      var _loc3_ = 0;
      while(_loc3_ <= 7)
      {
         RRotationRelative(univers,_loc3_,{x:-400,y:0,z:0},{x:undefined,y:0},{x:undefined,y:90},0,20,"easeInOutSine");
         _loc3_ = _loc3_ + 1;
      }
      var _loc1_ = 8;
      while(_loc1_ <= 15)
      {
         RRotationRelative(univers,_loc1_,{x:-400,y:0,z:0},{x:undefined,y:0},{x:undefined,y:90},5,15,"easeInOutSine");
         _loc1_ = _loc1_ + 1;
      }
      var _loc2_ = 24;
      while(_loc2_ <= 31)
      {
         RRotationRelative(univers,_loc2_,{x:400,y:0,z:0},{x:undefined,y:0},{x:undefined,y:-90},0,20,"easeInOutSine");
         _loc2_ = _loc2_ + 1;
      }
      miseEnPlaceFlash();
   }
   );
}
function miseEnPlaceFlash()
{
   RMouvement(univers,16,undefined,[-300,undefined,undefined],13,10,"easeOutExpo");
   RMouvement(univers,19,undefined,[-300,undefined,undefined],13,10,"easeOutExpo");
   RMouvement(univers,20,undefined,[-300,undefined,undefined],13,10,"easeOutExpo");
   RMouvement(univers,23,undefined,[-300,undefined,undefined],13,10,"easeOutExpo");
   RMouvement(univers,17,undefined,[300,undefined,undefined],13,10,"easeOutExpo");
   RMouvement(univers,18,undefined,[300,undefined,undefined],13,10,"easeOutExpo");
   RMouvement(univers,21,undefined,[300,undefined,undefined],13,10,"easeOutExpo");
   RMouvement(univers,22,undefined,[300,undefined,undefined],13,10,"easeOutExpo",function()
   {
      _global.snd_multi_transition.start();
   }
   );
   retardateur(24,6,function()
   {
      _global.snd_multi_transition.start();
      RMouvement(univers,32,undefined,[undefined,120,undefined],0,15,"easeOutExpo");
      RMouvement(univers,33,undefined,[undefined,70,undefined],0,15,"easeOutExpo");
      RMouvement(univers,16,undefined,[undefined,-200,undefined],0,15,"easeOutExpo");
      RMouvement(univers,17,undefined,[undefined,-200,undefined],0,15,"easeOutExpo");
      RMouvement(univers,18,undefined,[undefined,-200,undefined],0,15,"easeOutExpo");
      RMouvement(univers,19,undefined,[undefined,-200,undefined],0,15,"easeOutExpo");
      RMouvement(univers,20,undefined,[undefined,200,undefined],0,15,"easeOutExpo");
      RMouvement(univers,21,undefined,[undefined,200,undefined],0,15,"easeOutExpo");
      RMouvement(univers,22,undefined,[undefined,200,undefined],0,15,"easeOutExpo");
      RMouvement(univers,23,undefined,[undefined,200,undefined],0,15,"easeOutExpo");
   }
   ,function()
   {
      affichMcFlash();
   }
   );
}
function affichMcFlash()
{
   var _loc2_ = _root;
   _loc2_.apiDesactiveEtat("cube0");
   _loc2_.apiDesactiveEtat("cube1");
   _loc2_.apiDesactiveEtat("cube3");
   _loc2_.sample.soundAmbient_flash();
   this.attachMovie("mc_flash","mc_flash",9999999);
   this.mc_flash.flash_mask.Mouvement("_yscale",0,100,0,20,"easeInOutCubic");
   _loc2_.bt_retour.onRelease = function()
   {
      _root.multimedia.deselectFlash();
   };
   var _loc1_ = 32;
   while(_loc1_ <= 49)
   {
      univers.array[_loc1_].rotation.reset(0,0,0);
      _loc1_ = _loc1_ + 1;
   }
   _loc2_.multimedia.createEmptyMovieClip("tFlashAnim",-23498);
   _loc2_.multimedia.tFlashAnim.onEnterFrame = function()
   {
      univers.rotateObjectY(32,33,_xmouse / 200);
   };
}
function deselectFlash()
{
   delete _root.multimedia.tFlashAnim.onEnterFrame;
   _root.multimedia.tFlashAnim.removeMovieClip();
   delete _root.sample.onEnterFrame;
   _global.snd_multi_flash_amb.soundVolume(undefined,0,0,50,"easeInSine",undefined,function()
   {
      _global.snd_multi_flash_amb.stop();
   }
   );
   _global.snd_multi_amb_1.start(0,999999999);
   _global.snd_multi_amb_2.start(0,999999999);
   _global.snd_multi_amb_3.start(0,999999999);
   _global.snd_multi_amb_4.start(0,999999999);
   _global.snd_multi_amb_1.soundVolume(undefined,100,0,50,"easeInOutSine");
   _global.snd_multi_amb_2.soundVolume(undefined,100,0,50,"easeInOutSine");
   _global.snd_multi_amb_3.soundVolume(undefined,100,0,50,"easeInOutSine");
   _global.snd_multi_amb_4.soundVolume(undefined,100,0,50,"easeInOutSine",undefined,function()
   {
      _root.sample.soundAmbient_multi();
   }
   );
   this.mc_flash.flash_mask.Mouvement("_yscale",100,0,0,10,"easeInOutCubic");
   _root.apiActiveEtat("cube0");
   _root.apiActiveEtat("cube1");
   _root.apiActiveEtat("cube3");
   var t = 16;
   while(t <= 23)
   {
      RRotation(univers,t,{x:0},{x:-360},0,40,"easeInOutSine");
      RMouvement(univers,t,undefined,[multi_accueil[t].x],10,20,"easeInOutSine");
      t++;
   }
   var n = 0;
   while(n <= 7)
   {
      RRotationRelative(univers,n,{x:-400,y:0,z:0},undefined,{x:undefined,y:-90},20,20,"easeInOutSine");
      n++;
   }
   var p = 8;
   while(p <= 15)
   {
      RRotationRelative(univers,p,{x:-400,y:0,z:0},undefined,{x:undefined,y:-90},25,15,"easeInOutSine");
      p++;
   }
   var o = 24;
   while(o <= 31)
   {
      RRotationRelative(univers,o,{x:400,y:0,z:0},undefined,{x:undefined,y:90},20,20,"easeInOutSine");
      o++;
   }
   var _loc2_ = 32;
   while(_loc2_ <= 33)
   {
      univers.array[_loc2_].rotation.y = univers.array[_loc2_].rotation.y %= 360;
      RRotation(univers,_loc2_,undefined,{x:undefined,y:0,z:undefined},0,40,"easeInOutSine");
      RMouvement(univers,_loc2_,undefined,[undefined,0,undefined],0,40,"easeInOutSine");
      _loc2_ = _loc2_ + 1;
   }
   retardateur(51,21,function()
   {
      _root.multimedia.mc_flash.unloadMovie();
      var _loc1_ = 0;
      var _loc2_;
      while(_loc1_ <= 31)
      {
         if(_loc1_ >= 16 && _loc1_ <= 23)
         {
            _loc2_ = univers.array[_loc1_].position.y <= 0 ? -30 : 190;
            RMouvement(univers,_loc1_,undefined,[undefined,_loc2_,undefined],0,20,"easeOutExpo");
         }
         else
         {
            RMouvement(univers,_loc1_,undefined,[undefined,univers.array[_loc1_].position.y - 80,undefined],0,20,"easeOutExpo");
         }
         _loc1_ = _loc1_ + 1;
      }
      RMouvement(univers,32,undefined,[-300,undefined,undefined],0,40,"easeInOutSine");
      RMouvement(univers,33,undefined,[300,undefined,undefined],0,40,"easeInOutSine");
   }
   ,function()
   {
      var _loc2_ = _root;
      activeAllBtEvent();
      var _loc1_ = 0;
      while(_loc1_ <= univers.array.length)
      {
         if(_loc1_ >= 16 && _loc1_ <= 23)
         {
            univers.array[_loc1_].rotation.reset(90,0,0);
         }
         else
         {
            univers.array[_loc1_].rotation.reset(-90,0,0);
         }
         _loc1_ = _loc1_ + 1;
      }
      _loc2_.multimedia.multimediaEnterFrame();
      _loc2_.bt_retour.onRelease = function()
      {
         _root.multimedia.multimediaSortie();
      };
   }
   );
}
MovieClip.prototype.selectFlash = function(id)
{
   var _loc1_ = _global;
   delete _root.sample.onEnterFrame;
   _loc1_.snd_multi_amb_1.soundVolume(undefined,0,0,100,"easeInOutSine");
   _loc1_.snd_multi_amb_2.soundVolume(undefined,0,0,100,"easeInOutSine");
   _loc1_.snd_multi_amb_3.soundVolume(undefined,0,0,100,"easeInOutSine");
   _loc1_.snd_multi_amb_4.soundVolume(undefined,0,0,100,"easeInOutSine",undefined,function()
   {
      var _loc1_ = _global;
      _loc1_.snd_multi_amb_1.stop();
      _loc1_.snd_multi_amb_2.stop();
      _loc1_.snd_multi_amb_3.stop();
      _loc1_.snd_multi_amb_4.stop();
   }
   );
   _loc1_.snd_multi_flash_amb.start(0,99999999);
   _loc1_.snd_multi_flash_amb.soundVolume(undefined,75,0,100,"easeInOutSine");
   delete this.onEnterFrame;
   delete _root.bt_retour.onRelease;
   decalageFlash();
};
