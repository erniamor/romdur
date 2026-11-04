function autreCubeAudioRotRel()
{
   var _loc3_ = this;
   audioARControl();
   var _loc2_ = [undefined,undefined,-490];
   var _loc1_ = 8;
   while(_loc1_ <= 31)
   {
      _loc3_.RMouvement(univers,_loc1_,undefined,_loc2_,4,15,"easeInOutSine");
      _loc1_ = _loc1_ + 1;
   }
}
function audioARControl()
{
   RMouvement(univers,32,undefined,[-159,undefined,undefined],0,10,"easeInOutSine");
   RMouvement(univers,33,undefined,[-159,undefined,undefined],0,10,"easeInOutSine",undefined,function()
   {
      RMouvement(univers,32,undefined,[0,undefined,undefined],2,20,"easeInOutSine");
      RMouvement(univers,33,undefined,[0,undefined,undefined],2,20,"easeInOutSine",function()
      {
         loopingAudio();
      }
      );
   }
   );
}
function loopingAudio()
{
   this.RRotationRelative(univers,0,33,undefined,{x:undefined,y:undefined,z:-360},0,20,"easeInOutSine",undefined,function()
   {
      transformCube();
   }
   );
   var _loc1_ = 1;
   while(_loc1_ <= 7)
   {
      this.RRotationRelative(univers,_loc1_,33,undefined,{x:undefined,y:undefined,z:-360},0,20,"easeInOutSine");
      _loc1_ = _loc1_ + 1;
   }
}
function transformCube()
{
   var _loc3_ = this;
   _root.apiDesactiveEtat("cube0");
   _root.apiDesactiveEtat("cube1");
   _root.apiDesactiveEtat("cube2");
   _root.apiDesactiveEtat("cube3");
   var p = univers.array.length;
   var j = 0;
   var _loc1_;
   var _loc2_;
   while(j <= 2)
   {
      _loc1_ = 0;
      while(_loc1_ <= 7)
      {
         _loc2_ = {x:univers.array[_loc1_].position.x,y:univers.array[_loc1_].position.y,z:univers.array[_loc1_].position.z};
         univers.array.push(new Point3d(_loc2_.x,_loc2_.y,_loc2_.z,_loc3_,1,"0x000000",0,p));
         univers.array[p++].render(univers.pers);
         _loc1_ = _loc1_ + 1;
      }
      j++;
   }
   _loc3_.createEmptyMovieClip("faceCube1",10004);
   _loc3_.faceCube1.apiNom = "faceCube1";
   _loc3_.faceCube1.createApi(univers,[34,35,36,37],"faceCube1",0,"standardFillLine",true,"global");
   _loc3_.createEmptyMovieClip("faceCube2",10005);
   _loc3_.faceCube2.apiNom = "faceCube2";
   _loc3_.faceCube2.createApi(univers,[38,39,40,41],"faceCube2",0,"standardFillLine",true,"global");
   _loc3_.createEmptyMovieClip("faceCube3",10006);
   _loc3_.faceCube3.apiNom = "faceCube3";
   _loc3_.faceCube3.createApi(univers,[42,43,47,46],"faceCube3",0,"standardFillLine",true,"global");
   _loc3_.createEmptyMovieClip("faceCube4",10007);
   _loc3_.faceCube4.apiNom = "faceCube4";
   _loc3_.faceCube4.createApi(univers,[44,45,49,48],"faceCube4",0,"standardFillLine",true,"global");
   _loc3_.createEmptyMovieClip("faceCube5",10008);
   _loc3_.faceCube5.apiNom = "faceCube5";
   _loc3_.faceCube5.createApi(univers,[50,54,57,53],"faceCube5",0,"standardFillLine",true,"global");
   _loc3_.createEmptyMovieClip("faceCube6",10009);
   _loc3_.faceCube6.apiNom = "faceCube6";
   _loc3_.faceCube6.createApi(univers,[51,52,56,55],"faceCube6",0,"standardFillLine",true,"global");
   eclateCubeAudio();
   var inc = univers.array.length;
   univers.array.push(new Point3d(0,-180,-150,_loc3_,0,"0x000000",0,inc));
}
function eclateCubeAudio()
{
   retardateur(4,5,function()
   {
      _global.snd_multi_transition.start();
   }
   );
   this.BT_0.id = 38;
   var _loc1_ = 34;
   while(_loc1_ <= 58)
   {
      if(_loc1_ >= 34 && _loc1_ <= 37)
      {
         RMouvement(univers,_loc1_,undefined,[undefined,undefined,400],4,50,"easeOutQuad");
      }
      else if(_loc1_ >= 38 && _loc1_ <= 41)
      {
         RMouvement(univers,_loc1_,undefined,[undefined,undefined,-400],4,50,"easeOutQuad");
      }
      else if(_loc1_ == 42 || _loc1_ == 43 || _loc1_ == 47 || _loc1_ == 46)
      {
         RMouvement(univers,_loc1_,undefined,[undefined,60,undefined],4,50,"easeOutQuad");
      }
      else if(_loc1_ == 44 || _loc1_ == 45 || _loc1_ == 49 || _loc1_ == 48)
      {
         RMouvement(univers,_loc1_,undefined,[undefined,-60,undefined],4,50,"easeOutQuad");
      }
      else if(_loc1_ == 50 || _loc1_ == 54 || _loc1_ == 57 || _loc1_ == 53)
      {
         RMouvement(univers,_loc1_,undefined,[-200,undefined,undefined],4,50,"easeOutQuad");
      }
      else if(_loc1_ == 51 || _loc1_ == 52 || _loc1_ == 56)
      {
         RMouvement(univers,_loc1_,undefined,[200,undefined,undefined],4,50,"easeOutQuad");
      }
      else
      {
         RMouvement(univers,_loc1_,undefined,[200,undefined,undefined],4,50,"easeOutQuad",undefined,function()
         {
            placeCubeAudioEclat();
         }
         );
      }
      _loc1_ = _loc1_ + 1;
   }
}
function placeCubeAudioEclat()
{
   RMouvement(univers,32,undefined,[250,150,0],1,40,"easeInCubic");
   RMouvement(univers,33,undefined,[250,-150,0],1,40,"easeInCubic",undefined,function()
   {
      affichMcAudio();
   }
   );
   var _loc1_ = new Vector3d(-50,120,-300);
   RMouvement(univers,38,undefined,[_loc1_.x,_loc1_.y,_loc1_.z],1,40,"easeInCubic");
   RMouvement(univers,39,undefined,[_loc1_.x + 100,_loc1_.y,_loc1_.z],1,40,"easeInCubic");
   RMouvement(univers,40,undefined,[_loc1_.x + 100,_loc1_.y - 10,_loc1_.z],1,40,"easeInCubic");
   RMouvement(univers,41,undefined,[_loc1_.x,_loc1_.y - 10,_loc1_.z],1,40,"easeInCubic");
   _loc1_ = new Vector3d(0,60,-200);
   RMouvement(univers,34,undefined,[_loc1_.x + 50,_loc1_.y + 15,_loc1_.z],1,40,"easeInCubic");
   RMouvement(univers,35,undefined,[_loc1_.x - 50,_loc1_.y + 15,_loc1_.z],1,40,"easeInCubic");
   RMouvement(univers,36,undefined,[_loc1_.x - 50,_loc1_.y - 15,_loc1_.z],1,40,"easeInCubic");
   RMouvement(univers,37,undefined,[_loc1_.x + 50,_loc1_.y - 15,_loc1_.z],1,40,"easeInCubic");
   _loc1_ = new Vector3d(-200,110,50);
   RMouvement(univers,42,undefined,[_loc1_.x,_loc1_.y,_loc1_.z],1,20,"easeInSine");
   RMouvement(univers,43,undefined,[_loc1_.x,_loc1_.y,_loc1_.z - 100],1,20,"easeInSine");
   RMouvement(univers,47,undefined,[_loc1_.x,_loc1_.y - 220,_loc1_.z - 100],1,20,"easeInSine");
   RMouvement(univers,46,undefined,[_loc1_.x,_loc1_.y - 220,_loc1_.z],1,20,"easeInSine",undefined,function()
   {
      RRotation(univers,42,undefined,{x:undefined,y:-60,z:undefined},1,20,"easeInSine");
      RRotation(univers,43,undefined,{x:undefined,y:-60,z:undefined},1,20,"easeInSine");
      RRotation(univers,47,undefined,{x:undefined,y:-60,z:undefined},1,20,"easeInSine");
      RRotation(univers,46,undefined,{x:undefined,y:-60,z:undefined},1,20,"easeInSine",function()
      {
         _global.snd_multi_transition.start();
      }
      );
   }
   );
   _loc1_ = new Vector3d(200,110,-50);
   RMouvement(univers,44,undefined,[_loc1_.x,_loc1_.y,_loc1_.z],1,20,"easeInSine");
   RMouvement(univers,45,undefined,[_loc1_.x,_loc1_.y,_loc1_.z + 100],1,20,"easeInSine");
   RMouvement(univers,49,undefined,[_loc1_.x,_loc1_.y - 220,_loc1_.z + 100],1,20,"easeInSine");
   RMouvement(univers,48,undefined,[_loc1_.x,_loc1_.y - 220,_loc1_.z],1,20,"easeInSine",undefined,function()
   {
      RRotation(univers,44,undefined,{x:undefined,y:60,z:undefined},1,20,"easeInSine");
      RRotation(univers,45,undefined,{x:undefined,y:60,z:undefined},1,20,"easeInSine");
      RRotation(univers,49,undefined,{x:undefined,y:60,z:undefined},1,20,"easeInSine");
      RRotation(univers,48,undefined,{x:undefined,y:60,z:undefined},1,20,"easeInSine");
   }
   );
   _loc1_ = new Vector3d(0,0,-200);
   RMouvement(univers,50,undefined,[_loc1_.x - 50,_loc1_.y - 12,_loc1_.z],1,40,"easeInSine");
   RMouvement(univers,54,undefined,[_loc1_.x + 50,_loc1_.y - 12,_loc1_.z],1,40,"easeInSine");
   RMouvement(univers,57,undefined,[_loc1_.x + 50,_loc1_.y + 12,_loc1_.z],1,40,"easeInSine");
   RMouvement(univers,53,undefined,[_loc1_.x - 50,_loc1_.y + 12,_loc1_.z],1,40,"easeInSine");
   _loc1_ = new Vector3d(0,-60,-200);
   RMouvement(univers,51,undefined,[_loc1_.x - 50,_loc1_.y + 15,_loc1_.z],1,40,"easeInSine");
   RMouvement(univers,52,undefined,[_loc1_.x + 50,_loc1_.y + 15,_loc1_.z],1,40,"easeInSine");
   RMouvement(univers,56,undefined,[_loc1_.x + 50,_loc1_.y - 15,_loc1_.z],1,40,"easeInSine");
   RMouvement(univers,55,undefined,[_loc1_.x - 50,_loc1_.y - 15,_loc1_.z],1,40,"easeInSine");
}
function affichMcAudio()
{
   _global.snd_multi_transition.start();
   _root.bt_retour.onRelease = function()
   {
      _root.multimedia.deselectAudio();
   };
   var i = 34;
   while(i <= 37)
   {
      univers.array[i].rotation.reset(0,0,0);
      i++;
   }
   _root.multimedia.mcAudio.univers = univers;
   _root.multimedia.createEmptyMovieClip("mcAudio",555485);
   with(_root.multimedia.mcAudio)
   {
      attachMovie("audio_liste","audio_liste",10);
      attachMovie("audio_info","audio_info",11);
      attachMovie("audio_lecteur","audio_lecteur",13);
      attachMovie("audio_lanceur","audio_lanceur",12);
      attachMovie("audio_indicateur","audio_indicateur",14);
      audio_liste.textureAudio(42,43,46,42);
      audio_info.textureAudioInfo(44,45,48,45);
      audio_lecteur.textureAudioLecteur(35,34,36,37);
      audio_lanceur.textureAudioLecteur(55,52,51,52);
      audio_indicateur.textureAudioIndic(50,54,57,53);
   }
   with(_root.multimedia)
   {
      rot = 0;
      var firstEnter = true;
      onEnterFrame = function()
      {
         mcAudio.audio_liste.textureAudio(42,43,46,42);
         mcAudio.audio_info.textureAudioInfo(44,45,48,45);
         mcAudio.audio_lecteur.textureAudioLecteur(35,34,36,35);
         mcAudio.audio_lanceur.textureAudioLecteur(55,52,51,52);
         mcAudio.audio_indicateur.textureAudioIndic(50,54,57,57);
         var _loc1_ = _xmouse / 180;
         if(_xmouse < 10)
         {
            if(rot > -30)
            {
               univers.rotateObjectY(34,37,_loc1_);
               univers.rotateObjectY(42,57,_loc1_);
               rot += _loc1_;
               firstEnter = true;
            }
            else if(firstEnter == true)
            {
               _global.snd_multi_evt_bloc.start();
               firstEnter = false;
            }
         }
         else if(_xmouse > 10)
         {
            if(rot < 30)
            {
               univers.rotateObjectY(34,37,_loc1_);
               univers.rotateObjectY(42,57,_loc1_);
               rot += _loc1_;
               firstEnter = true;
            }
            else if(firstEnter == true)
            {
               _global.snd_multi_evt_bloc.start();
               firstEnter = false;
            }
         }
         univers.rotateObjectY(32,33,_xmouse / 100);
      };
   }
}
function audioCloseBoite()
{
   with(_root.multimedia.mcAudio)
   {
      audio_liste.removeMovieClip();
      audio_info.removeMovieClip();
      audio_lanceur.removeMovieClip();
      audio_lecteur.removeMovieClip();
      audio_indicateur.removeMovieClip();
   }
}
function replaceAudioCube()
{
   _root.apiActiveEtat("cube1");
   _root.apiActiveEtat("cube2");
   _root.apiActiveEtat("cube3");
   with(_root.multimedia)
   {
      var idInitCube = 0;
      var k = 32;
      while(k <= 33)
      {
         RMouvement(univers,k,undefined,[multi_accueil[k].x,multi_accueil[k].y,multi_accueil[k].z],0,30,"easeInOutSine");
         k++;
      }
      RMouvement(univers,34,undefined,[multi_accueil[0].x,multi_accueil[0].y,multi_accueil[0].z],0,30,"easeInOutSine");
      RMouvement(univers,35,undefined,[multi_accueil[1].x,multi_accueil[1].y,multi_accueil[1].z],0,30,"easeInOutSine");
      RMouvement(univers,36,undefined,[multi_accueil[2].x,multi_accueil[2].y,multi_accueil[2].z],0,30,"easeInOutSine");
      RMouvement(univers,37,undefined,[multi_accueil[3].x,multi_accueil[3].y,multi_accueil[3].z],0,30,"easeInOutSine");
      RMouvement(univers,38,undefined,[multi_accueil[4].x,multi_accueil[4].y,multi_accueil[4].z],0,30,"easeInOutSine");
      RMouvement(univers,39,undefined,[multi_accueil[5].x,multi_accueil[5].y,multi_accueil[5].z],0,30,"easeInOutSine");
      RMouvement(univers,40,undefined,[multi_accueil[6].x,multi_accueil[6].y,multi_accueil[6].z],0,30,"easeInOutSine");
      RMouvement(univers,41,undefined,[multi_accueil[7].x,multi_accueil[7].y,multi_accueil[7].z],0,30,"easeInOutSine");
      RMouvement(univers,42,undefined,[multi_accueil[0].x,multi_accueil[0].y,multi_accueil[0].z],0,30,"easeInOutSine");
      RMouvement(univers,43,undefined,[multi_accueil[1].x,multi_accueil[1].y,multi_accueil[1].z],0,30,"easeInOutSine");
      RMouvement(univers,47,undefined,[multi_accueil[5].x,multi_accueil[5].y,multi_accueil[5].z],0,30,"easeInOutSine");
      RMouvement(univers,46,undefined,[multi_accueil[4].x,multi_accueil[4].y,multi_accueil[4].z],0,30,"easeInOutSine");
      RMouvement(univers,44,undefined,[multi_accueil[3].x,multi_accueil[3].y,multi_accueil[3].z],0,30,"easeInOutSine");
      RMouvement(univers,45,undefined,[multi_accueil[2].x,multi_accueil[2].y,multi_accueil[2].z],0,30,"easeInOutSine");
      RMouvement(univers,49,undefined,[multi_accueil[6].x,multi_accueil[6].y,multi_accueil[6].z],0,30,"easeInOutSine");
      RMouvement(univers,48,undefined,[multi_accueil[7].x,multi_accueil[7].y,multi_accueil[7].z],0,30,"easeInOutSine");
      RMouvement(univers,50,undefined,[multi_accueil[0].x,multi_accueil[0].y,multi_accueil[0].z],0,30,"easeInOutSine");
      RMouvement(univers,54,undefined,[multi_accueil[3].x,multi_accueil[3].y,multi_accueil[3].z],0,30,"easeInOutSine");
      RMouvement(univers,57,undefined,[multi_accueil[7].x,multi_accueil[7].y,multi_accueil[7].z],0,30,"easeInOutSine");
      RMouvement(univers,53,undefined,[multi_accueil[4].x,multi_accueil[4].y,multi_accueil[4].z],0,30,"easeInOutSine");
      RMouvement(univers,51,undefined,[multi_accueil[1].x,multi_accueil[1].y,multi_accueil[1].z],0,30,"easeInOutSine");
      RMouvement(univers,52,undefined,[multi_accueil[2].x,multi_accueil[2].y,multi_accueil[2].z],0,30,"easeInOutSine");
      RMouvement(univers,56,undefined,[multi_accueil[6].x,multi_accueil[6].y,multi_accueil[6].z],0,30,"easeInOutSine");
      RMouvement(univers,55,undefined,[multi_accueil[5].x,multi_accueil[5].y,multi_accueil[5].z],0,30,"easeInOutSine",undefined,function()
      {
         supprFaceBoite();
         RMouvement(univers,32,undefined,[300,0,0],10,60,"easeOutBack");
         RMouvement(univers,33,undefined,[-300,0,0],10,60,"easeOutBack");
      }
      );
      var s = 0;
      while(s <= 7)
      {
         univers.array[s].position.x = multi_accueil[s].x;
         univers.array[s].position.y = multi_accueil[s].y;
         univers.array[s].position.z = multi_accueil[s].z;
         univers.array[s].render(univers.pers);
         s++;
      }
      var w = 0;
      while(w <= 33)
      {
         univers.array[w].rotation.x = -6;
         univers.array[w].rotation.z = 0;
         univers.array[w].rotation.z = 0;
         w++;
      }
      var delai = 30;
      var j = 8;
      while(j <= 31)
      {
         var initAutreCube = [500,multi_accueil[j].y,multi_accueil[j].z];
         var endAutreCube = [multi_accueil[j].x,multi_accueil[j].y,multi_accueil[j].z];
         RMouvement(univers,j,initAutreCube,endAutreCube,delai,20,"easeOutSine");
         if(j == 15 || j == 23)
         {
            delai += 10;
         }
         j++;
      }
   }
}
function supprFaceBoite()
{
   var _loc2_ = _root;
   var _loc3_ = this;
   _loc2_.apiActiveEtat("cube0");
   var _loc1_ = 1;
   while(_loc1_ <= 6)
   {
      _loc3_["faceCube" + _loc1_].removeMovieClip();
      _loc2_.apiDesactiveEtat("facecube" + _loc1_);
      _loc1_ = _loc1_ + 1;
   }
   _loc3_.univers.array.length = 34;
   _loc3_.BT_0.id = 4;
   retardateur(40,42,function()
   {
      activeAllBtEvent();
      _root.multimedia.multimediaEnterFrame();
   }
   );
   _loc2_.bt_retour.onRelease = function()
   {
      _root.multimedia.multimediaSortie();
   };
}
MovieClip.prototype.selectAudio = function(id)
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
   delete _root.bt_retour.onRelease;
   var endLine = [53,undefined,undefined];
   var _loc3_ = {x:-6,y:undefined,z:undefined};
   var endCubesMv = [300,undefined,undefined];
   var _loc1_ = 0;
   while(_loc1_ <= 33)
   {
      if(_loc1_ <= 7)
      {
         univers.array[_loc1_].rotation.x = univers.array[_loc1_].rotation.x %= 360;
         RRotation(univers,_loc1_,undefined,_loc3_,0,15,"easeInOutSine");
         RRotation(univers,_loc1_,undefined,_loc3_,0,15,"easeInOutSine");
      }
      else if(_loc1_ <= 31)
      {
         if(_loc1_ == 31)
         {
            univers.array[_loc1_].rotation.x = univers.array[_loc1_].rotation.x %= 360;
            RRotation(univers,_loc1_,undefined,{x:0,y:undefined,z:undefined},0,15,"easeInOutSine",undefined,function()
            {
               var _loc1_ = 8;
               while(_loc1_ <= 31)
               {
                  if(_loc1_ == 31)
                  {
                     RRotationRelative(univers,_loc1_,33,undefined,{x:undefined,y:undefined,z:90},2,10,"easeInOutSine",undefined,function()
                     {
                        autreCubeAudioRotRel();
                     }
                     );
                  }
                  else
                  {
                     RRotationRelative(univers,_loc1_,33,undefined,{x:undefined,y:undefined,z:90},2,10,"easeInOutSine");
                  }
                  _loc1_ = _loc1_ + 1;
               }
            }
            );
         }
         else
         {
            univers.array[_loc1_].rotation.x = univers.array[_loc1_].rotation.x %= 360;
            RRotation(univers,_loc1_,undefined,{x:0,y:undefined,z:undefined},0,15,"easeInOutSine");
         }
      }
      else
      {
         RMouvement(univers,_loc1_,undefined,endLine,0,15,"easeInOutSine");
      }
      _loc1_ = _loc1_ + 1;
   }
};
MovieClip.prototype.textureAudio = function(id, idW, idH, idY)
{
   var _loc1_ = this;
   var _loc2_ = id;
   _loc1_._x = univers.array[_loc2_].screenPos.x;
   _loc1_._y = - univers.array[_loc2_].screenPos.y;
   _loc1_._width = Math.round(Math.abs(univers.array[_loc2_].screenPos.x - univers.array[idW].screenPos.x));
   _loc1_._height = Math.round(Math.abs(univers.array[idY].screenPos.y - univers.array[idH].screenPos.y));
};
MovieClip.prototype.textureAudioInfo = function(id, idW, idH, idY)
{
   var _loc1_ = this;
   var _loc2_ = id;
   _loc1_._x = univers.array[_loc2_].screenPos.x;
   _loc1_._y = (- (univers.array[_loc2_].screenPos.y + univers.array[idH].screenPos.y)) / 2;
   _loc1_._width = Math.round(Math.abs(univers.array[_loc2_].screenPos.x - univers.array[idW].screenPos.x));
   _loc1_._height = Math.round(Math.abs(univers.array[idY].screenPos.y - univers.array[idH].screenPos.y));
};
MovieClip.prototype.textureAudioLecteur = function(id, idW, idH, idC)
{
   var _loc1_ = id;
   var _loc2_ = this;
   var _loc3_ = idW;
   _loc2_._x = (univers.array[_loc1_].screenPos.x + univers.array[_loc3_].screenPos.x) / 2;
   _loc2_._y = 12 - (univers.array[_loc1_].screenPos.y + univers.array[idH].screenPos.y + univers.array[_loc3_].screenPos.y + univers.array[idC].screenPos.y) / 4;
   _loc2_._width = Math.round(Math.abs(univers.array[_loc1_].screenPos.x - univers.array[_loc3_].screenPos.x));
   _loc2_._height = Math.round(Math.abs(univers.array[_loc1_].screenPos.y - univers.array[idH].screenPos.y));
};
MovieClip.prototype.textureAudioIndic = function(id, idW, idH, idC)
{
   var _loc1_ = id;
   var _loc2_ = this;
   var moy = Math.round((univers.array[_loc1_].position.z + univers.array[idC].position.z) / 2);
   _loc2_._x = (univers.array[_loc1_].screenPos.x + univers.array[idW].screenPos.x) / 2;
   _loc2_._y = 0;
   _loc2_._width = Math.round(Math.abs(univers.array[_loc1_].screenPos.x - univers.array[idW].screenPos.x));
};
MovieClip.prototype.deselectAudio = function()
{
   var _loc1_ = _global;
   var _loc2_ = _root;
   _loc2_.multimedia.mcAudio.audio_lecteur.piste.soundVolume(undefined,0,0,30,"easeInOutSine",undefined,function()
   {
      _root.multimedia.mcAudio.audio_lecteur.piste.stop();
   }
   );
   _loc1_.snd_multi_amb_1.start(0,99999999);
   _loc1_.snd_multi_amb_2.start(0,99999999);
   _loc1_.snd_multi_amb_3.start(0,99999999);
   _loc1_.snd_multi_amb_4.start(0,99999999);
   _loc1_.snd_multi_amb_1.soundVolume(undefined,100,0,60,"easeInOutSine");
   _loc1_.snd_multi_amb_2.soundVolume(undefined,100,0,60,"easeInOutSine");
   _loc1_.snd_multi_amb_3.soundVolume(undefined,100,0,60,"easeInOutSine");
   _loc1_.snd_multi_amb_4.soundVolume(undefined,100,0,60,"easeInOutSine",undefined,function()
   {
      _root.sample.soundAmbient_multi();
   }
   );
   audioCloseBoite();
   replaceAudioCube();
};
