stop();
_level0.createEmptyMovieClip("MoteurMv",-11564);
_level0.MoteurMv.mouvs = new Array();
_level0.MoteurMv.mouvsAttente = new Array();
_level0.MoteurMv.curFrame = -1;
_level0.MoteurMv.onEnterFrame = function()
{
   with(_level0.MoteurMv)
   {
      curFrame++;
      if(mouvsAttente[curFrame])
      {
         for(i in mouvsAttente[curFrame])
         {
            if(mouvsAttente[curFrame][i].cible)
            {
               mouvs[mouvsAttente[curFrame][i].name] = mouvsAttente[curFrame][i];
               mouvs[mouvsAttente[curFrame][i].name].cible.onUnload = function()
               {
                  delete _level0.MoteurMv.mouvs[name];
               };
               mouvsAttente[curFrame][i].onStart(mouvsAttente[curFrame][i].cible);
            }
         }
         delete mouvsAttente[curFrame];
      }
      for(ClipCourant in Mouvs)
      {
         with(mouvs[ClipCourant])
         {
            a++;
            switch(typeAction)
            {
               case "mouvement":
                  cible[prop] = int(Math[typeMouv](a,valeurDep,valeurMouv,duree));
                  break;
               case "Rmouvement":
                  if(validMoteurMvX)
                  {
                     cible.position.x = Math.round(Math[typeMouv](a,valeurDepX,valeurMouvX,duree));
                  }
                  if(validMoteurMvY)
                  {
                     cible.position.y = Math.round(Math[typeMouv](a,valeurDepY,valeurMouvY,duree));
                  }
                  if(validMoteurMvZ)
                  {
                     cible.position.z = Math.round(Math[typeMouv](a,valeurDepZ,valeurMouvZ,duree));
                  }
                  cible.render(persRepere);
                  break;
               case "Rrotation":
                  if(validRotX)
                  {
                     var rotNextX = Math.round(Math[typeMouv](a,valeurDep.x,valeurMouv.x,duree));
                     var rotEffectX = rotNextX - rotCourant.x;
                     rotCourant.x += rotEffectX;
                     cible.rotateObjectX(id,id,rotEffectX);
                  }
                  if(validRotY)
                  {
                     var rotNextY = Math.round(Math[typeMouv](a,valeurDep.y,valeurMouv.y,duree));
                     var rotEffectY = rotNextY - rotCourant.y;
                     rotCourant.y += rotEffectY;
                     cible.rotateObjectY(id,id,rotEffectY);
                  }
                  if(validRotZ)
                  {
                     var rotNextZ = Math.round(Math[typeMouv](a,valeurDep.z,valeurMouv.z,duree));
                     var rotEffectZ = rotNextZ - rotCourant.z;
                     rotCourant.z += rotEffectZ;
                     cible.rotateObjectZ(id,id,rotEffectZ);
                  }
                  break;
               case "RrotationRelative":
                  if(validRotX)
                  {
                     var rotNextX = Math.round(Math[typeMouv](a,valeurDep.x,valeurMouv.x,duree));
                     var rotEffectX = rotNextX - rotCourant.x;
                     rotCourant.x += rotEffectX;
                     cible.relativeRotatePointX(id,idControl,rotEffectX);
                  }
                  if(validRotY)
                  {
                     var rotNextY = Math.round(Math[typeMouv](a,valeurDep.y,valeurMouv.y,duree));
                     var rotEffectY = rotNextY - rotCourant.y;
                     rotCourant.y += rotEffectY;
                     cible.relativeRotatePointY(id,idControl,rotEffectY);
                  }
                  if(validRotZ)
                  {
                     var rotNextZ = Math.round(Math[typeMouv](a,valeurDep.z,valeurMouv.z,duree));
                     var rotEffectZ = rotNextZ - rotCourant.z;
                     rotCourant.z += rotEffectZ;
                     cible.relativeRotatePointZ(id,idControl,rotEffectZ);
                  }
                  break;
               case "RscaleRelative":
                  cible.relativeScaleObject(id,id,v,k);
                  cible.render(persRepere);
                  break;
               case "volume":
                  var newVol = Math.round(Math[typeMouv](a,valeurDep,valeurMouv,duree));
                  cible.setVolume(newVol);
                  break;
               case "pan":
                  var newPan = Math.round(Math[typeMouv](a,valeurDep,valeurMouv,duree));
                  cible.setPan(newPan);
                  break;
               case "apiMouv":
                  cible[prop] = int(Math[typeMouv](a,valeurDep,valeurMouv,duree));
                  break;
               case "retardateur":
            }
            if(a == duree)
            {
               onStop(cible);
               delete mouvs[ClipCourant];
            }
         }
      }
   }
};
MovieClip.prototype.mouvement = function(argProp, argValDep, argValDest, argDelai, argDuree, argTypeMouv, argOnstart, argOnStop)
{
   var _loc2_ = this;
   var _loc3_ = argProp;
   var _loc1_ = new Object();
   _loc1_.a = 0;
   _loc1_.typeAction = "mouvement";
   _loc1_.cible = _loc2_;
   _loc1_.prop = _loc3_;
   if(argValDep != undefined)
   {
      _loc1_.valeurDep = argValDep;
      _loc2_[_loc3_] = argValDep;
   }
   else
   {
      _loc1_.valeurDep = _loc2_[_loc3_];
   }
   _loc1_.valeurMouv = argValDest - _loc1_.valeurDep;
   _loc1_.topDepart = _level0.MoteurMv.curFrame + argDelai;
   _loc1_.duree = argDuree;
   _loc1_.typeMouv = argTypeMouv;
   _loc1_.onStart = argOnstart;
   _loc1_.onStop = argOnStop;
   _loc1_.name = _loc2_ + "." + _loc3_;
   if(argDelai > 0)
   {
      if(_level0.MoteurMv.mouvsAttente[_loc1_.topDepart] == null)
      {
         _level0.MoteurMv.mouvsAttente[_loc1_.topDepart] = new Array();
      }
      _level0.MoteurMv.mouvsAttente[_loc1_.topDepart].push(_loc1_);
   }
   else
   {
      _level0.MoteurMv.mouvs[_loc1_.name] = _loc1_;
   }
};
MovieClip.prototype.RMouvement = function(argRepere, argId, argValDep, argValDest, argDelai, argDuree, argTypeMouv, argOnstart, argOnStop)
{
   var _loc2_ = argValDest;
   var _loc3_ = argValDep;
   var _loc1_ = new Object();
   _loc1_.a = 0;
   _loc1_.typeAction = "Rmouvement";
   _loc1_.repere = argRepere;
   _loc1_.persRepere = this.univers.pers;
   _loc1_.cible = this.univers.array[argId];
   if(_loc3_ == undefined)
   {
      _loc1_.valeurDepX = Math.round(_loc1_.cible.position.x);
      _loc1_.valeurDepY = Math.round(_loc1_.cible.position.y);
      _loc1_.valeurDepZ = Math.round(_loc1_.cible.position.z);
   }
   else
   {
      _loc1_.valeurDepX = _loc3_[0];
      _loc1_.valeurDepY = _loc3_[1];
      _loc1_.valeurDepZ = _loc3_[2];
   }
   _loc1_.validMoteurMvX = _loc2_[0] != undefined ? true : false;
   _loc1_.validMoteurMvY = _loc2_[1] != undefined ? true : false;
   _loc1_.validMoteurMvZ = _loc2_[2] != undefined ? true : false;
   _loc1_.valeurMouvX = _loc2_[0] - _loc1_.valeurDepX;
   _loc1_.valeurMouvY = _loc2_[1] - _loc1_.valeurDepY;
   _loc1_.valeurMouvZ = _loc2_[2] - _loc1_.valeurDepZ;
   _loc1_.topDepart = _level0.MoteurMv.curFrame + argDelai;
   _loc1_.duree = argDuree;
   _loc1_.typeMouv = argTypeMouv;
   _loc1_.onStart = argOnstart;
   _loc1_.onStop = argOnStop;
   _loc1_.name = this + "." + argProp + "." + argId + "_Rmouv";
   if(argDelai > 0)
   {
      if(_level0.MoteurMv.mouvsAttente[_loc1_.topDepart] == null)
      {
         _level0.MoteurMv.mouvsAttente[_loc1_.topDepart] = new Array();
      }
      _level0.MoteurMv.mouvsAttente[_loc1_.topDepart].push(_loc1_);
   }
   else
   {
      _level0.MoteurMv.mouvs[_loc1_.name] = _loc1_;
   }
};
MovieClip.prototype.RRotation = function(argRepere, argId, argValDep, argValDest, argDelai, argDuree, argTypeMouv, argOnstart, argOnStop)
{
   var _loc2_ = argValDest;
   var _loc3_ = argValDep;
   var _loc1_ = new Object();
   _loc1_.a = 0;
   _loc1_.typeAction = "Rrotation";
   _loc1_.id = argId;
   _loc1_.cible = this.univers;
   if(_loc3_ == undefined)
   {
      _loc1_.valeurDep = _loc1_.cible.array[argId].rotation.getClone();
   }
   else
   {
      _loc1_.valeurDep = new Vector3d(_loc3_.x,_loc3_.y,_loc3_.z);
   }
   _loc1_.rotCourant = _loc1_.valeurDep.getClone();
   _loc1_.valeurMouv = new Vector3d();
   if(_loc2_.x == undefined)
   {
      _loc1_.validRotX = false;
   }
   else
   {
      _loc1_.validRotX = true;
      _loc1_.valeurMouv.x = _loc2_.x - _loc1_.valeurDep.x;
   }
   if(_loc2_.y == undefined)
   {
      _loc1_.validRotY = false;
   }
   else
   {
      _loc1_.validRotY = true;
      _loc1_.valeurMouv.y = _loc2_.y - _loc1_.valeurDep.y;
   }
   if(_loc2_.z == undefined)
   {
      _loc1_.validRotZ = false;
   }
   else
   {
      _loc1_.validRotZ = true;
      _loc1_.valeurMouv.z = _loc2_.z - _loc1_.valeurDep.z;
   }
   _loc1_.topDepart = _level0.MoteurMv.curFrame + argDelai;
   _loc1_.duree = argDuree;
   _loc1_.typeMouv = argTypeMouv;
   _loc1_.onStart = argOnstart;
   _loc1_.onStop = argOnStop;
   _loc1_.name = this + "." + argId + "_rot";
   if(argDelai > 0)
   {
      if(_level0.MoteurMv.mouvsAttente[_loc1_.topDepart] == null)
      {
         _level0.MoteurMv.mouvsAttente[_loc1_.topDepart] = new Array();
      }
      _level0.MoteurMv.mouvsAttente[_loc1_.topDepart].push(_loc1_);
   }
   else
   {
      _level0.MoteurMv.mouvs[_loc1_.name] = _loc1_;
   }
};
MovieClip.prototype.RRotationRelative = function(argRepere, argId, argIdControl, argValDep, argValDest, argDelai, argDuree, argTypeMouv, argOnstart, argOnStop)
{
   var _loc2_ = argValDest;
   var _loc3_ = argValDep;
   var _loc1_ = new Object();
   _loc1_.a = 0;
   _loc1_.typeAction = "RrotationRelative";
   _loc1_.id = argId;
   _loc1_.idControl = argIdControl;
   _loc1_.cible = this.univers;
   if(_loc3_ == undefined)
   {
      _loc1_.valeurDep = _loc1_.cible.array[argId].rotation.getClone();
   }
   else
   {
      _loc1_.valeurDep = new Vector3d(_loc3_.x,_loc3_.y,_loc3_.z);
   }
   _loc1_.rotCourant = _loc1_.valeurDep.getClone();
   _loc1_.valeurMouv = new Vector3d();
   if(_loc2_.x == undefined)
   {
      _loc1_.validRotX = false;
   }
   else
   {
      _loc1_.validRotX = true;
      _loc1_.valeurMouv.x = _loc2_.x - _loc1_.valeurDep.x;
   }
   if(_loc2_.y == undefined)
   {
      _loc1_.validRotY = false;
   }
   else
   {
      _loc1_.validRotY = true;
      _loc1_.valeurMouv.y = _loc2_.y - _loc1_.valeurDep.y;
   }
   if(_loc2_.z == undefined)
   {
      _loc1_.validRotZ = false;
   }
   else
   {
      _loc1_.validRotZ = true;
      _loc1_.valeurMouv.z = _loc2_.z - _loc1_.valeurDep.z;
   }
   _loc1_.topDepart = _level0.MoteurMv.curFrame + argDelai;
   _loc1_.duree = argDuree;
   _loc1_.typeMouv = argTypeMouv;
   _loc1_.onStart = argOnstart;
   _loc1_.onStop = argOnStop;
   _loc1_.name = this + "." + argId + "_rotRel";
   if(argDelai > 0)
   {
      if(_level0.MoteurMv.mouvsAttente[_loc1_.topDepart] == null)
      {
         _level0.MoteurMv.mouvsAttente[_loc1_.topDepart] = new Array();
      }
      _level0.MoteurMv.mouvsAttente[_loc1_.topDepart].push(_loc1_);
   }
   else
   {
      _level0.MoteurMv.mouvs[_loc1_.name] = _loc1_;
   }
};
MovieClip.prototype.retardateur = function(argDelai, argDuree, argOnstart, argOnStop)
{
   var _loc1_ = new Object();
   _loc1_.a = 0;
   _loc1_.typeAction = "retardateur";
   _loc1_.cible = this;
   _loc1_.topDepart = _level0.MoteurMv.curFrame + argDelai;
   _loc1_.duree = argDuree;
   _loc1_.onStart = argOnstart;
   _loc1_.onStop = argOnStop;
   _loc1_.name = this + "." + random(100000) + "-" + random(100000) + "-" + random(100000);
   if(argDelai > 0)
   {
      if(_level0.MoteurMv.mouvsAttente[_loc1_.topDepart] == null)
      {
         _level0.MoteurMv.mouvsAttente[_loc1_.topDepart] = new Array();
      }
      _level0.MoteurMv.mouvsAttente[_loc1_.topDepart].push(_loc1_);
   }
   else
   {
      _level0.MoteurMv.mouvs[_loc1_.name] = _loc1_;
   }
};
MovieClip.prototype.RScaleRelative = function(argRepere, argId, argV, argK, argDelai, argDuree, argTypeMouv, argOnstart, argOnStop)
{
   var _loc2_ = this;
   var _loc1_ = new Object();
   _loc1_.a = 0;
   _loc1_.typeAction = "RscaleRelative";
   _loc1_.repere = argRepere;
   _loc1_.persRepere = _loc2_.univers.pers;
   _loc1_.cible = _loc2_.univers.array[argId];
   _loc1_.v = argV;
   _loc1_.k = argK;
   _loc1_.topDepart = _level0.MoteurMv.curFrame + argDelai;
   _loc1_.duree = argDuree;
   _loc1_.typeMouv = argTypeMouv;
   _loc1_.onStart = argOnstart;
   _loc1_.onStop = argOnStop;
   _loc1_.name = _loc2_ + "." + argProp + "." + argId + "_RscaleRelative";
   if(argDelai > 0)
   {
      if(_level0.MoteurMv.mouvsAttente[_loc1_.topDepart] == null)
      {
         _level0.MoteurMv.mouvsAttente[_loc1_.topDepart] = new Array();
      }
      _level0.MoteurMv.mouvsAttente[_loc1_.topDepart].push(_loc1_);
   }
   else
   {
      _level0.MoteurMv.mouvs[_loc1_.name] = _loc1_;
   }
};
Sound.prototype.soundVolume = function(vInit, vEnd, argDelai, argDuree, argTypeMouv, argOnstart, argOnStop)
{
   var _loc2_ = vInit;
   var _loc3_ = this;
   var _loc1_ = new Object();
   _loc1_.a = 0;
   _loc1_.typeAction = "volume";
   _loc1_.cible = _loc3_;
   if(_loc2_ != undefined)
   {
      _loc1_.valeurDep = _loc2_;
      _loc3_.setVolume(_loc2_);
   }
   else
   {
      _loc1_.valeurDep = _loc3_.getVolume();
   }
   _loc1_.valeurMouv = vEnd - _loc1_.valeurDep;
   _loc1_.topDepart = _level0.MoteurMv.curFrame + argDelai;
   _loc1_.duree = argDuree;
   _loc1_.typeMouv = argTypeMouv;
   _loc1_.onStart = argOnstart;
   _loc1_.onStop = argOnStop;
   _loc1_.name = "sound_volume" + random(9999999) + "|" + random(9999999);
   if(argDelai > 0)
   {
      if(_level0.MoteurMv.mouvsAttente[_loc1_.topDepart] == null)
      {
         _level0.MoteurMv.mouvsAttente[_loc1_.topDepart] = new Array();
      }
      _level0.MoteurMv.mouvsAttente[_loc1_.topDepart].push(_loc1_);
   }
   else
   {
      _level0.MoteurMv.mouvs[_loc1_.name] = _loc1_;
   }
};
Sound.prototype.soundPan = function(vInit, vEnd, argDelai, argDuree, argTypeMouv, argOnstart, argOnStop)
{
   var _loc2_ = vInit;
   var _loc3_ = this;
   var _loc1_ = new Object();
   _loc1_.a = 0;
   _loc1_.typeAction = "pan";
   _loc1_.cible = _loc3_;
   if(_loc2_ != undefined)
   {
      _loc1_.valeurDep = _loc2_;
      _loc3_.setPan(_loc2_);
   }
   else
   {
      _loc1_.valeurDep = _loc3_.getPan();
   }
   _loc1_.valeurMouv = vEnd - _loc1_.valeurDep;
   _loc1_.topDepart = _level0.MoteurMv.curFrame + argDelai;
   _loc1_.duree = argDuree;
   _loc1_.typeMouv = argTypeMouv;
   _loc1_.onStart = argOnstart;
   _loc1_.onStop = argOnStop;
   _loc1_.name = "sound_pan" + random(9999999) + "|" + random(9999999);
   if(argDelai > 0)
   {
      if(_level0.MoteurMv.mouvsAttente[_loc1_.topDepart] == null)
      {
         _level0.MoteurMv.mouvsAttente[_loc1_.topDepart] = new Array();
      }
      _level0.MoteurMv.mouvsAttente[_loc1_.topDepart].push(_loc1_);
   }
   else
   {
      _level0.MoteurMv.mouvs[_loc1_.name] = _loc1_;
   }
};
MovieClip.prototype.ApiMouvement = function(nomObj, argProp, argValDep, argValDest, argDelai, argDuree, argTypeMouv, isGlobalAtBegin, isGlobalAtEnd)
{
   var _loc2_ = this;
   var _loc3_ = argProp;
   var _loc1_ = new Object();
   _loc1_.a = 0;
   _loc1_.nomObj = nomObj;
   _loc1_.typeAction = "mouvement";
   _loc1_.cible = _level0.MoteurApi.apiOn[nomObj].styleLocal;
   _loc1_.prop = _loc3_;
   _loc1_.valeurDep = argValDep;
   _level0.MoteurApi.apiOn[nomObj].styleLocal[_loc3_] = argValDep;
   _loc1_.valeurMouv = argValDest - _loc1_.valeurDep;
   _loc1_.topDepart = _level0.MoteurMv.curFrame + argDelai;
   _loc1_.duree = argDuree;
   _loc1_.typeMouv = argTypeMouv;
   _loc1_.onStart = argOnstart;
   if(isGlobalAtBegin == true)
   {
      _loc1_.onStart = function()
      {
         setApiLocal(this.nomObj,_level0.style[this.styleId]);
      };
   }
   else
   {
      _loc1_.onStart = undefined;
   }
   if(isGlobalAtEnd == true)
   {
      _loc1_.onStop = function()
      {
         setApiGlobal(this.nomObj);
      };
   }
   else
   {
      _loc1_.onStop = undefined;
   }
   _loc1_.name = "mvtApi" + nomObj + "." + _loc3_;
   if(argDelai > 0)
   {
      if(_level0.MoteurMv.mouvsAttente[_loc1_.topDepart] == null)
      {
         _level0.MoteurMv.mouvsAttente[_loc1_.topDepart] = new Array();
      }
      _level0.MoteurMv.mouvsAttente[_loc1_.topDepart].push(_loc1_);
   }
   else
   {
      _level0.MoteurMv.mouvs[_loc1_.name] = _loc1_;
   }
};
