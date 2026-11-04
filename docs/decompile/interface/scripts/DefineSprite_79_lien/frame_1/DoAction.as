function etireLienCubeY(i, posYObject, taille, temps)
{
   var _loc3_ = taille / 2;
   var _loc1_ = temps;
   var _loc2_ = "easeOutExpo";
   RMouvement(univers,i,undefined,[undefined,posYObject + _loc3_,undefined],0,_loc1_,_loc2_);
   RMouvement(univers,i + 1,undefined,[undefined,posYObject + _loc3_,undefined],0,_loc1_,_loc2_);
   RMouvement(univers,i + 4,undefined,[undefined,posYObject + _loc3_,undefined],0,_loc1_,_loc2_);
   RMouvement(univers,i + 5,undefined,[undefined,posYObject + _loc3_,undefined],0,_loc1_,_loc2_);
   RMouvement(univers,i + 2,undefined,[undefined,posYObject - _loc3_,undefined],0,_loc1_,_loc2_);
   RMouvement(univers,i + 3,undefined,[undefined,posYObject - _loc3_,undefined],0,_loc1_,_loc2_);
   RMouvement(univers,i + 6,undefined,[undefined,posYObject - _loc3_,undefined],0,_loc1_,_loc2_);
   RMouvement(univers,i + 7,undefined,[undefined,posYObject - _loc3_,undefined],0,_loc1_,_loc2_);
}
function etireLienCubeZ(i, taille, temps)
{
   var _loc3_ = taille / 2;
   var _loc1_ = temps;
   var _loc2_ = "easeOutExpo";
   RMouvement(univers,i,undefined,[undefined,undefined,_loc3_],0,_loc1_,_loc2_);
   RMouvement(univers,i + 1,undefined,[undefined,undefined,_loc3_],0,_loc1_,_loc2_);
   RMouvement(univers,i + 2,undefined,[undefined,undefined,_loc3_],0,_loc1_,_loc2_);
   RMouvement(univers,i + 3,undefined,[undefined,undefined,_loc3_],0,_loc1_,_loc2_);
   RMouvement(univers,i + 4,undefined,[undefined,undefined,- _loc3_],0,_loc1_,_loc2_);
   RMouvement(univers,i + 5,undefined,[undefined,undefined,- _loc3_],0,_loc1_,_loc2_);
   RMouvement(univers,i + 6,undefined,[undefined,undefined,- _loc3_],0,_loc1_,_loc2_);
   RMouvement(univers,i + 7,undefined,[undefined,undefined,- _loc3_],0,_loc1_,_loc2_);
}
function placeLienCube(i)
{
   var _loc3_ = i;
   var h = taille / 2;
   var _loc1_ = 10;
   var _loc2_ = "easeOutExpo";
   RMouvement(univers,_loc3_,undefined,[-300,undefined,undefined],0,_loc1_,_loc2_);
   RMouvement(univers,_loc3_ + 3,undefined,[-300,undefined,undefined],0,_loc1_,_loc2_);
   RMouvement(univers,_loc3_ + 4,undefined,[-300,undefined,undefined],0,_loc1_,_loc2_);
   RMouvement(univers,_loc3_ + 7,undefined,[-300,undefined,undefined],0,_loc1_,_loc2_);
   RMouvement(univers,_loc3_ + 1,undefined,[300,undefined,undefined],0,_loc1_,_loc2_);
   RMouvement(univers,_loc3_ + 2,undefined,[300,undefined,undefined],0,_loc1_,_loc2_);
   RMouvement(univers,_loc3_ + 6,undefined,[300,undefined,undefined],0,_loc1_,_loc2_);
   RMouvement(univers,_loc3_ + 5,undefined,[300,undefined,undefined],0,_loc1_,_loc2_);
}
function affichBtLien()
{
   var _loc1_ = _root;
   _loc1_.lien.createEmptyMovieClip("mcBtLien",558778);
   _loc1_.lien.mcBtLien.univers = univers;
   _loc1_.lien.mcBtLien.attachMovie("lien_bt_audio","lien_bt_0",10);
   _loc1_.lien.mcBtLien.attachMovie("lien_bt_video","lien_bt_1",11);
   _loc1_.lien.mcBtLien.attachMovie("lien_bt_web","lien_bt_2",12);
   _loc1_.lien.mcBtLien.attachMovie("lien_bt_lieu","lien_bt_3",13);
   _loc1_.lien.mcBtLien.attachMovie("lien_bt_savoir","lien_bt_4",14);
   _loc1_.lien.mcBtLien.attachMovie("lien_bt_miscellanee","lien_bt_5",15);
   _loc1_.lien.mcBtLien.attachMcLien();
   _loc1_.lien.mcBtLien.onEnterFrame = function()
   {
      this.attachBtLien();
   };
}
function retourLienAccueil()
{
   var _loc3_ = _global;
   deactiveLienBt();
   _root.lien.lien_lic.lien_mc.lien_ligne.Mouvement("_yscale",undefined,0,0,10,"easeOutSine");
   _root.lien.lien_lic.lien_cadre.Mouvement("_xscale",100,0,0,10,"linearTween");
   _root.lien.mcBtLien["lien_bt_" + _loc3_.idLienActuel].Mouvement("_xscale",0,100,10,10,"easeInSine",function()
   {
      _root.lien.mcBtLien["lien_bt_" + _global.idLienActuel]._visible = true;
   }
   );
   retardateur(12,16,function()
   {
      var _loc2_ = _global;
      var _loc3_ = _root;
      _loc3_.lien.lien_lic.unloadMovie();
      var _loc1_ = 0;
      while(_loc1_ < univers.array.length)
      {
         if(_loc1_ >= _loc2_.idLienActuel * 8 && _loc1_ <= _loc2_.idLienActuel * 8 + 7)
         {
            RMouvement(univers,_loc1_,undefined,[_loc3_.lien.save_lien[_loc1_].x,undefined,undefined],0,20,"easeOutExpo");
         }
         else
         {
            RMouvement(univers,_loc1_,undefined,[undefined,univers.array[_loc1_].position.y + 240,undefined],0,20,"easeOutExpo");
         }
         _loc1_ = _loc1_ + 1;
      }
   }
   ,function()
   {
      var _loc1_ = 0;
      while(_loc1_ <= 5)
      {
         etireLienCubeY(_loc1_ * 8,0,200,20);
         _loc1_ = _loc1_ + 1;
      }
   }
   );
   retardateur(50,16,function()
   {
      _root.lien.activeLienBt();
      _global.idLienActuel = -1;
      _root.lien.startLienEnterFrame();
   }
   );
}
function introLien()
{
   _global.snd_lien_pos_1.start(0,99999999);
   _global.snd_lien_pos_1.setVolume(0);
   _global.snd_lien_pos_1.setPan(-100);
   _global.snd_lien_pos_1.soundVolume(0,55,0,50,"easeInOutSine");
   _global.snd_lien_pos_2.start(0,99999999);
   _global.snd_lien_pos_2.setVolume(0);
   _global.snd_lien_pos_2.setPan(100);
   _global.snd_lien_pos_2.soundVolume(0,55,0,50,"easeInOutSine");
   _global.snd_lien_rot_1.start(0,99999999);
   _global.snd_lien_rot_1.setVolume(0);
   _global.snd_lien_rot_2.soundVolume(0,30,0,30,"easeInOutSine");
   _global.snd_lien_rot_2.start(0,99999999);
   _global.snd_lien_rot_2.setVolume(0);
   _global.snd_lien_rot_2.soundVolume(0,30,0,30,"easeInOutSine");
   var o = 0;
   while(o <= 5)
   {
      var angle = random(20) - 10;
      var nbTours = (random(2) + 1) * 360 - 90;
      univers.rotateObjectX(o * 8,o * 8 + 7,angle - nbTours);
      o++;
   }
   var p = 0;
   while(p < univers.array.length / 2)
   {
      univers.array[p].position.x -= 600;
      univers.array[p].render(univers.pers);
      p++;
   }
   var q = univers.array.length / 2;
   while(q < univers.array.length)
   {
      univers.array[q].position.x += 600;
      univers.array[q].render(univers.pers);
      q++;
   }
   var delai = 20;
   var sens = 0;
   affichBtLien();
   var _loc2_ = 0;
   var _loc1_;
   while(_loc2_ <= 5)
   {
      _root.lien.mcBtLien["lien_bt_" + _loc2_]._alpha = 0;
      _root.apiActiveEtat("cube" + _loc2_);
      _loc1_ = 0;
      while(_loc1_ <= 7)
      {
         RMouvement(univers,_loc2_ * 8 + _loc1_,undefined,[_root.lien.save_lien[_loc2_ * 8 + _loc1_].x,undefined,undefined],delai + 1,20,"easeOutExpo");
         _loc1_ = _loc1_ + 1;
      }
      if(delai != 0 || sens == 1)
      {
         delai = sens != 0 ? delai + 10 : delai - 10;
      }
      else
      {
         sens = 1;
      }
      _loc2_ = _loc2_ + 1;
   }
   retardateur(22,41,function()
   {
      var _loc2_ = 0;
      var _loc3_;
      var _loc1_;
      while(_loc2_ <= 5)
      {
         _loc3_ = (random(4) + 1) * 10;
         _loc1_ = 0;
         while(_loc1_ <= 7)
         {
            RRotation(univers,_loc2_ * 8 + _loc1_,undefined,{x:0,y:undefined,z:undefined},0,_loc3_,"easeInOutCubic");
            _loc1_ = _loc1_ + 1;
         }
         _root.lien.mcBtLien["lien_bt_" + _loc2_].Mouvement("_alpha",0,100,_loc3_ / 2,30,"easeInSine");
         _loc2_ = _loc2_ + 1;
      }
   }
   ,function()
   {
      _root.sample.soundAmbient_lien();
      startLienEnterFrame();
      activeLienBt();
   }
   );
}
function sortieLien()
{
   delete _root.sample.onEnterFrame;
   _global.snd_lien_pos_1.soundVolume(undefined,0,0,60,"easeInOutSine");
   _global.snd_lien_pos_2.soundVolume(undefined,0,0,60,"easeInOutSine");
   _global.snd_lien_rot_2.soundVolume(undefined,0,0,60,"easeInOutSine");
   _global.snd_lien_rot_2.soundVolume(undefined,0,0,60,"easeInOutSine");
   _global.idLienActuel = -1;
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
      retardateur(21,20,function()
      {
         var posCtrl = -275;
         var _loc3_ = 0;
         var _loc2_ = 0;
         var _loc1_;
         while(_loc2_ <= 5)
         {
            _loc1_ = 0;
            while(_loc1_ <= 7)
            {
               RRotationRelative(univers,_loc2_ * 8 + _loc1_,{x:posCtrl,y:0,z:0},{x:undefined,y:0},{x:undefined,y:-90},_loc3_,10,"easeOutExpo");
               RRotation(univers,_loc2_ * 8 + _loc1_,{x:0},{x:-90},_loc3_ + 10,10,"easeOutExpo");
               _loc1_ = _loc1_ + 1;
            }
            _loc3_ += 1;
            posCtrl += 110;
            _loc2_ = _loc2_ + 1;
         }
      }
      ,function()
      {
         var _loc3_ = 0;
         var _loc2_ = 0;
         var _loc1_;
         while(_loc2_ <= 5)
         {
            _loc1_ = 0;
            while(_loc1_ <= 7)
            {
               RMouvement(univers,_loc2_ * 8 + _loc1_,undefined,[undefined,undefined,-500],_loc3_,20,"easeOutExpo");
               _loc1_ = _loc1_ + 1;
            }
            _loc3_ += 1;
            _loc2_ = _loc2_ + 1;
         }
      }
      );
      retardateur(65,2,function()
      {
         var _loc1_ = _global;
         for(api in _level0.MoteurApi.apiOn)
         {
            delete _level0.MoteurApi.apiOn[api];
         }
         _loc1_.snd_lien_rot_2.stop();
         _loc1_.snd_lien_rot_1.stop();
         _loc1_.snd_lien_pos_2.stop();
         _loc1_.snd_lien_pos_1.stop();
         _root.lien.removeMovieClip();
         _root.attachMovie("E","E",10);
      }
      );
   }
}
MovieClip.prototype.startLienEnterFrame = function()
{
   this.onEnterFrame = function()
   {
      var _loc1_ = _xmouse / 100;
      univers.rotateY(_loc1_);
   };
};
MovieClip.prototype.attachBtLien = function()
{
   var _loc1_ = this;
   var drx = (univers.array[5].screenPos.x - univers.array[4].screenPos.x + (univers.array[6].screenPos.x - univers.array[7].screenPos.x)) / 2;
   var dry = (univers.array[4].screenPos.y - univers.array[7].screenPos.y + (univers.array[5].screenPos.y - univers.array[6].screenPos.y)) / 2;
   _loc1_.lien_bt_0._x = (univers.array[5].screenPos.x + univers.array[4].screenPos.x) / 2;
   _loc1_.lien_bt_0._y = - (univers.array[4].screenPos.y + univers.array[7].screenPos.y) / 2;
   _loc1_.lien_bt_0._width = Math.abs(drx);
   _loc1_.lien_bt_0._height = Math.abs(dry);
   var dcx = (univers.array[13].screenPos.x - univers.array[12].screenPos.x + (univers.array[14].screenPos.x - univers.array[15].screenPos.x)) / 2;
   var dcy = (univers.array[12].screenPos.y - univers.array[15].screenPos.y + (univers.array[13].screenPos.y - univers.array[14].screenPos.y)) / 2;
   _loc1_.lien_bt_1._x = (univers.array[13].screenPos.x + univers.array[12].screenPos.x) / 2;
   _loc1_.lien_bt_1._y = - (univers.array[12].screenPos.y + univers.array[15].screenPos.y) / 2;
   _loc1_.lien_bt_1._width = Math.abs(dcx);
   _loc1_.lien_bt_1._height = Math.abs(dcy);
   var _loc2_ = (univers.array[21].screenPos.x - univers.array[20].screenPos.x + (univers.array[22].screenPos.x - univers.array[23].screenPos.x)) / 2;
   var dqy = (univers.array[20].screenPos.y - univers.array[23].screenPos.y + (univers.array[21].screenPos.y - univers.array[22].screenPos.y)) / 2;
   _loc1_.lien_bt_2._x = (univers.array[21].screenPos.x + univers.array[20].screenPos.x) / 2;
   _loc1_.lien_bt_2._y = - (univers.array[20].screenPos.y + univers.array[23].screenPos.y) / 2;
   _loc1_.lien_bt_2._width = Math.abs(_loc2_);
   _loc1_.lien_bt_2._height = Math.abs(dqy);
   var dlx = (univers.array[29].screenPos.x - univers.array[28].screenPos.x + (univers.array[30].screenPos.x - univers.array[31].screenPos.x)) / 2;
   var dly = (univers.array[28].screenPos.y - univers.array[31].screenPos.y + (univers.array[29].screenPos.y - univers.array[30].screenPos.y)) / 2;
   _loc1_.lien_bt_3._x = (univers.array[29].screenPos.x + univers.array[28].screenPos.x) / 2;
   _loc1_.lien_bt_3._y = - (univers.array[28].screenPos.y + univers.array[31].screenPos.y) / 2;
   _loc1_.lien_bt_3._width = Math.abs(dlx);
   _loc1_.lien_bt_3._height = Math.abs(dly);
   var dfx = (univers.array[37].screenPos.x - univers.array[36].screenPos.x + (univers.array[38].screenPos.x - univers.array[39].screenPos.x)) / 2;
   var dfy = (univers.array[36].screenPos.y - univers.array[39].screenPos.y + (univers.array[37].screenPos.y - univers.array[38].screenPos.y)) / 2;
   _loc1_.lien_bt_4._x = (univers.array[37].screenPos.x + univers.array[36].screenPos.x) / 2;
   _loc1_.lien_bt_4._y = - (univers.array[36].screenPos.y + univers.array[39].screenPos.y) / 2;
   _loc1_.lien_bt_4._width = Math.abs(dfx);
   _loc1_.lien_bt_4._height = Math.abs(dfy);
   var dmx = (univers.array[45].screenPos.x - univers.array[44].screenPos.x + (univers.array[46].screenPos.x - univers.array[47].screenPos.x)) / 2;
   var _loc3_ = (univers.array[44].screenPos.y - univers.array[47].screenPos.y + (univers.array[45].screenPos.y - univers.array[46].screenPos.y)) / 2;
   _loc1_.lien_bt_5._x = (univers.array[45].screenPos.x + univers.array[44].screenPos.x) / 2;
   _loc1_.lien_bt_5._y = - (univers.array[44].screenPos.y + univers.array[47].screenPos.y) / 2;
   _loc1_.lien_bt_5._width = Math.abs(dmx);
   _loc1_.lien_bt_5._height = Math.abs(_loc3_);
};
