function startEnterFrame()
{
   var _loc2_ = _global;
   _loc2_.snd_menu_amb_1.start(0,900000);
   _loc2_.snd_menu_amb_1.soundVolume(0,150,0,30,"easeInOutSine",undefined,function()
   {
      _root.sample.soundAmbient_accueil();
   }
   );
   _loc2_.snd_menu_amb_2.start(0,900000);
   _loc2_.snd_menu_amb_2.setVolume(0);
   _root.E.onEnterFrame = function()
   {
      univers.rotateObjectX(0,50,this._ymouse / 60);
      univers.rotateObjectX(51,185,this._xmouse / 120);
      var _loc1_ = univers.array[87].position.x;
      var _loc2_;
      if(_xmouse < -300 || _xmouse > 300)
      {
         _loc2_ = _xmouse <= 0 ? (-300 - _loc1_) / 10 : (300 - _loc1_) / 6;
      }
      else
      {
         _loc2_ = (_xmouse - _loc1_) / 10;
      }
      univers.translateObject(69,108,{x:_loc2_});
   };
}
function introAccueil()
{
   var delai = 0;
   retardateur(15,16,function()
   {
      _global.snd_menu_intro_1.start();
      trace("sond start");
   }
   );
   var _loc1_ = 0;
   var _loc3_;
   var _loc2_;
   while(_loc1_ < univers.array.length)
   {
      _loc3_ = [0,0,600];
      _loc2_ = [accueil[_loc1_].x,accueil[_loc1_].y,accueil[_loc1_].z];
      if(_loc1_ == univers.array.length - 1)
      {
         RMouvement(univers,_loc1_,_loc3_,_loc2_,Math.round(delai),30,"easeOutSine",undefined,function()
         {
            desactivePointsInTime();
            activeLignesInTime(true,23);
            activeBT(true);
            _global.snd_menu_intro_3.start();
            startEnterFrame();
         }
         );
      }
      else
      {
         RMouvement(univers,_loc1_,_loc3_,_loc2_,Math.round(delai),30,"easeOutSine");
      }
      delai += 0.3;
      _loc1_ = _loc1_ + 1;
   }
}
function retourAccueil_v0()
{
   desactivePoints();
   activeLignes(true,23);
   var delaiA = 0;
   var _loc2_ = 0;
   var _loc3_;
   while(_loc2_ <= 22)
   {
      univers.array[_loc2_].position.reset(accueil[_loc2_].x - 1500,accueil[_loc2_].y,accueil[_loc2_].z);
      univers.array[_loc2_].render();
      _loc3_ = [accueil[_loc2_].x,undefined,undefined];
      RMouvement(univers,_loc2_,undefined,_loc3_,Math.floor(delaiA),30,"easeOutSine");
      delaiA += 1;
      _loc2_ = _loc2_ + 1;
   }
   var delaiB = 0;
   var _loc1_ = 23;
   while(_loc1_ <= univers.array.length)
   {
      univers.array[_loc1_].position.reset(accueil[_loc1_].x + 1500,accueil[_loc1_].y,accueil[_loc1_].z);
      univers.array[_loc1_].render();
      _loc3_ = [accueil[_loc1_].x,undefined,undefined];
      RMouvement(univers,_loc1_,undefined,_loc3_,Math.floor(delaiB),20,"easeOutSine");
      delaiB += 0.2;
      _loc1_ = _loc1_ + 1;
   }
   retardateur(1,60,function()
   {
      activeBT(true);
   }
   ,function()
   {
      startEnterFrame();
   }
   );
}
function retourAccueil_v1()
{
   desactivePoints();
   activeLignes(true,23);
   var rayon = 30;
   retardateur(2,3,function()
   {
      _global.snd_menu_retour_1.start();
   }
   );
   var _loc2_ = 0;
   var _loc3_;
   while(_loc2_ <= 22)
   {
      _loc3_ = Math.sqrt(accueil[_loc2_].z * accueil[_loc2_].z + accueil[_loc2_].y * accueil[_loc2_].y);
      var rapport = rayon / _loc3_;
      univers.array[_loc2_].position.reset(-600,0,0);
      univers.array[_loc2_].render();
      var end = [accueil[_loc2_].x,undefined,undefined];
      RMouvement(univers,_loc2_,undefined,end,0,20,"easeInSine");
      _loc2_ = _loc2_ + 1;
   }
   var _loc1_ = 23;
   while(_loc1_ <= univers.array.length)
   {
      univers.array[_loc1_].position.reset(600,0,0);
      univers.array[_loc1_].render();
      var end = [accueil[_loc1_].x,undefined,undefined];
      RMouvement(univers,_loc1_,undefined,end,0,20,"easeInSine");
      _loc1_ = _loc1_ + 1;
   }
   retardateur(21,31,function()
   {
      _global.snd_menu_retour_2.start();
      activeBT(true);
      var _loc2_ = 0;
      var _loc3_;
      while(_loc2_ <= 22)
      {
         _loc3_ = [undefined,accueil[_loc2_].y,accueil[_loc2_].z];
         RMouvement(univers,_loc2_,undefined,_loc3_,random(3),10,"easeOutBack");
         _loc2_ = _loc2_ + 1;
      }
      var _loc1_ = 23;
      while(_loc1_ <= univers.array.length)
      {
         _loc3_ = [undefined,accueil[_loc1_].y,accueil[_loc1_].z];
         RMouvement(univers,_loc1_,undefined,_loc3_,random(3),10,"easeOutBack");
         _loc1_ = _loc1_ + 1;
      }
   }
   ,function()
   {
      startEnterFrame();
   }
   );
}
function sortieAccueil(funct)
{
   delete _root.sample.onEnterFrame;
   delete _root.E.onEnterFrame;
   activeBT(false);
   _global.snd_menu_amb_1.soundVolume(undefined,0,0,30,"easeInOutSine");
   _global.snd_menu_amb_2.soundVolume(undefined,0,0,30,"easeInOutSine");
   retardateur(1,15,function()
   {
      _global.snd_menu_sortie.start();
      var _loc3_ = random(2);
      var _loc2_ = _loc3_ != 0 ? [- random(350) - 200,undefined,undefined] : [random(350) + 200,undefined,undefined];
      var _loc1_ = 0;
      while(_loc1_ < univers.array.length)
      {
         RMouvement("univers",_loc1_,undefined,_loc2_,random(4),10,"easeOutExpo");
         _loc1_ = _loc1_ + 1;
      }
   }
   ,function()
   {
      _global.snd_menu_sortie.start();
      var _loc2_ = [undefined,undefined,0];
      var _loc1_ = 0;
      while(_loc1_ < univers.array.length)
      {
         RMouvement("univers",_loc1_,undefined,_loc2_,_loc1_ % 4,10,"easeOutExpo");
         _loc1_ = _loc1_ + 1;
      }
   }
   );
   retardateur(25,30,function()
   {
      _global.snd_menu_sortie.start();
      var _loc2_ = [undefined,0,undefined];
      var _loc1_ = 0;
      while(_loc1_ < univers.array.length)
      {
         RMouvement("univers",_loc1_,undefined,_loc2_,0,10,"easeOutExpo");
         _loc1_ = _loc1_ + 1;
      }
   }
   ,function()
   {
      var _loc1_ = 0;
      while(_loc1_ <= 22)
      {
         delete _level0.MoteurApi.apiOn["api" + _loc1_];
         _loc1_ = _loc1_ + 1;
      }
      _global.snd_menu_amb_1.stop();
      _global.snd_menu_amb_2.stop();
      funct();
      _root.E.removeMovieClip();
   }
   );
}
MovieClip.prototype.activeBT = function(bool)
{
   with(this)
   {
      BT_19._visible = bool;
      BT_20._visible = bool;
      BT_21._visible = bool;
      BT_22._visible = bool;
   }
};
MovieClip.prototype.activeLignesInTime = function(bool, nbLigne, funct)
{
   var _loc1_ = this;
   _loc1_.createEmptyMovieClip("activeLignesTmp",9999999);
   var i = a = 0;
   _loc1_.activeLignesTmp.onEnterFrame = function()
   {
      if(a++ % 2 == 0)
      {
         _global.snd_menu_intro_2.start();
         _root.apiActiveEtat("api" + i);
         i++;
         if(i >= nbLigne)
         {
            funct();
            delete this.onEnterFrame;
         }
      }
   };
};
MovieClip.prototype.activeLignes = function(bool, nbLigne, funct)
{
   var _loc2_ = nbLigne;
   var _loc3_ = _root;
   var _loc1_ = 0;
   while(_loc1_ < _loc2_)
   {
      _loc3_.apiActiveEtat("api" + _loc1_);
      _loc1_ = _loc1_ + 1;
   }
   funct();
};
MovieClip.prototype.activePoints = function()
{
   var _loc2_ = this;
   _loc2_.createEmptyMovieClip("activePointsTmp",9999998);
   _loc2_.activePointsTmp.tmp = 0;
   _loc2_.activePointsTmp.onEnterFrame = function()
   {
      var _loc2_ = this;
      var _loc1_ = 0;
      while(_loc1_ < univers.array.length)
      {
         univers.array[_loc1_].timeline["point" + _loc1_].clear();
         univers.array[_loc1_].timeline["point" + _loc1_].lineStyle(1,"0x000000",_loc2_.tmp);
         univers.array[_loc1_].timeline["point" + _loc1_].lineTo(1,0);
         _loc1_ = _loc1_ + 1;
      }
      if(_loc2_.tmp < 100)
      {
         _loc2_.tmp += 2;
      }
      else
      {
         delete _loc2_.onEnterFrame;
      }
   };
};
MovieClip.prototype.desactivePointsInTime = function()
{
   var _loc2_ = this;
   _loc2_.createEmptyMovieClip("activePointsTmp",9999998);
   _loc2_.activePointsTmp.tmp = 100;
   _loc2_.activePointsTmp.onEnterFrame = function()
   {
      var _loc2_ = this;
      var _loc1_ = 0;
      while(_loc1_ < univers.array.length)
      {
         univers.array[_loc1_].timeline["point" + _loc1_].clear();
         univers.array[_loc1_].timeline["point" + _loc1_].lineStyle(2,"0x475656",_loc2_.tmp);
         univers.array[_loc1_].timeline["point" + _loc1_].lineTo(1,0);
         _loc1_ = _loc1_ + 1;
      }
      if(_loc2_.tmp > 0)
      {
         _loc2_.tmp -= 4;
      }
      else
      {
         delete _loc2_.onEnterFrame;
      }
   };
};
MovieClip.prototype.desactivePoints = function()
{
   var _loc1_ = 0;
   while(_loc1_ < univers.array.length)
   {
      univers.array[_loc1_].timeline["point" + _loc1_].clear();
      univers.array[_loc1_].timeline["point" + _loc1_].lineStyle(2,"0x475656",0);
      univers.array[_loc1_].timeline["point" + _loc1_].lineTo(1,0);
      _loc1_ = _loc1_ + 1;
   }
};
