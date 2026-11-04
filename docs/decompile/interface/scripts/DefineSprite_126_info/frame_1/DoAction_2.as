function selectInfoCube(id)
{
   deactiveAllInfoBt();
   with(_root.info)
   {
      var l = 0;
      while(l < univers.array.length)
      {
         var end = [saveInfoRepere[l].x,saveInfoRepere[l].y,saveInfoRepere[l].z];
         RMouvement(univers,l,undefined,end,0,15,"easeInOutCubic");
         l++;
      }
      retardateur(15,6,function()
      {
         var _loc1_ = 0;
         var _loc2_;
         while(_loc1_ <= univers.array.length)
         {
            if(_loc1_ <= 4)
            {
               _loc2_ = [saveInfoRepere[_loc1_].x * 1.5,saveInfoRepere[_loc1_].y * 1.5,undefined];
               RMouvement(univers,_loc1_,undefined,_loc2_,0,20,"easeInOutBack");
            }
            else
            {
               _loc2_ = [0,0,undefined];
               RMouvement(univers,_loc1_,undefined,_loc2_,0,5,"easeInCubic");
            }
            _loc1_ = _loc1_ + 1;
         }
      }
      ,function()
      {
         info_mask.Mouvement("_xscale",0,100,1,10,"easeOutCubic");
         info_mask.Mouvement("_yscale",0,100,1,10,"easeOutCubic");
         _root.info.info_mc.gotoAndStop(id + 1);
         var _loc1_ = 5;
         var _loc2_;
         while(_loc1_ < univers.array.length)
         {
            _loc2_ = [saveInfoRepere[_loc1_].x * 2.1,saveInfoRepere[_loc1_].y * 2.1,undefined];
            RMouvement(univers,_loc1_,undefined,_loc2_,0,10,"easeOutCubic");
            _loc1_ = _loc1_ + 1;
         }
      }
      );
      retardateur(26,2,function()
      {
         _root.bt_retour.onRelease = function()
         {
            _root.info.retourMenuInfo();
         };
         activeAllInfoAutreBt();
         infoEnterFrame();
      }
      );
   }
}
function selectInfoAutreCube(id)
{
   delete _root.info.onEnterFrame;
   deactiveAllInfoBt();
   var boolxy = random(2);
   var boolpm = random(2);
   var endRot = boolpm != 0 ? -180 : 180;
   with(_root.info)
   {
      info_mask.Mouvement("_xscale",100,0,1,10,"easeInCubic");
      info_mask.Mouvement("_yscale",100,0,1,10,"easeInCubic");
      var m = 0;
      while(m <= univers.array.length)
      {
         if(m <= 4)
         {
            if(boolxy == 0)
            {
               RRotation(univers,m,{x:0},{x:endRot},0,20,"easeInOutSine");
            }
            else
            {
               RRotation(univers,m,{x:0,y:0},{x:undefined,y:endRot},0,20,"easeInOutSine");
            }
         }
         else
         {
            var end = [0,0,undefined];
            RMouvement(univers,m,undefined,end,0,10,"easeInCubic");
         }
         m++;
      }
      retardateur(11,10,function()
      {
         info_mask.Mouvement("_xscale",0,100,1,10,"easeOutCubic");
         info_mask.Mouvement("_yscale",0,100,1,10,"easeOutCubic");
         _root.info.info_mc.gotoAndStop(id + 1);
         var _loc1_ = 5;
         var _loc2_;
         while(_loc1_ < univers.array.length)
         {
            _loc2_ = [saveInfoRepere[_loc1_].x * 2.1,saveInfoRepere[_loc1_].y * 2.1,undefined];
            RMouvement(univers,_loc1_,undefined,_loc2_,0,10,"easeOutCubic");
            _loc1_ = _loc1_ + 1;
         }
      }
      ,function()
      {
         _root.bt_retour.onRelease = function()
         {
            _root.info.retourMenuInfo()();
         };
         infoEnterFrame();
         activeAllInfoAutreBt();
      }
      );
   }
}
function retourMenuInfo()
{
   delete _root.info.onEnterFrame;
   deactiveAllInfoBt();
   with(_root.info)
   {
      info_mask.Mouvement("_xscale",100,0,1,10,"easeInCubic");
      info_mask.Mouvement("_yscale",100,0,1,10,"easeInCubic");
      var m = 5;
      while(m <= univers.array.length)
      {
         var end = [0,0,undefined];
         RMouvement(univers,m,undefined,end,0,10,"easeInCubic");
         m++;
      }
      retardateur(11,10,function()
      {
         var _loc1_ = 0;
         var _loc2_;
         while(_loc1_ < univers.array.length)
         {
            _loc2_ = [saveInfoRepere[_loc1_].x,saveInfoRepere[_loc1_].y,undefined];
            RMouvement(univers,_loc1_,undefined,_loc2_,0,10,"easeOutCubic");
            _loc1_ = _loc1_ + 1;
         }
      }
      ,function()
      {
         _root.bt_retour.onRelease = function()
         {
            _root.info.sortieInfoVizu();
         };
         infoEnterFrameInit();
         activeAllInfoBtInit();
      }
      );
   }
}
function infoEnterFrameInit()
{
   _root.info.onEnterFrame = function()
   {
      univers.rotateXY(_ymouse / 50,_xmouse / 50);
   };
}
function infoEnterFrame()
{
   _root.info.onEnterFrame = function()
   {
      univers.rotateObjectZ(0,4,(- _xmouse) / 150);
      univers.rotateObjectZ(5,22,(- _ymouse) / 150);
   };
}
function introInfo()
{
   var _loc3_ = 1;
   while(_loc3_ <= 5)
   {
      _global["snd_info_amb_" + _loc3_].setVolume(0);
      _global["snd_info_amb_" + _loc3_].start(0,99999999);
      _global["snd_info_amb_" + _loc3_].SoundVolume(0,50,0,60,"easeInOutSine");
      _loc3_ = _loc3_ + 1;
   }
   var _loc1_ = 5;
   while(_loc1_ < univers.array.length)
   {
      univers.array[_loc1_].position.reset(saveInfoRepere[_loc1_].x * 7,saveInfoRepere[_loc1_].y * 7,saveInfoRepere[_loc1_].z);
      univers.array[_loc1_].render(500);
      var end = [saveInfoRepere[_loc1_].x,saveInfoRepere[_loc1_].y,undefined];
      RMouvement(univers,_loc1_,undefined,end,0,40,"easeOutBack");
      _loc1_ = _loc1_ + 1;
   }
   var _loc2_ = 0;
   while(_loc2_ <= 4)
   {
      univers.array[_loc2_].position.reset(-700,0,0);
      univers.array[_loc2_].render(500);
      RMouvement(univers,_loc2_,[-700],[-200],_loc2_ * 12 + 10,10,"easeOutCubic");
      _loc2_ = _loc2_ + 1;
   }
   retardateur(22,12,function()
   {
      RRotation(univers,0,{x:undefined,y:undefined,z:0},{x:undefined,y:undefined,z:-72},0,10,"easeOutCubic");
   }
   ,function()
   {
      RRotation(univers,0,{x:undefined,y:undefined,z:0},{x:undefined,y:undefined,z:-72},0,10,"easeOutCubic");
      RRotation(univers,1,{x:undefined,y:undefined,z:0},{x:undefined,y:undefined,z:-72},0,10,"easeOutCubic");
   }
   );
   retardateur(34,12,function()
   {
      RRotation(univers,0,{x:undefined,y:undefined,z:0},{x:undefined,y:undefined,z:-72},0,10,"easeOutCubic");
      RRotation(univers,1,{x:undefined,y:undefined,z:0},{x:undefined,y:undefined,z:-72},0,10,"easeOutCubic");
   }
   ,function()
   {
      RRotation(univers,0,{x:undefined,y:undefined,z:0},{x:undefined,y:undefined,z:-72},0,10,"easeOutCubic");
      RRotation(univers,1,{x:undefined,y:undefined,z:0},{x:undefined,y:undefined,z:-72},0,10,"easeOutCubic");
      RRotation(univers,2,{x:undefined,y:undefined,z:0},{x:undefined,y:undefined,z:-72},0,10,"easeOutCubic");
   }
   );
   retardateur(58,20,function()
   {
      RRotation(univers,0,{x:undefined,y:undefined,z:0},{x:undefined,y:undefined,z:-72},0,10,"easeOutCubic");
      RRotation(univers,1,{x:undefined,y:undefined,z:0},{x:undefined,y:undefined,z:-72},0,10,"easeOutCubic");
      RRotation(univers,2,{x:undefined,y:undefined,z:0},{x:undefined,y:undefined,z:-72},0,10,"easeOutCubic");
      RRotation(univers,3,{x:undefined,y:undefined,z:0},{x:undefined,y:undefined,z:-72},0,10,"easeOutCubic");
   }
   ,function()
   {
      var _loc1_ = _root;
      _loc1_.bt_retour.onRelease = function()
      {
         _root.info.sortieInfoVizu();
      };
      _loc1_.sample.soundAmbient_info();
      activeAllInfoBtInit();
      infoEnterFrameInit();
   }
   );
}
function sortieInfoVizu()
{
   delete _root.sample.onEnterFrame;
   var _loc3_ = 1;
   while(_loc3_ <= 5)
   {
      _global["snd_info_amb_" + _loc3_].SoundVolume(undefined,0,0,30,"easeInOutSine");
      _loc3_ = _loc3_ + 1;
   }
   delete _root.info.onEnterFrame;
   deactiveAllInfoBt();
   info_mask.Mouvement("_xscale",undefined,0,1,10,"easeInCubic");
   info_mask.Mouvement("_yscale",undefined,0,1,10,"easeInCubic");
   var _loc2_ = 0;
   while(_loc2_ <= 4)
   {
      var endFuite = univers.array[_loc2_].position.x < 0 ? -800 : 800;
      RMouvement(univers,_loc2_,undefined,[endFuite],_loc2_ * 3,12,"easeInCubic");
      _loc2_ = _loc2_ + 1;
   }
   var t = 5;
   while(t < univers.array.length)
   {
      var end = [0,0,undefined];
      RMouvement(univers,t,undefined,end,0,10,"easeInCubic");
      t++;
   }
   var dep = _level0.MoteurApi.style[_level0.MoteurApi.apiOn.cercle.styleId];
   _level0.setApiLocal("cercle",dep);
   _level0.ApiMouvement("cercle",4,_level0.MoteurApi.style[_level0.MoteurApi.apiOn.cercle.styleId][4],0,0,20,"linearTween",false,false);
   retardateur(14,21,function()
   {
      var _loc1_ = 5;
      var _loc2_;
      while(_loc1_ < univers.array.length)
      {
         _loc2_ = [saveInfoRepere[_loc1_].x * 10,saveInfoRepere[_loc1_].y * 10,undefined];
         RMouvement(univers,_loc1_,undefined,_loc2_,0,20,"easeOutCubic");
         _loc1_ = _loc1_ + 1;
      }
   }
   ,function()
   {
      var _loc2_ = _global;
      for(api in _level0.MoteurApi.apiOn)
      {
         delete _level0.MoteurApi.apiOn[api];
      }
      var _loc1_ = 1;
      while(_loc1_ <= 5)
      {
         _loc2_["snd_info_amb_" + _loc1_].stop();
         _loc1_ = _loc1_ + 1;
      }
      _root.info.removeMovieClip();
      _root.attachMovie("E","E",10);
   }
   );
}
