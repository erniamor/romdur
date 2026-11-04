function deleteAllBtEvent()
{
   var _loc1_ = _root;
   delete _loc1_.multimedia.cube0.onRollOver;
   delete _loc1_.multimedia.cube0.onRollOut;
   delete _loc1_.multimedia.cube0.onPress;
   delete _loc1_.multimedia.cube1.onRollOver;
   delete _loc1_.multimedia.cube1.onRollOut;
   delete _loc1_.multimedia.cube1.onPress;
   delete _loc1_.multimedia.cube2.onRollOver;
   delete _loc1_.multimedia.cube2.onRollOut;
   delete _loc1_.multimedia.cube2.onPress;
   delete _loc1_.multimedia.cube3.onRollOver;
   delete _loc1_.multimedia.cube3.onRollOut;
   delete _loc1_.multimedia.cube3.onPress;
}
function activeAllBtEvent()
{
   _root.bt_retour.onRelease = function()
   {
      _root.multimedia.multimediaSortie();
   };
   _root.multimedia.cube0.onRollOver = function()
   {
      var _loc1_ = this;
      _global.snd_multi_evt_1.stop();
      _global.snd_multi_evt_1.start();
      var _loc2_ = [_level0.MoteurApi.style[_level0.MoteurApi.apiOn[_loc1_.apiNom].styleId][0],_level0.MoteurApi.style[_level0.MoteurApi.apiOn[_loc1_.apiNom].styleId][1],_level0.MoteurApi.style[_level0.MoteurApi.apiOn[_loc1_.apiNom].styleId][2],_level0.MoteurApi.style[_level0.MoteurApi.apiOn[_loc1_.apiNom].styleId][3],_level0.MoteurApi.style[_level0.MoteurApi.apiOn[_loc1_.apiNom].styleId][4]];
      _root.setApiLocal(_loc1_.apiNom,_loc2_);
      _level0.ApiMouvement(_loc1_.apiNom,4,80,_level0.MoteurApi.style[_level0.MoteurApi.apiOn[_loc1_.apiNom].styleId][4],0,15,"linearTween",false,true);
   };
   _root.multimedia.cube0.onPress = function()
   {
      var idC = this.idCube;
      with(this._parent)
      {
         delete onEnterFrame;
         selectAudio(idC);
         deleteAllBtEvent();
      }
   };
   _root.multimedia.cube3.onRollOver = function()
   {
      var _loc1_ = this;
      _global.snd_multi_evt_4.stop();
      _global.snd_multi_evt_4.start();
      var _loc2_ = [_level0.MoteurApi.style[_level0.MoteurApi.apiOn[_loc1_.apiNom].styleId][0],_level0.MoteurApi.style[_level0.MoteurApi.apiOn[_loc1_.apiNom].styleId][1],_level0.MoteurApi.style[_level0.MoteurApi.apiOn[_loc1_.apiNom].styleId][2],_level0.MoteurApi.style[_level0.MoteurApi.apiOn[_loc1_.apiNom].styleId][3],_level0.MoteurApi.style[_level0.MoteurApi.apiOn[_loc1_.apiNom].styleId][4]];
      _root.setApiLocal(_loc1_.apiNom,_loc2_);
      _level0.ApiMouvement(_loc1_.apiNom,4,80,_level0.MoteurApi.style[_level0.MoteurApi.apiOn[_loc1_.apiNom].styleId][4],0,15,"linearTween",false,true);
   };
   _root.multimedia.cube3.onPress = function()
   {
      var idC = this.idCube;
      with(this._parent)
      {
         selectWeb(idC);
         deleteAllBtEvent();
      }
   };
   _root.multimedia.cube1.onRollOver = function()
   {
      var _loc1_ = this;
      _global.snd_multi_evt_2.stop();
      _global.snd_multi_evt_2.start();
      var _loc2_ = [_level0.MoteurApi.style[_level0.MoteurApi.apiOn[_loc1_.apiNom].styleId][0],_level0.MoteurApi.style[_level0.MoteurApi.apiOn[_loc1_.apiNom].styleId][1],_level0.MoteurApi.style[_level0.MoteurApi.apiOn[_loc1_.apiNom].styleId][2],_level0.MoteurApi.style[_level0.MoteurApi.apiOn[_loc1_.apiNom].styleId][3],_level0.MoteurApi.style[_level0.MoteurApi.apiOn[_loc1_.apiNom].styleId][4]];
      _root.setApiLocal(_loc1_.apiNom,_loc2_);
      _level0.ApiMouvement(_loc1_.apiNom,4,80,_level0.MoteurApi.style[_level0.MoteurApi.apiOn[_loc1_.apiNom].styleId][4],0,15,"linearTween",false,true);
   };
   _root.multimedia.cube2.onRollOver = function()
   {
      var _loc1_ = this;
      _global.snd_multi_evt_3.stop();
      _global.snd_multi_evt_3.start();
      var _loc2_ = [_level0.MoteurApi.style[_level0.MoteurApi.apiOn[_loc1_.apiNom].styleId][0],_level0.MoteurApi.style[_level0.MoteurApi.apiOn[_loc1_.apiNom].styleId][1],_level0.MoteurApi.style[_level0.MoteurApi.apiOn[_loc1_.apiNom].styleId][2],_level0.MoteurApi.style[_level0.MoteurApi.apiOn[_loc1_.apiNom].styleId][3],_level0.MoteurApi.style[_level0.MoteurApi.apiOn[_loc1_.apiNom].styleId][4]];
      _root.setApiLocal(_loc1_.apiNom,_loc2_);
      _level0.ApiMouvement(_loc1_.apiNom,4,80,_level0.MoteurApi.style[_level0.MoteurApi.apiOn[_loc1_.apiNom].styleId][4],0,15,"linearTween",false,true);
   };
   _root.multimedia.cube2.onPress = function()
   {
      var idC = this.idCube;
      with(this._parent)
      {
         delete onEnterFrame;
         selectFlash(idC);
         deleteAllBtEvent();
      }
   };
   _root.multimedia.point32.onRollOver = function()
   {
      _global.snd_multi_evt_point_1.start(0,9999999);
   };
   _root.multimedia.point32.onRollOut = function()
   {
      _global.snd_multi_evt_point_1.stop();
   };
   _root.multimedia.point33.onRollOver = function()
   {
      _global.snd_multi_evt_point_2.start(0,9999999);
   };
   _root.multimedia.point33.onRollOut = function()
   {
      _global.snd_multi_evt_point_2.stop();
   };
}
this.cube = new Array();
this.cube[0] = new cubeItem("I",-159,0,7,0);
this.cube[1] = new cubeItem("II",-53,8,15,1);
this.cube[2] = new cubeItem("III",53,16,23,2);
this.cube[3] = new cubeItem("IV",159,24,31,3);
var i = 0;
while(i <= 3)
{
   this["cube" + i].idCube = i;
   i++;
}
