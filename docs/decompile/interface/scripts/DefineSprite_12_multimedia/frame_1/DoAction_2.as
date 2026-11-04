function suppTextFace()
{
   var _loc2_ = _root;
   var _loc1_ = 0;
   while(_loc1_ <= 3)
   {
      _loc2_.multimedia["BT_" + _loc1_].removeMovieClip();
      _loc1_ = _loc1_ + 1;
   }
}
function cubeItem(argNom, argPosInit, argIdInit, argIdEnd, argId)
{
   var _loc1_ = this;
   _loc1_.nom = argNom;
   _loc1_.posInit = argPosInit;
   _loc1_.idInit = argIdInit;
   _loc1_.idEnd = argIdEnd;
   _loc1_.id = argId;
}
function introMultimedia()
{
   var _loc1_ = _root;
   _loc1_.apiActiveEtat("ligne");
   var initObj = new Vector3d(45,800,-80);
   var _loc2_ = 0;
   var delai = 0;
   _global.snd_multi_amb_1.start(0,900000);
   _global.snd_multi_amb_2.start(0,900000);
   _global.snd_multi_amb_3.start(0,900000);
   _global.snd_multi_amb_4.start(0,900000);
   _global.snd_multi_amb_1.soundVolume(0,100,0,80,"easeInOutSine");
   _global.snd_multi_amb_2.soundVolume(0,100,0,80,"easeInOutSine");
   _global.snd_multi_amb_3.soundVolume(0,100,0,80,"easeInOutSine");
   _global.snd_multi_amb_4.soundVolume(0,100,0,80,"easeInOutSine",undefined,function()
   {
      _root.sample.soundAmbient_multi();
   }
   );
   var dep = [_level0.MoteurApi.style[0][0],_level0.MoteurApi.style[0][1],_level0.MoteurApi.style[0][2],_level0.MoteurApi.style[0][3],0];
   var j = 0;
   var _loc3_;
   while(j <= 3)
   {
      var k = 0;
      while(k <= 7)
      {
         var initTmp = setPosPointCube(k);
         var init = [initObj.x + initTmp.x,initObj.y + initTmp.y,initObj.z + initTmp.z];
         _loc3_ = [initObj.x + initTmp.x,multi_accueil[_loc2_].y,initObj.z + initTmp.z];
         if(_loc2_ == 0)
         {
            RMouvement(univers,_loc2_,init,_loc3_,delai,60,"easeOutBack");
            _loc1_.apiActiveEtat("cube0");
            _loc1_.setApiLocal("cube0",dep);
         }
         else if(_loc2_ == 8)
         {
            RMouvement(univers,_loc2_,init,_loc3_,delai,60,"easeOutBack",function()
            {
               _root.multimedia.BT_1.valid = true;
            }
            );
         }
         else if(_loc2_ == 16)
         {
            RMouvement(univers,_loc2_,init,_loc3_,delai,60,"easeOutBack",function()
            {
               var _loc1_ = _root;
               _loc1_.apiActiveEtat("cube1");
               _loc1_.multimedia.BT_2.valid = true;
               _loc1_.setApiLocal("cube1",dep);
            }
            );
         }
         else if(_loc2_ == 24)
         {
            RMouvement(univers,_loc2_,init,_loc3_,delai,60,"easeOutBack",function()
            {
               var _loc1_ = _root;
               _loc1_.apiActiveEtat("cube2");
               _loc1_.apiActiveEtat("cube3");
               _loc1_.multimedia.BT_3.valid = true;
               _loc1_.setApiLocal("cube2",dep);
               _loc1_.setApiLocal("cube3",dep);
            }
            );
         }
         else
         {
            RMouvement(univers,_loc2_,init,_loc3_,delai,60,"easeOutBack");
         }
         _loc2_ += 1;
         k++;
      }
      this.RMouvement(univers,32,undefined,[300,undefined,undefined],0,90,"easeOutBack");
      this.RMouvement(univers,33,undefined,[-300,undefined,undefined],0,90,"easeOutBack",undefined,function()
      {
         decaleCubeIntro();
      }
      );
      this.createEmptyMovieClip("patchCube0",-4);
      this.patchCube0.onEnterFrame = function()
      {
         t++;
         if(t >= 3)
         {
            _root.multimedia.BT_0.valid = true;
            delete this.onEnterFrame;
            this.removeMovieClip();
         }
      };
      initObj.x -= 30;
      delai += 10;
      j++;
   }
}
function setPosPointCube(id)
{
   var _loc1_ = id;
   var _loc2_;
   if(_loc1_ == 0)
   {
      _loc2_ = {x:-50,y:5,z:110};
   }
   if(_loc1_ == 1)
   {
      _loc2_ = {x:50,y:5,z:110};
   }
   if(_loc1_ == 2)
   {
      _loc2_ = {x:50,y:-5,z:110};
   }
   if(_loc1_ == 3)
   {
      _loc2_ = {x:-50,y:-5,z:110};
   }
   if(_loc1_ == 4)
   {
      _loc2_ = {x:-50,y:5,z:-110};
   }
   if(_loc1_ == 5)
   {
      _loc2_ = {x:50,y:5,z:-110};
   }
   if(_loc1_ == 6)
   {
      _loc2_ = {x:50,y:-5,z:-110};
   }
   if(_loc1_ == 7)
   {
      _loc2_ = {x:-50,y:-5,z:-110};
   }
   return _loc2_;
}
function decaleCubeIntro()
{
   var _loc2_ = 0;
   while(_loc2_ <= 3)
   {
      _level0.ApiMouvement("cube" + _loc2_,4,0,_level0.MoteurApi.style[0][4],0,30,"linearTween",false,true);
      _loc2_ = _loc2_ + 1;
   }
   var _loc1_ = 0;
   var _loc3_;
   while(_loc1_ <= 31)
   {
      _loc3_ = [multi_accueil[_loc1_].x,undefined,undefined];
      RMouvement(univers,_loc1_,undefined,_loc3_,2,40,"easeInOutBack");
      _loc1_ = _loc1_ + 1;
   }
   this.multimediaEnterFrame();
   retardateur(40,1,function()
   {
      activeAllBtEvent();
   }
   );
}
function multimediaSortie()
{
   delete _root.sample.onEnterFrame;
   _global.snd_multi_amb_1.soundVolume(undefined,0,0,70,"easeInOutSine");
   _global.snd_multi_amb_2.soundVolume(undefined,0,0,70,"easeInOutSine");
   _global.snd_multi_amb_3.soundVolume(undefined,0,0,70,"easeInOutSine");
   _global.snd_multi_amb_4.soundVolume(undefined,0,0,70,"easeInOutSine",undefined,function()
   {
      var _loc1_ = _global;
      _loc1_.snd_multi_amb_1.stop();
      _loc1_.snd_multi_amb_2.stop();
      _loc1_.snd_multi_amb_3.stop();
      _loc1_.snd_multi_amb_4.stop();
   }
   );
   suppTextFace();
   delete _root.bt_retour.onRelease;
   var dep = [_level0.MoteurApi.style[0][0],_level0.MoteurApi.style[0][1],_level0.MoteurApi.style[0][2],_level0.MoteurApi.style[0][3],0];
   var _loc1_ = 0;
   while(_loc1_ <= 3)
   {
      _root.setApiLocal("cube" + _loc1_,dep);
      _loc1_ = _loc1_ + 1;
   }
   var id = 0;
   var k = 0;
   var _loc3_;
   var _loc2_;
   while(k <= 3)
   {
      if(k == 0)
      {
         _loc3_ = 159;
      }
      else if(k == 1)
      {
         _loc3_ = 53;
      }
      else if(k == 2)
      {
         _loc3_ = -53;
      }
      else
      {
         _loc3_ = -159;
      }
      _loc2_ = 0;
      while(_loc2_ <= 7)
      {
         var end = [univers.array[id].position.x + _loc3_,undefined,undefined];
         RMouvement(univers,id++,undefined,end,1,20,"easeInOutSine");
         _loc2_ = _loc2_ + 1;
      }
      k++;
   }
   RMouvement(univers,32,undefined,[0,0,0],1,22,"easeInOutSine");
   RMouvement(univers,33,undefined,[0,0,0],1,22,"easeInOutSine",undefined,function()
   {
      var _loc1_ = 32;
      while(_loc1_ <= 33)
      {
         univers.array[_loc1_].timeline["point" + _loc1_].clear();
         univers.array[_loc1_].timeline["point" + _loc1_].lineStyle(2,"0x000000",0);
         univers.array[_loc1_].timeline["point" + _loc1_].lineTo(1,0);
         _loc1_ = _loc1_ + 1;
      }
      var _loc2_ = 0;
      while(_loc2_ <= 31)
      {
         if(_loc2_ != 31)
         {
            RRotation(univers,_loc2_,undefined,{x:undefined,y:undefined,z:90},1,20,"easeInOutSine");
         }
         else
         {
            RRotation(univers,_loc2_,undefined,{x:undefined,y:undefined,z:90},1,20,"easeInOutSine",undefined,function()
            {
               finMulti();
            }
            );
         }
         _loc2_ = _loc2_ + 1;
      }
      RMouvement(univers,32,undefined,[0,0,500],1,20,"easeInBack");
      RMouvement(univers,33,undefined,[0,0,500],1,20,"easeInBack");
   }
   );
}
function finMulti()
{
   var _loc1_ = this;
   _loc1_.createEmptyMovieClip("scale_time",989671);
   var t = 0;
   _loc1_.scale_time.onEnterFrame = function()
   {
      var _loc1_ = this;
      _loc1_._parent.univers.translateObject(0,31,{x:undefined,y:undefined,z:-10});
      if(t == 6)
      {
         _loc1_._parent.cube0.removeMovieClip();
         delete _level0.MoteurApi.apiOn.cube0;
      }
      else if(t == 12)
      {
         _loc1_._parent.cube1.removeMovieClip();
         delete _level0.MoteurApi.apiOn.cube1;
      }
      else if(t == 18)
      {
         _loc1_._parent.cube2.removeMovieClip();
         delete _level0.MoteurApi.apiOn.cube2;
      }
      else if(t == 22)
      {
         _loc1_._parent.cube3.removeMovieClip();
         delete _level0.MoteurApi.apiOn.cube3;
      }
      else if(t == 24)
      {
         _root.attachMovie("E","E",10);
         _root.multimedia.removeMovieClip();
      }
      t++;
   };
}
MovieClip.prototype.multimediaEnterFrame = function()
{
   this.onEnterFrame = function()
   {
      var da = !(_xmouse > -319 && _xmouse < -109) ? (_xmouse + 159) / 200 : _ymouse / 50;
      var _loc3_ = !(_xmouse > -103 && _xmouse < -3) ? (_xmouse + 53) / 200 : _ymouse / 50;
      var _loc2_ = !(_xmouse > 3 && _xmouse < 103) ? (_xmouse - 53) / 200 : _ymouse / 50;
      var _loc1_ = !(_xmouse > 109 && _xmouse < 319) ? (_xmouse - 159) / 200 : _ymouse / 50;
      univers.rotateObjectX(0,7,da);
      univers.rotateObjectX(8,15,_loc3_);
      univers.rotateObjectX(16,23,_loc2_);
      univers.rotateObjectX(24,31,_loc1_);
   };
};
MovieClip.prototype.attachTextFace = function(texte, repere, argId, valid)
{
   var _loc1_ = this;
   _loc1_.attachMovie("bt_multi","mc",1);
   _loc1_.mc.txt.text = texte;
   _loc1_.id = argId;
   _loc1_.valid = _loc1_._visible = valid;
   _loc1_.onEnterFrame = function()
   {
      var _loc1_ = this;
      var _loc3_;
      var _loc2_;
      if(_loc1_.valid)
      {
         _loc1_._visible = true;
         _loc3_ = Math.abs(repere.array[_loc1_.id + 1].screenPos.x - repere.array[_loc1_.id].screenPos.x);
         _loc2_ = Math.abs(repere.array[_loc1_.id + 3].screenPos.y - repere.array[_loc1_.id].screenPos.y);
         _loc1_.mc._x = repere.array[_loc1_.id].screenPos.x;
         _loc1_.mc._y = repere.array[_loc1_.id].position.z >= 0 ? - repere.array[_loc1_.id + 3].screenPos.y : - repere.array[_loc1_.id].screenPos.y;
         _loc1_.mc._width = _loc3_;
         _loc1_.mc._height = _loc2_;
      }
      else
      {
         _loc1_._visible = false;
      }
   };
};
