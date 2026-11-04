MovieClip.prototype.saveRepere = function(argRepere, argNewName)
{
   var _loc1_ = argRepere;
   var _loc2_ = this;
   var _loc3_ = argNewName;
   _loc2_[_loc3_] = new Array();
   i = 0;
   while(i < _loc1_.array.length)
   {
      _loc2_[_loc3_][i] = new Vector3d(_loc1_.array[i].position.x,_loc1_.array[i].position.y,_loc1_.array[i].position.z);
      i++;
   }
};
