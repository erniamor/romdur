function introCv()
{
   var _loc1_ = 0;
   while(_loc1_ < univers.array.length)
   {
      var end = [univers.array[_loc1_].position.x + 1000,undefined,undefined];
      RMouvement(univers,_loc1_,undefined,end,0,30,"easeInSine");
      _loc1_ = _loc1_ + 1;
   }
   retardateur(31,38,function()
   {
      _global.snd_cv_transition.start();
      etireCvCubeY(0);
      etireCvCubeY(8);
      etireCvCubeY(16);
   }
   ,function()
   {
      _global.snd_cv_transition.start();
      var _loc1_ = 0;
      while(_loc1_ < univers.array.length)
      {
         RRotation(univers,_loc1_,0,{x:undefined,y:180},0,20,"easeOutSine");
         _loc1_ = _loc1_ + 1;
      }
   }
   );
   retardateur(53,60,function()
   {
      _global.snd_cv_transition.start();
      var _loc2_ = 8;
      while(_loc2_ <= 15)
      {
         RRotation(univers,_loc2_,0,{x:120},0,10,"easeOutSine");
         _loc2_ = _loc2_ + 1;
      }
      var _loc1_ = 16;
      while(_loc1_ <= 23)
      {
         RRotation(univers,_loc1_,0,{x:-120},0,10,"easeOutSine");
         _loc1_ = _loc1_ + 1;
      }
   }
   ,function()
   {
      startCvEnterFrame();
      _global.snd_cv_rot_1.start(0,9999999);
      _global.snd_cv_rot_2.start(0,9999999);
      _root.sample.soundAmbient_cv();
      activeCvBt();
   }
   );
}
function startCvEnterFrame()
{
   _root.cv.onEnterFrame = function()
   {
      univers.rotateX(_ymouse / 60);
   };
}
function affichmcCV()
{
   var _loc1_ = _root;
   _loc1_.cv.createEmptyMovieClip("mcCV",558778);
   _loc1_.cv.mcCV.univers = univers;
   _loc1_.cv.mcCV.attachMovie("cv_qui","cv_qui",10);
   _loc1_.cv.mcCV.attachMovie("cv_competence","cv_competence",11);
   _loc1_.cv.mcCV.attachMovie("cv_qualification","cv_qualification",12);
   _loc1_.cv.mcCV.attachMcCv();
   _loc1_.cv.mcCV.onEnterFrame = function()
   {
      this.attachMcCv();
   };
}
function etireCvCubeY(i)
{
   var _loc3_ = i;
   var _loc1_ = 10;
   var _loc2_ = "easeOutSine";
   RMouvement(univers,_loc3_,undefined,[undefined,100,undefined],0,_loc1_,_loc2_);
   RMouvement(univers,_loc3_ + 1,undefined,[undefined,100,undefined],0,_loc1_,_loc2_);
   RMouvement(univers,_loc3_ + 4,undefined,[undefined,100,undefined],0,_loc1_,_loc2_);
   RMouvement(univers,_loc3_ + 5,undefined,[undefined,100,undefined],0,_loc1_,_loc2_);
   RMouvement(univers,_loc3_ + 2,undefined,[undefined,-100,undefined],0,_loc1_,_loc2_);
   RMouvement(univers,_loc3_ + 3,undefined,[undefined,-100,undefined],0,_loc1_,_loc2_);
   RMouvement(univers,_loc3_ + 6,undefined,[undefined,-100,undefined],0,_loc1_,_loc2_);
   RMouvement(univers,_loc3_ + 7,undefined,[undefined,-100,undefined],0,_loc1_,_loc2_);
}
function etireCvCubeX(i)
{
   var _loc1_ = i;
   RMouvement(univers,_loc1_,undefined,[-250,undefined,undefined],0,30,"easeOutExpo");
   RMouvement(univers,_loc1_ + 3,undefined,[-250,undefined,undefined],0,30,"easeOutExpo");
   RMouvement(univers,_loc1_ + 4,undefined,[-250,undefined,undefined],0,30,"easeOutExpo");
   RMouvement(univers,_loc1_ + 7,undefined,[-250,undefined,undefined],0,30,"easeOutExpo");
   RMouvement(univers,_loc1_ + 1,undefined,[250,undefined,undefined],0,30,"easeOutExpo");
   RMouvement(univers,_loc1_ + 2,undefined,[250,undefined,undefined],0,30,"easeOutExpo");
   RMouvement(univers,_loc1_ + 5,undefined,[250,undefined,undefined],0,30,"easeOutExpo");
   RMouvement(univers,_loc1_ + 6,undefined,[250,undefined,undefined],0,30,"easeOutExpo");
}
function retractCvCubeX(i)
{
   var _loc1_ = i;
   RMouvement(univers,_loc1_,undefined,[-75,undefined,undefined],0,30,"easeOutExpo");
   RMouvement(univers,_loc1_ + 3,undefined,[-75,undefined,undefined],0,30,"easeOutExpo");
   RMouvement(univers,_loc1_ + 4,undefined,[-75,undefined,undefined],0,30,"easeOutExpo");
   RMouvement(univers,_loc1_ + 7,undefined,[-75,undefined,undefined],0,30,"easeOutExpo");
   RMouvement(univers,_loc1_ + 1,undefined,[75,undefined,undefined],0,30,"easeOutExpo");
   RMouvement(univers,_loc1_ + 2,undefined,[75,undefined,undefined],0,30,"easeOutExpo");
   RMouvement(univers,_loc1_ + 5,undefined,[75,undefined,undefined],0,30,"easeOutExpo");
   RMouvement(univers,_loc1_ + 6,undefined,[75,undefined,undefined],0,30,"easeOutExpo");
}
function cvSortie()
{
   delete _root.bt_retour.onRelease;
   delete _root.cv.onEnterFrame;
   _global.snd_cv_transition.start();
   var i = 0;
   while(i < univers.array.length)
   {
      RMouvement(univers,i,undefined,[0,undefined,undefined],0,10,"easeOutSine");
      i++;
   }
   retardateur(23,33,function()
   {
      _global.snd_cv_transition.start();
      var bool1 = random(2);
      var end1 = bool1 != 0 ? [undefined,500,undefined] : [undefined,-500,undefined];
      var _loc3_ = 0;
      while(_loc3_ <= 7)
      {
         RMouvement(univers,_loc3_,undefined,end1,0,20,"easeOutExpo");
         _loc3_ = _loc3_ + 1;
      }
      var bool2 = random(2);
      var end2 = bool2 != 0 ? [undefined,500,undefined] : [undefined,-500,undefined];
      var _loc2_ = 8;
      while(_loc2_ <= 15)
      {
         RMouvement(univers,_loc2_,undefined,end2,0,20,"easeOutExpo");
         _loc2_ = _loc2_ + 1;
      }
      var bool3 = random(2);
      var end3 = bool3 != 0 ? [undefined,500,undefined] : [undefined,-500,undefined];
      var _loc1_ = 16;
      while(_loc1_ <= 23)
      {
         RMouvement(univers,_loc1_,undefined,end3,0,20,"easeOutExpo");
         _loc1_ = _loc1_ + 1;
      }
   }
   ,function()
   {
      var _loc1_ = _root;
      for(api in _level0.MoteurApi.apiOn)
      {
         delete _level0.MoteurApi.apiOn[api];
      }
      delete _loc1_.sample.onEnterFrame;
      _global.snd_cv_rot_1.stop();
      _global.snd_cv_rot_2.stop();
      deactiveCvBt();
      _loc1_.attachMovie("E","E",10);
      _loc1_.cv.removeMovieClip();
   }
   );
}
MovieClip.prototype.attachMcCv = function()
{
   var _loc1_ = this;
   var drx = (univers.array[5].screenPos.x - univers.array[4].screenPos.x + (univers.array[6].screenPos.x - univers.array[7].screenPos.x)) / 2;
   var _loc2_ = (univers.array[4].screenPos.y - univers.array[7].screenPos.y + (univers.array[5].screenPos.y - univers.array[6].screenPos.y)) / 2;
   _loc1_.cv_qui._x = (univers.array[5].screenPos.x + univers.array[4].screenPos.x) / 2;
   _loc1_.cv_qui._y = - (univers.array[4].screenPos.y - Math.abs(_loc2_) / 2);
   _loc1_.cv_qui._width = Math.abs(drx);
   _loc1_.cv_qui._height = Math.abs(_loc2_);
   _loc1_.cv_qui._visible = _loc2_ < 0 ? false : true;
   var dcx = (univers.array[13].screenPos.x - univers.array[12].screenPos.x + (univers.array[14].screenPos.x - univers.array[15].screenPos.x)) / 2;
   var _loc3_ = (univers.array[12].screenPos.y - univers.array[15].screenPos.y + (univers.array[13].screenPos.y - univers.array[14].screenPos.y)) / 2;
   _loc1_.cv_competence._x = (univers.array[13].screenPos.x + univers.array[12].screenPos.x) / 2;
   _loc1_.cv_competence._y = - (univers.array[12].screenPos.y - Math.abs(_loc3_) / 2);
   _loc1_.cv_competence._width = Math.abs(dcx);
   _loc1_.cv_competence._height = Math.abs(_loc3_);
   _loc1_.cv_competence._visible = _loc3_ < 0 ? false : true;
   var dqx = (univers.array[21].screenPos.x - univers.array[20].screenPos.x + (univers.array[22].screenPos.x - univers.array[23].screenPos.x)) / 2;
   var dqy = (univers.array[20].screenPos.y - univers.array[23].screenPos.y + (univers.array[21].screenPos.y - univers.array[22].screenPos.y)) / 2;
   _loc1_.cv_qualification._x = (univers.array[21].screenPos.x + univers.array[20].screenPos.x) / 2;
   _loc1_.cv_qualification._y = - (univers.array[20].screenPos.y - Math.abs(dqy) / 2);
   _loc1_.cv_qualification._width = Math.abs(dqx);
   _loc1_.cv_qualification._height = Math.abs(dqy);
   _loc1_.cv_qualification._visible = dqy < 0 ? false : true;
};
