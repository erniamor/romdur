function createPtsArray(idInit, nbElt)
{
   var _loc2_ = idInit;
   var _loc3_ = new Array();
   var _loc1_ = _loc2_;
   while(_loc1_ < _loc2_ + nbElt)
   {
      _loc3_.push(_loc1_);
      _loc1_ = _loc1_ + 1;
   }
   return _loc3_;
}
function transformCubeTige(i, xCentre, xTaille, duree, equation)
{
   var _loc1_ = i;
   var _loc2_ = xTaille;
   var _loc3_ = equation;
   RMouvement(univers,_loc1_,undefined,[xCentre - _loc2_,undefined,undefined],0,duree,_loc3_);
   RMouvement(univers,_loc1_ + 1,undefined,[xCentre + _loc2_,undefined,undefined],0,duree,_loc3_);
   RMouvement(univers,_loc1_ + 2,undefined,[xCentre + _loc2_,undefined,undefined],0,duree,_loc3_);
   RMouvement(univers,_loc1_ + 3,undefined,[xCentre - _loc2_,undefined,undefined],0,duree,_loc3_);
   RMouvement(univers,_loc1_ + 4,undefined,[xCentre - _loc2_,undefined,undefined],0,duree,_loc3_);
   RMouvement(univers,_loc1_ + 5,undefined,[xCentre + _loc2_,undefined,undefined],0,duree,_loc3_);
   RMouvement(univers,_loc1_ + 6,undefined,[xCentre + _loc2_,undefined,undefined],0,duree,_loc3_);
   RMouvement(univers,_loc1_ + 7,undefined,[xCentre - _loc2_,undefined,undefined],0,duree,_loc3_);
}
function rotationWeb()
{
   delete this.onEnterFrame;
   var _loc1_ = 0;
   while(_loc1_ <= 23)
   {
      univers.array[_loc1_].rotation.x = univers.array[_loc1_].rotation.x %= 360;
      RRotation(univers,_loc1_,undefined,{x:90,y:undefined,z:undefined},0,10,"easeOutSine");
      _loc1_ = _loc1_ + 1;
   }
   var _loc2_ = 24;
   while(_loc2_ <= 31)
   {
      univers.array[_loc2_].rotation.x = univers.array[_loc2_].rotation.x %= 360;
      RRotation(univers,_loc2_,undefined,{x:0,y:undefined,z:undefined},0,10,"easeOutSine");
      _loc2_ = _loc2_ + 1;
   }
   _loc2_ = 32;
   while(_loc2_ <= 33)
   {
      RMouvement(univers,_loc2_,undefined,[-300,undefined,undefined],0,10,"easeOutSine");
      _loc2_ = _loc2_ + 1;
   }
   retardateur(11,2,function()
   {
      _root.multimedia.cloneCubeWeb();
      fuiteAutreCubeWeb(0,600);
      fuiteAutreCubeWeb(8,-600);
      fuiteAutreCubeWeb(16,600);
      RMouvement(univers,32,undefined,[undefined,100,undefined],0,30,"easeOutExpo");
      RMouvement(univers,33,undefined,[undefined,-100,undefined],0,30,"easeOutExpo");
   }
   );
}
function fuiteAutreCubeWeb(iInit, posEnd)
{
   var _loc2_ = iInit;
   var _loc3_ = posEnd;
   var _loc1_ = _loc2_;
   while(_loc1_ <= _loc2_ + 7)
   {
      RMouvement(univers,_loc1_,undefined,[undefined,_loc3_,undefined],10,30,"easeInSine");
      _loc1_ = _loc1_ + 1;
   }
}
function cloneCubeWeb()
{
   var p = _root.multimedia.univers.array.length;
   var _loc3_ = 0;
   var _loc1_;
   var _loc2_;
   while(_loc3_ <= 1)
   {
      var arrlongtmp = _root.multimedia.univers.array.length;
      _loc1_ = 24;
      while(_loc1_ <= 31)
      {
         _loc2_ = {x:univers.array[_loc1_].position.x,y:univers.array[_loc1_].position.y,z:univers.array[_loc1_].position.z};
         univers.array.push(new Point3d(_loc2_.x,_loc2_.y,_loc2_.z,this,0,"0x000000",0,p));
         univers.array[p++].render(univers.pers);
         _loc1_ = _loc1_ + 1;
      }
      _root.multimedia.createEmptyMovieClip("facecube" + (_loc3_ + 4),_loc3_ + 4 + 10001);
      _root.multimedia["facecube" + (_loc3_ + 4)].apiNom = "facecube" + (_loc3_ + 4);
      _root.multimedia["facecube" + (_loc3_ + 4)].createApi(univers,createPtsArray(arrlongtmp,8),"facecube" + (_loc3_ + 4),0,"cube",true,"global");
      _loc3_ = _loc3_ + 1;
   }
   _global.snd_multi_transition.start();
   decaleCubeClone(34,100,20);
   decaleCubeClone(42,-100,20);
   retardateur(21,16,function()
   {
      _global.snd_multi_transition.start();
      transformCubeTige(24,0,40,15,"easeOutSine");
      rotationCubeCloneZ(34,90,15);
      rotationCubeCloneY(42,90,15);
   }
   ,function()
   {
      var _loc3_ = _root;
      _loc3_.apiDesactiveEtat("cube0");
      _loc3_.apiDesactiveEtat("cube1");
      _loc3_.apiDesactiveEtat("cube2");
      miseEnPlaceWeb();
      var _loc1_ = 24;
      var _loc2_;
      while(_loc1_ <= 31)
      {
         _loc2_ = [univers.array[_loc1_].position.x,univers.array[_loc1_].position.y + 120,-300];
         RMouvement(univers,_loc1_,undefined,_loc2_,0,15,"easeOutSine");
         _loc1_ = _loc1_ + 1;
      }
   }
   );
}
function decaleCubeClone(iInit, decalage, duree)
{
   var _loc3_ = iInit;
   var _loc1_ = _loc3_;
   var _loc2_;
   while(_loc1_ <= _loc3_ + 7)
   {
      _loc2_ = [undefined,univers.array[_loc1_].position.y + decalage,undefined];
      RMouvement(univers,_loc1_,undefined,_loc2_,0,duree,"easeOutSine");
      _loc1_ = _loc1_ + 1;
   }
}
function rotationCubeCloneX(iInit, dep, duree)
{
   var _loc2_ = iInit;
   var _loc1_ = _loc2_;
   while(_loc1_ <= _loc2_ + 7)
   {
      RRotation(univers,_loc1_,undefined,{x:dep,y:undefined,z:undefined},0,duree,"easeOutSine");
      _loc1_ = _loc1_ + 1;
   }
}
function rotationCubeCloneY(iInit, dep, duree)
{
   var _loc2_ = iInit;
   var _loc1_ = _loc2_;
   while(_loc1_ <= _loc2_ + 7)
   {
      RRotation(univers,_loc1_,undefined,{x:undefined,y:dep,z:undefined},0,duree,"easeOutSine");
      _loc1_ = _loc1_ + 1;
   }
}
function rotationCubeCloneZ(iInit, dep, duree)
{
   var _loc2_ = iInit;
   var _loc1_ = _loc2_;
   while(_loc1_ <= _loc2_ + 7)
   {
      RRotation(univers,_loc1_,undefined,{x:undefined,y:undefined,z:dep},0,duree,"easeOutSine");
      _loc1_ = _loc1_ + 1;
   }
}
function miseEnPlaceWeb()
{
   _global.snd_multi_transition.start();
   rotationCubeCloneY(34,-180,15);
   rotationCubeCloneX(42,90,15);
   retardateur(16,2,function()
   {
      activeWebAnim();
      _global.snd_multi_transition.start();
   }
   );
}
function activeWebAnim()
{
   var _loc2_ = _global;
   var _loc3_ = _root;
   _loc3_.bt_retour.onRelease = function()
   {
      _root.multimedia.deselectWeb();
   };
   var _loc1_ = 32;
   while(_loc1_ <= 49)
   {
      univers.array[_loc1_].rotation.reset(0,0,0);
      _loc1_ = _loc1_ + 1;
   }
   _loc3_.multimedia.createEmptyMovieClip("tWebAnim",-23454);
   _loc3_.multimedia.tWebAnim.rotCourantG = 0;
   affichMcWeb();
   var firstEnterA = true;
   var firstEnterB = true;
   _loc3_.multimedia.tWebAnim.onEnterFrame = function()
   {
      var _loc1_ = _global;
      if(_xmouse <= 0)
      {
         if(univers.array[42].rotation.y > 0)
         {
            univers.rotateObjectY(42,49,_xmouse / 60);
            firstEnterA = true;
         }
         else if(firstEnterA == true)
         {
            _loc1_.snd_multi_evt_bloc.stop();
            _loc1_.snd_multi_evt_bloc.start();
            firstEnterA = false;
         }
         if(univers.array[34].rotation.y > 0)
         {
            univers.rotateObjectY(34,41,_xmouse / 100);
            firstEnterB = true;
         }
         else if(firstEnterB == true)
         {
            _loc1_.snd_multi_evt_bloc.stop();
            _loc1_.snd_multi_evt_bloc.start();
            firstEnterB = false;
         }
      }
      else
      {
         if(univers.array[42].rotation.y < 90)
         {
            univers.rotateObjectY(42,49,_xmouse / 100);
            firstEnterA = true;
         }
         else if(firstEnterA == true)
         {
            _loc1_.snd_multi_evt_bloc.stop();
            _loc1_.snd_multi_evt_bloc.start();
            firstEnterA = false;
         }
         if(univers.array[34].rotation.y < 90)
         {
            univers.rotateObjectY(34,41,_xmouse / 60);
            firstEnterB = true;
         }
         else if(firstEnterB == true)
         {
            _loc1_.snd_multi_evt_bloc.stop();
            _loc1_.snd_multi_evt_bloc.start();
            firstEnterB = false;
         }
      }
      univers.rotateObjectY(32,33,_xmouse / 200);
   };
}
function affichMcWeb()
{
   _root.multimedia.createEmptyMovieClip("mcWeb",555478);
   _root.multimedia.mcWeb.univers = univers;
   _root.multimedia.mcWeb._visible = false;
   _root.multimedia.mcWeb.Mouvement("_visible",false,true,1,2,"linearTween");
   with(_root.multimedia.mcWeb)
   {
      attachMovie("web_liste","web_liste",10);
      attachMovie("web_info","web_info",11);
      onEnterFrame = function()
      {
         var _loc1_ = univers.array[44].screenPos.x - univers.array[48].screenPos.x;
         var _loc3_ = univers.array[46].screenPos.y - univers.array[48].screenPos.y;
         web_liste._x = univers.array[48].screenPos.x + Math.abs(_loc1_) / 2;
         web_liste._y = univers.array[48].screenPos.y - Math.abs(_loc3_) / 2;
         web_liste._width = _loc1_ < 0 ? 0 : _loc1_;
         web_liste._height = Math.abs(_loc3_);
         web_liste._alpha = _loc1_ < 0 ? 0 : _loc1_ / 2;
         var _loc2_ = univers.array[38].screenPos.x - univers.array[34].screenPos.x;
         var ddy = univers.array[39].screenPos.y - univers.array[38].screenPos.y;
         web_info._x = univers.array[34].screenPos.x + Math.abs(_loc2_) / 2;
         web_info._y = univers.array[38].screenPos.y + Math.abs(ddy) / 2;
         web_info._width = _loc2_ < 0 ? 0 : _loc2_;
         web_info._height = ddy;
         web_info._alpha = _loc2_ < 0 ? 0 : _loc2_ / 2;
      };
   }
}
function deselectWeb()
{
   delete _root.sample.onEnterFrame;
   delete _root.multimedia.mcWeb.onEnterFrame;
   _root.multimedia.mcWeb.removeMovieClip();
   delete _root.multimedia.tWebAnim.onEnterFrame;
   _root.multimedia.tWebAnim.removeMovieClip();
   var _loc3_ = 34;
   while(_loc3_ <= 41)
   {
      RRotation(univers,_loc3_,undefined,{x:undefined,y:90,z:undefined},0,10,"easeOutSine");
      _loc3_ = _loc3_ + 1;
   }
   var _loc2_ = 42;
   while(_loc2_ <= 49)
   {
      RRotation(univers,_loc2_,undefined,{x:undefined,y:0,z:undefined},0,10,"easeOutSine");
      _loc2_ = _loc2_ + 1;
   }
   var _loc1_ = 32;
   while(_loc1_ <= 33)
   {
      univers.array[_loc1_].rotation.y = univers.array[_loc1_].rotation.y %= 360;
      RRotation(univers,_loc1_,undefined,{x:undefined,y:0,z:undefined},0,60,"easeInOutSine");
      RMouvement(univers,_loc1_,undefined,[undefined,0,undefined],0,80,"easeInOutSine");
      _loc1_ = _loc1_ + 1;
   }
   retardateur(11,2,function()
   {
      var _loc1_ = 34;
      while(_loc1_ <= 49)
      {
         if(_loc1_ >= 38 && _loc1_ <= 45)
         {
            RMouvement(univers,_loc1_,undefined,[100,undefined,undefined],0,10,"easeOutSine");
         }
         else
         {
            RMouvement(univers,_loc1_,undefined,[-100,undefined,undefined],0,10,"easeOutSine");
         }
         RRotation(univers,_loc1_,undefined,{x:90,y:undefined,z:undefined},0,10,"easeOutSine");
         _loc1_ = _loc1_ + 1;
      }
      _global.snd_multi_web_amb.soundVolume(undefined,0,0,60,"easeInSine",undefined,function()
      {
         _global.snd_multi_web_amb.stop();
      }
      );
      _global.snd_multi_amb_1.start(0,999999999);
      _global.snd_multi_amb_2.start(0,999999999);
      _global.snd_multi_amb_3.start(0,999999999);
      _global.snd_multi_amb_4.start(0,999999999);
      _global.snd_multi_amb_1.soundVolume(undefined,100,0,60,"easeOutSine");
      _global.snd_multi_amb_2.soundVolume(undefined,100,0,60,"easeOutSine");
      _global.snd_multi_amb_3.soundVolume(undefined,100,0,60,"easeOutSine");
      _global.snd_multi_amb_4.soundVolume(undefined,100,0,60,"easeOutSine",undefined,function()
      {
         _root.sample.soundAmbient_multi();
      }
      );
      collageWebClone();
   }
   );
}
function collageWebClone()
{
   retardateur(11,2,function()
   {
      var _loc1_ = [univers.array[34].position.x,univers.array[34].position.y,univers.array[34].position.z];
      RMouvement(univers,28,undefined,_loc1_,2,10,"easeInSine");
      _loc1_ = [univers.array[37].position.x,univers.array[37].position.y,univers.array[37].position.z];
      RMouvement(univers,31,undefined,_loc1_,2,10,"easeInSine");
      _loc1_ = [univers.array[35].position.x,univers.array[35].position.y,univers.array[35].position.z];
      RMouvement(univers,24,undefined,_loc1_,2,10,"easeInSine");
      _loc1_ = [univers.array[36].position.x,univers.array[36].position.y,univers.array[36].position.z];
      RMouvement(univers,27,undefined,_loc1_,2,10,"easeInSine");
      _loc1_ = [univers.array[38].position.x,univers.array[34].position.y,univers.array[34].position.z];
      RMouvement(univers,29,undefined,_loc1_,2,10,"easeInSine");
      _loc1_ = [univers.array[41].position.x,univers.array[37].position.y,univers.array[37].position.z];
      RMouvement(univers,30,undefined,_loc1_,2,10,"easeInSine");
      _loc1_ = [univers.array[39].position.x,univers.array[35].position.y,univers.array[35].position.z];
      RMouvement(univers,25,undefined,_loc1_,2,10,"easeInSine");
      _loc1_ = [univers.array[40].position.x,univers.array[36].position.y,univers.array[36].position.z];
      RMouvement(univers,26,undefined,_loc1_,2,10,"easeInSine",undefined,function()
      {
         suppCubeWebClone();
      }
      );
   }
   );
}
function suppCubeWebClone()
{
   var _loc2_ = _root;
   _loc2_.apiActiveEtat("cube0");
   _loc2_.apiActiveEtat("cube1");
   _loc2_.apiActiveEtat("cube2");
   _loc2_.apiDesactiveEtat("facecube4");
   _loc2_.apiDesactiveEtat("facecube5");
   _loc2_.multimedia.facecube4.removeMovieClip();
   _loc2_.multimedia.facecube4.removeMovieClip();
   _loc2_.multimedia.univers.array.length = 34;
   var _loc1_ = 24;
   while(_loc1_ <= 31)
   {
      end = [undefined,_loc2_.multimedia.multi_accueil[_loc1_].y,_loc2_.multimedia.multi_accueil[_loc1_].z];
      RMouvement(univers,_loc1_,undefined,end,1,10,"easeOutSine");
      _loc1_ = _loc1_ + 1;
   }
   retardateur(12,2,function()
   {
      placeCubeWebSurLigne();
   }
   );
}
function placeCubeWebSurLigne()
{
   var delai = 20;
   var _loc2_ = 0;
   var _loc3_;
   while(_loc2_ <= 23)
   {
      _loc3_ = [-500,multi_accueil[_loc2_].y,multi_accueil[_loc2_].z];
      var endAutreCube = [multi_accueil[_loc2_].x,multi_accueil[_loc2_].y,multi_accueil[_loc2_].z];
      RMouvement(univers,_loc2_,_loc3_,endAutreCube,delai,20,"easeOutSine");
      if(_loc2_ == 7 || _loc2_ == 15)
      {
         delai -= 10;
      }
      _loc2_ = _loc2_ + 1;
   }
   var _loc1_ = 24;
   while(_loc1_ <= 31)
   {
      end = [_root.multimedia.multi_accueil[_loc1_].x,undefined,undefined];
      RMouvement(univers,_loc1_,undefined,end,0,20,"easeOutSine");
      _loc1_ = _loc1_ + 1;
   }
   RMouvement(univers,32,undefined,[-300,undefined,undefined],30,40,"easeInOutSine");
   RMouvement(univers,33,undefined,[300,undefined,undefined],30,40,"easeInOutSine");
   retardateur(41,42,function()
   {
      var _loc2_ = _root;
      activeAllBtEvent();
      var _loc1_ = 0;
      while(_loc1_ <= univers.array.length)
      {
         univers.array[_loc1_].rotation.reset(-6,0,0);
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
MovieClip.prototype.selectWeb = function(id)
{
   var _loc1_ = _global;
   var _loc2_ = _root;
   delete _loc2_.sample.onEnterFrame;
   _loc1_.snd_multi_amb_1.soundVolume(undefined,0,0,50,"easeInOutSine");
   _loc1_.snd_multi_amb_2.soundVolume(undefined,0,0,50,"easeInOutSine");
   _loc1_.snd_multi_amb_3.soundVolume(undefined,0,0,50,"easeInOutSine");
   _loc1_.snd_multi_amb_4.soundVolume(undefined,0,0,50,"easeInOutSine",undefined,function()
   {
      var _loc1_ = _global;
      _loc1_.snd_multi_amb_1.stop();
      _loc1_.snd_multi_amb_2.stop();
      _loc1_.snd_multi_amb_3.stop();
      _loc1_.snd_multi_amb_4.stop();
   }
   );
   _loc1_.snd_multi_web_amb.start(0,99999999);
   _loc1_.snd_multi_web_amb.soundVolume(undefined,75,0,60,"easeInOutSine",function()
   {
      _root.sample.soundAmbient_web();
   }
   );
   delete _loc2_.bt_retour.onRelease;
   transformCubeTige(0,-270,5,10,"easeOutSine");
   transformCubeTige(8,-255,5,10,"easeOutSine");
   transformCubeTige(16,-240,5,10,"easeOutSine");
   transformCubeTige(24,0,150,10,"easeOutCubic");
   retardateur(11,2,function()
   {
      rotationWeb();
   }
   );
};
