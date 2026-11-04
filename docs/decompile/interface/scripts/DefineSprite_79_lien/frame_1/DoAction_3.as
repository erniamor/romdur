function activeLienBt()
{
   var _loc2_ = this;
   var _loc3_ = _root;
   _loc3_.bt_retour.onRelease = function()
   {
      _root.lien.sortieLien();
   };
   var _loc1_ = 0;
   while(_loc1_ <= 5)
   {
      _loc3_.lien["cube" + _loc1_].onRollOver = function()
      {
         eventBtLienOver(this.idC,this.idPt);
      };
      _loc3_.lien["cube" + _loc1_].onRollOut = _loc3_.lien["cube" + _loc1_].onReleaseOutside = function()
      {
         eventBtLienOut(this.idC,this.idPt);
      };
      _loc3_.lien["cube" + _loc1_].onRelease = function()
      {
         eventBtLienRelease(this.idC,this.idPt);
      };
      _loc1_ = _loc1_ + 1;
   }
}
function deactiveLienBt()
{
   var _loc2_ = _root;
   delete _loc2_.bt_retour.onRelease;
   var _loc1_ = 0;
   while(_loc1_ <= 5)
   {
      delete _loc2_.lien["cube" + _loc1_].onRollOver;
      delete _loc2_.lien["cube" + _loc1_].onRollOut;
      delete _loc2_.lien["cube" + _loc1_].onRelease;
      delete _loc2_.lien["cube" + _loc1_].onReleaseOutside;
      _loc1_ = _loc1_ + 1;
   }
}
function eventBtLienOver(idC, idPt)
{
   var _loc1_ = idC;
   _global["snd_lien_evt_" + (_loc1_ + 1)].stop();
   _global["snd_lien_evt_" + (_loc1_ + 1)].start();
   _level0.MoteurApi.apiOn["cube" + _loc1_].styleId = _level0.MoteurApi.apiOn["cube" + _loc1_].styleId != 0 ? 0 : 1;
   etireLienCubeY(idPt,0,360,20);
}
function eventBtLienOut(idC, idPt)
{
   _level0.MoteurApi.apiOn["cube" + idC].styleId = _level0.MoteurApi.apiOn["cube" + idC].styleId != 0 ? 0 : 1;
   etireLienCubeY(idPt,0,200,10);
}
function eventBtLienRelease(idC, idPt)
{
   _level0.MoteurApi.apiOn["cube" + idC].styleId = 0;
   _root.lien.mcBtLien["lien_bt_" + idC].setRGB2(51,51,51);
   _global.idLienActuel = idC;
   delete _root.lien.onEnterFrame;
   deactiveLienBt();
   with(_root.lien)
   {
      var rotCourant = univers.array[0].rotation.y < 0 ? (univers.array[0].rotation.y %= 360) + 360 : (univers.array[0].rotation.y %= 360) - 360;
      var s = 0;
      while(s <= univers.array.length)
      {
         univers.array[s].rotation.y = rotCourant;
         RRotation(univers,s,undefined,{x:undefined,y:0},0,20,"easeInOutSine");
         s++;
      }
      var a = 0;
      while(a <= 5)
      {
         if(a != idC)
         {
            etireLienCubeY(a * 8,0,50,20);
         }
         a++;
      }
      retardateur(15,16,function()
      {
         var _loc1_ = 0;
         while(_loc1_ <= 5)
         {
            if(_loc1_ != idC)
            {
               RMouvement(univers,_loc1_ * 8,undefined,[undefined,univers.array[_loc1_ * 8].position.y - 240,undefined],0,20,"easeOutExpo");
               RMouvement(univers,_loc1_ * 8 + 1,undefined,[undefined,univers.array[_loc1_ * 8 + 1].position.y - 240,undefined],0,20,"easeOutExpo");
               RMouvement(univers,_loc1_ * 8 + 2,undefined,[undefined,univers.array[_loc1_ * 8 + 2].position.y - 240,undefined],0,20,"easeOutExpo");
               RMouvement(univers,_loc1_ * 8 + 3,undefined,[undefined,univers.array[_loc1_ * 8 + 3].position.y - 240,undefined],0,20,"easeOutExpo");
               RMouvement(univers,_loc1_ * 8 + 4,undefined,[undefined,univers.array[_loc1_ * 8 + 4].position.y - 240,undefined],0,20,"easeOutExpo");
               RMouvement(univers,_loc1_ * 8 + 5,undefined,[undefined,univers.array[_loc1_ * 8 + 5].position.y - 240,undefined],0,20,"easeOutExpo");
               RMouvement(univers,_loc1_ * 8 + 6,undefined,[undefined,univers.array[_loc1_ * 8 + 6].position.y - 240,undefined],0,20,"easeOutExpo");
               RMouvement(univers,_loc1_ * 8 + 7,undefined,[undefined,univers.array[_loc1_ * 8 + 7].position.y - 240,undefined],0,20,"easeOutExpo");
            }
            _loc1_ = _loc1_ + 1;
         }
      }
      ,function()
      {
         placeLienCube(idPt);
      }
      );
      retardateur(36,37,function()
      {
         activeLienAutreBt();
         _root.lien.mcBtLien["lien_bt_" + idC].Mouvement("_xscale",undefined,0,0,10,"easeInSine",undefined,function()
         {
            _root.lien.mcBtLien["lien_bt_" + idC]._visible = false;
         }
         );
         _root.lien.createEmptyMovieClip("lien_lic",5587899);
         with(_root.lien.lien_lic)
         {
            attachMovie("lien_cadre","lien_cadre",1);
            attachMovie("lien_mc","lien_mc",2);
            lien_mc.setMask(lien_cadre);
            lien_mc.gotoAndStop(2);
            lien_mc.lien_ligne._yscale = 0;
            lien_mc.lien_ligne.Mouvement("_yscale",0,100,10,10,"easeOutSine");
            lien_cadre.Mouvement("_xscale",0,100,10,10,"easeOutSine");
         }
      }
      );
   }
}
function activeLienAutreBt()
{
   var _loc2_ = this;
   var _loc3_ = _root;
   _loc3_.bt_retour.onRelease = function()
   {
      _root.lien.retourLienAccueil();
   };
   var _loc1_ = 0;
   while(_loc1_ <= 5)
   {
      if(_loc1_ != _global.idLienActuel)
      {
         _loc3_.lien["cube" + _loc1_].onRollOver = function()
         {
            eventAutreBtLienOver(this.idC,this.idPt);
         };
         _loc3_.lien["cube" + _loc1_].onRollOut = _loc3_.lien["cube" + _loc1_].onReleaseOutside = function()
         {
            eventAutreBtLienOut(this.idC,this.idPt);
         };
         _loc3_.lien["cube" + _loc1_].onRelease = function()
         {
            eventAutreBtLienRelease(this.idC,this.idPt);
         };
      }
      _loc1_ = _loc1_ + 1;
   }
}
function eventAutreBtLienOver(idC, idPt)
{
   var _loc1_ = idC;
   _global["snd_lien_evt_" + (_loc1_ + 1)].stop();
   _global["snd_lien_evt_" + (_loc1_ + 1)].start();
   _level0.MoteurApi.apiOn["cube" + _loc1_].styleId = _level0.MoteurApi.apiOn["cube" + _loc1_].styleId != 0 ? 0 : 1;
   etireLienCubeZ(idPt,100,20);
}
function eventAutreBtLienOut(idC, idPt)
{
   _level0.MoteurApi.apiOn["cube" + idC].styleId = _level0.MoteurApi.apiOn["cube" + idC].styleId != 0 ? 0 : 1;
   etireLienCubeZ(idPt,10,10);
}
function eventAutreBtLienRelease(idC, idPt)
{
   deactiveLienBt();
   _root.lien.mcBtLien["lien_bt_" + _global.idLienActuel].Mouvement("_xscale",0,100,10,10,"easeInSine",function()
   {
      _root.lien.mcBtLien["lien_bt_" + _global.idLienActuel]._visible = true;
   }
   );
   _root.lien.lien_lic.lien_mc.lien_ligne.Mouvement("_yscale",undefined,0,0,10,"easeOutSine");
   _root.lien.lien_lic.lien_cadre.Mouvement("_xscale",100,0,0,10,"linearTween");
   etireLienCubeZ(idPt,10,10);
   retardateur(11,16,function()
   {
      var _loc3_ = _global;
      var _loc2_ = 0;
      while(_loc2_ <= 7)
      {
         RMouvement(univers,_loc3_.idLienActuel * 8 + _loc2_,undefined,[_root.lien.save_lien[_loc3_.idLienActuel * 8 + _loc2_].x,undefined,undefined],0,20,"easeOutExpo");
         _loc2_ = _loc2_ + 1;
      }
      var _loc1_ = idPt;
      while(_loc1_ <= idPt + 7)
      {
         RMouvement(univers,_loc1_,undefined,[undefined,univers.array[_loc1_].position.y + 240,undefined],0,20,"easeOutExpo");
         _loc1_ = _loc1_ + 1;
      }
   }
   ,function()
   {
      etireLienCubeY(idPt,0,360,20);
      etireLienCubeY(_global.idLienActuel * 8,0,50,20);
   }
   );
   retardateur(50,16,function()
   {
      var _loc2_ = _global;
      placeLienCube(idPt);
      var _loc1_ = 0;
      while(_loc1_ <= 7)
      {
         RMouvement(univers,_loc2_.idLienActuel * 8 + _loc1_,undefined,[undefined,univers.array[_loc2_.idLienActuel * 8 + _loc1_].position.y - 240,undefined],0,20,"easeOutExpo");
         _loc1_ = _loc1_ + 1;
      }
      _loc2_.idLienActuel = idC;
      _root.lien.lien_lic.lien_mc.gotoAndPlay(1);
   }
   ,function()
   {
      activeLienAutreBt();
      _root.lien.mcBtLien["lien_bt_" + idC].Mouvement("_xscale",undefined,0,0,10,"easeInSine",undefined,function()
      {
         _root.lien.mcBtLien["lien_bt_" + idC]._visible = false;
      }
      );
      with(_root.lien.lien_lic)
      {
         lien_mc.lien_ligne._yscale = 0;
         lien_mc.lien_ligne.Mouvement("_yscale",0,100,11,10,"easeOutSine");
         lien_cadre.Mouvement("_xscale",0,100,10,10,"easeOutSine");
      }
   }
   );
}
