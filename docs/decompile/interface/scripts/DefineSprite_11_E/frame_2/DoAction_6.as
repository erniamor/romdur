this.api15.onRollOver = function()
{
   this.shakeXCercle3d(109,15);
};
this.api16.onRollOver = function()
{
   this.shakeXCercle3d(127,16);
};
this.api17.onRollOver = function()
{
   this.shakeXCercle3d(145,17);
};
this.api18.onRollOver = function()
{
   this.shakeXCercle3d(163,18);
};
this.api12.onRollOver = function()
{
   this.eventCercleCentral();
   _global.snd_menu_central.stop();
   _global.snd_menu_central.start();
};
MovieClip.prototype.shakeXCercle3d = function(idInit, idApi)
{
   var _loc3_ = idApi;
   if(_level0.MoteurApi.apiOn["api" + _loc3_].styleId == 0)
   {
      _level0.MoteurApi.apiOn["api" + _loc3_].styleId = 1;
      _global.snd_menu_cercle_a.start();
   }
   else
   {
      _level0.MoteurApi.apiOn["api" + _loc3_].styleId = 0;
      _global.snd_menu_cercle_b.start();
   }
   this._parent.createEmptyMovieClip("timeShake3d",-98963);
   this._parent.timeShake3d.tShake = 0;
   this._parent.timeShake3d.onEnterFrame = function()
   {
      tShake++;
      var _loc1_ = idInit;
      var _loc2_;
      while(_loc1_ <= idInit + 17)
      {
         _loc2_ = random(20) - 10 + accueil[_loc1_].x;
         univers.array[_loc1_].position.x = _loc2_;
         univers.array[_loc1_].render(univers.pers);
         _loc1_ = _loc1_ + 1;
      }
      if(tShake >= 5)
      {
         _loc1_ = idInit;
         while(_loc1_ <= idInit + 17)
         {
            RMouvement(univers,_loc1_,undefined,[accueil[_loc1_].x,undefined,undefined],0,10,"easeOutSine");
            _loc1_ = _loc1_ + 1;
         }
         delete _root.E.timeShake3d.onEnterFrame;
      }
   };
};
MovieClip.prototype.eventCercleCentral = function()
{
   var _loc1_ = this;
   var _loc2_ = [_level0.MoteurApi.style[_level0.MoteurApi.apiOn[_loc1_.apiNom].styleId][0],_level0.MoteurApi.style[_level0.MoteurApi.apiOn[_loc1_.apiNom].styleId][1],_level0.MoteurApi.style[_level0.MoteurApi.apiOn[_loc1_.apiNom].styleId][2],_level0.MoteurApi.style[_level0.MoteurApi.apiOn[_loc1_.apiNom].styleId][3],_level0.MoteurApi.style[_level0.MoteurApi.apiOn[_loc1_.apiNom].styleId][4]];
   _root.setApiLocal(_loc1_.apiNom,_loc2_);
   _level0.ApiMouvement(_loc1_.apiNom,4,_level0.MoteurApi.style[_level0.MoteurApi.apiOn[_loc1_.apiNom].styleId][4] + 50,_level0.MoteurApi.style[_level0.MoteurApi.apiOn[_loc1_.apiNom].styleId][4],0,10,"linearTween",false,true);
};
MovieClip.prototype.shakeXBt = function(id)
{
   var _loc1_ = id;
   var _loc2_ = random(20) + 20;
   var _loc3_ = univers.array[_loc1_].position.x - _loc2_;
   RMouvement(univers,_loc1_,[_loc3_,undefined,undefined],[accueil[_loc1_].x,undefined,undefined],1,10,"easeOutSine");
};
