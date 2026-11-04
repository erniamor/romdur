stop();
_global.Repere3d = function(perspective)
{
   var _loc1_ = this;
   _loc1_.array = new Array();
   _loc1_.idObjet = new Array();
   _loc1_.pers = perspective;
};
RP = Repere3d.prototype;
RP.render = function(perspective)
{
   var _loc3_ = this;
   var _loc2_ = perspective != undefined ? perspective : _loc3_.pers;
   var _loc1_ = _loc3_.array.length;
   while(_loc1_--)
   {
      _loc3_.array[_loc1_].render(_loc2_);
   }
};
RP.rotateX = function(angle)
{
   var p = this.pers;
   with(Math)
   {
      var ca = cosD(angle);
      var sa = sinD(angle);
   }
   var i = this.array.length;
   while(i--)
   {
      this.array[i].position.rotateXTrig(ca,sa);
      this.array[i].render(p);
      this.array[i].rotation.x += angle;
   }
};
RP.rotateY = function(angle)
{
   var p = this.pers;
   with(Math)
   {
      var ca = cosD(angle);
      var sa = sinD(angle);
   }
   var i = this.array.length;
   while(i--)
   {
      this.array[i].position.rotateYTrig(ca,sa);
      this.array[i].render(p);
      this.array[i].rotation.y += angle;
   }
};
RP.rotateZ = function(angle)
{
   var p = this.pers;
   with(Math)
   {
      var ca = cosD(angle);
      var sa = sinD(angle);
   }
   var i = this.array.length;
   while(i--)
   {
      this.array[i].position.rotateZTrig(ca,sa);
      this.array[i].render(p);
      this.array[i].rotation.z += angle;
   }
};
RP.rotateXY = function(a, b)
{
   var p = this.pers;
   with(Math)
   {
      var ca = cosD(a);
      var sa = sinD(a);
      var cb = cosD(b);
      var sb = sinD(b);
   }
   var i = this.array.length;
   while(i--)
   {
      this.array[i].position.rotateXYTrig(ca,sa,cb,sb);
      this.array[i].render(p);
      this.array[i].rotation.x += a;
      this.array[i].rotation.y += b;
   }
};
RP.rotatePointX = function(id, angle)
{
   var p = this.pers;
   with(Math)
   {
      var ca = cosD(angle);
      var sa = sinD(angle);
   }
   this.array[id].position.rotateXTrig(ca,sa);
   this.array[id].render(p);
   this.array[id].rotation.x += angle;
};
RP.rotatePointY = function(id, angle)
{
   var p = this.pers;
   with(Math)
   {
      var ca = cosD(angle);
      var sa = sinD(angle);
   }
   this.array[id].position.rotateYTrig(ca,sa);
   this.array[id].render(p);
   this.array[id].rotation.y += angle;
};
RP.rotatePointZ = function(id, angle)
{
   var p = this.pers;
   with(Math)
   {
      var ca = cosD(angle);
      var sa = sinD(angle);
   }
   this.array[id].position.rotateZTrig(ca,sa);
   this.array[id].render(p);
   this.array[id].rotation.z += angle;
};
RP.rotatePointXY = function(id, a, b)
{
   var _loc1_ = this;
   var _loc2_ = id;
   var _loc3_ = _loc1_.pers;
   _loc1_.array[_loc2_].position.rotateXY(a,b);
   _loc1_.array[_loc2_].render(_loc3_);
   _loc1_.array[_loc2_].rotation.x += a;
   _loc1_.array[_loc2_].rotation.y += b;
};
RP.rotateObjectX = function(idInit, idEnd, angle)
{
   var p = this.pers;
   with(Math)
   {
      var ca = cosD(angle);
      var sa = sinD(angle);
   }
   var i = idInit;
   while(i <= idEnd)
   {
      this.array[i].position.rotateXTrig(ca,sa);
      this.array[i].render(p);
      this.array[i].rotation.x += angle;
      i++;
   }
};
RP.rotateObjectY = function(idInit, idEnd, angle)
{
   var p = this.pers;
   with(Math)
   {
      var ca = cosD(angle);
      var sa = sinD(angle);
   }
   var i = idInit;
   while(i <= idEnd)
   {
      this.array[i].position.rotateYTrig(ca,sa);
      this.array[i].render(p);
      this.array[i].rotation.y += angle;
      i++;
   }
};
RP.rotateObjectZ = function(idInit, idEnd, angle)
{
   var p = this.pers;
   with(Math)
   {
      var ca = cosD(angle);
      var sa = sinD(angle);
   }
   var i = idInit;
   while(i <= idEnd)
   {
      this.array[i].position.rotateZTrig(ca,sa);
      this.array[i].render(p);
      this.array[i].rotation.z += angle;
      i++;
   }
};
RP.rotateObjectXY = function(idInit, idEnd, angleX, angleY)
{
   var p = this.pers;
   with(Math)
   {
      var ca = cosD(angleX);
      var sa = sinD(angleX);
      var cb = cosD(angleY);
      var sb = sinD(angleY);
   }
   var i = this.array.length;
   var i = idInit;
   while(i <= idEnd)
   {
      this.array[i].position.rotateXYTrig(ca,sa,cb,sb);
      this.array[i].render(p);
      this.array[i].rotation.x += angleX;
      this.array[i].rotation.y += angleY;
      i++;
   }
};
RP.rotateObjectXTrig = function(idInit, idEnd, ca, sa)
{
   var _loc2_ = this;
   var _loc3_ = _loc2_.pers;
   var _loc1_ = idInit;
   while(_loc1_ <= idEnd)
   {
      _loc2_.array[_loc1_].position.rotateXTrig(ca,sa);
      _loc2_.array[_loc1_].render(_loc3_);
      _loc1_ = _loc1_ + 1;
   }
};
RP.rotateObjectYTrig = function(idInit, idEnd, ca, sa)
{
   var _loc2_ = this;
   var _loc3_ = _loc2_.pers;
   var _loc1_ = idInit;
   while(_loc1_ <= idEnd)
   {
      _loc2_.array[_loc1_].position.rotateYTrig(ca,sa);
      _loc2_.array[_loc1_].render(_loc3_);
      _loc1_ = _loc1_ + 1;
   }
};
RP.rotateObjectZTrig = function(idInit, idEnd, ca, sa)
{
   var _loc2_ = this;
   var _loc3_ = _loc2_.pers;
   var _loc1_ = idInit;
   while(_loc1_ <= idEnd)
   {
      _loc2_.array[_loc1_].position.rotateZTrig(ca,sa);
      _loc2_.array[_loc1_].render(_loc3_);
      _loc1_ = _loc1_ + 1;
   }
};
RP.rotateObjectXYTrig = function(idInit, idEnd, ca, sa, cb, sb)
{
   var _loc2_ = this;
   var _loc3_ = _loc2_.pers;
   var _loc1_ = _loc2_.array.length;
   _loc1_ = idInit;
   while(_loc1_ <= idEnd)
   {
      _loc2_.array[_loc1_].position.rotateXY(ca,sa,cb,sb);
      _loc2_.array[_loc1_].render(_loc3_);
      _loc1_ = _loc1_ + 1;
   }
};
RP.relativeRotateObjectX = function(idInit, idEnd, idV, angle)
{
   var p = this.pers;
   with(Math)
   {
      var ca = cosD(angle);
      var sa = sinD(angle);
   }
   var vTmp = typeof idV != "number" ? new Vector3d(idV.x,idV.y,idV.z) : this.array[idV].position.getClone();
   var i = idInit;
   while(i <= idEnd)
   {
      this.array[i].position.relativeRotateXTrig(vTmp,ca,sa);
      this.array[i].render(p);
      i++;
   }
};
RP.relativeRotateObjectY = function(idInit, idEnd, idV, angle)
{
   var p = this.pers;
   with(Math)
   {
      var ca = cosD(angle);
      var sa = sinD(angle);
   }
   var vTmp = typeof idV != "number" ? new Vector3d(idV.x,idV.y,idV.z) : this.array[idV].position.getClone();
   var i = idInit;
   while(i <= idEnd)
   {
      this.array[i].position.relativeRotateYTrig(vTmp,ca,sa);
      this.array[i].render(p);
      i++;
   }
};
RP.relativeRotateObjectZ = function(idInit, idEnd, idV, angle)
{
   var p = this.pers;
   with(Math)
   {
      var ca = cosD(angle);
      var sa = sinD(angle);
   }
   var vTmp = typeof idV != "number" ? new Vector3d(idV.x,idV.y,idV.z) : this.array[idV].position.getClone();
   var i = idInit;
   while(i <= idEnd)
   {
      this.array[i].position.relativeRotateZTrig(vTmp,ca,sa);
      this.array[i].render(p);
      i++;
   }
};
RP.relativeRotatePointX = function(id, idV, angle)
{
   var _loc1_ = idV;
   var _loc2_ = this;
   var p = _loc2_.pers;
   var _loc3_ = typeof _loc1_ != "number" ? new Vector3d(_loc1_.x,_loc1_.y,_loc1_.z) : _loc2_.array[_loc1_].position.getClone();
   _loc2_.array[id].position.relativeRotateX(_loc3_,angle);
   _loc2_.array[id].render(p);
};
RP.relativeRotatePointY = function(id, idV, angle)
{
   var _loc1_ = idV;
   var _loc2_ = this;
   var p = _loc2_.pers;
   var _loc3_ = typeof _loc1_ != "number" ? new Vector3d(_loc1_.x,_loc1_.y,_loc1_.z) : _loc2_.array[_loc1_].position.getClone();
   _loc2_.array[id].position.relativeRotateY(_loc3_,angle);
   _loc2_.array[id].render(p);
};
RP.relativeRotatePointZ = function(id, idV, angle)
{
   var _loc1_ = idV;
   var _loc2_ = this;
   var p = _loc2_.pers;
   var _loc3_ = typeof _loc1_ != "number" ? new Vector3d(_loc1_.x,_loc1_.y,_loc1_.z) : _loc2_.array[_loc1_].position.getClone();
   _loc2_.array[id].position.relativeRotateZ(_loc3_,angle);
   _loc2_.array[id].render(p);
};
RP.translateObject = function(idInit, idEnd, d)
{
   var _loc2_ = this;
   var _loc3_ = _loc2_.pers;
   var _loc1_ = idInit;
   while(_loc1_ <= idEnd)
   {
      _loc2_.array[_loc1_].position.plus(d);
      _loc2_.array[_loc1_].render(_loc3_);
      _loc1_ = _loc1_ + 1;
   }
};
RP.translatePoint = function(id, d)
{
   var _loc2_ = this;
   var _loc1_ = _loc2_.pers;
   _loc2_.array[id].position.plus(d);
   _loc2_.array[id].render(_loc1_);
};
RP.scalePoint = function(id, k)
{
   var _loc1_ = k;
   var _loc2_ = typeof _loc1_ != "number" ? new Vector3d(_loc1_.x,_loc1_.y,_loc1_.z) : new Vector3d(_loc1_,_loc1_,_loc1_);
   var _loc3_ = this.pers;
   this.array[id].position.scale(_loc2_);
   this.array[id].render(_loc3_);
};
RP.relativeScalePoint = function(id, idV, k)
{
   var _loc1_ = k;
   var _loc2_ = idV;
   var _loc3_ = this;
   var v = typeof _loc1_ != "number" ? new Vector3d(_loc1_.x,_loc1_.y,_loc1_.z) : new Vector3d(_loc1_,_loc1_,_loc1_);
   var vTmp = typeof _loc2_ != "number" ? new Vector3d(_loc2_.x,_loc2_.y,_loc2_.z) : _loc3_.array[_loc2_].position.getClone();
   var p = _loc3_.pers;
   _loc3_.array[id].position.relativeScale(vTmp,v);
   _loc3_.array[id].render(p);
};
RP.scaleObject = function(idInit, idEnd, k)
{
   var _loc2_ = this;
   var _loc3_ = typeof k != "number" ? new Vector3d(k.x,k.y,k.z) : new Vector3d(k,k,k);
   var p = _loc2_.pers;
   var _loc1_ = idInit;
   while(_loc1_ <= idEnd)
   {
      _loc2_.array[_loc1_].position.scale(_loc3_);
      _loc2_.array[_loc1_].render(p);
      _loc1_ = _loc1_ + 1;
   }
};
RP.relativeScaleObject = function(idInit, idEnd, idV, k)
{
   var _loc2_ = this;
   var _loc3_ = typeof k != "number" ? new Vector3d(k.x,k.y,k.z) : new Vector3d(k,k,k);
   var vTmp = typeof idV != "number" ? new Vector3d(idV.x,idV.y,idV.z) : _loc2_.array[idV].position.getClone();
   var p = _loc2_.pers;
   var _loc1_ = idInit;
   while(_loc1_ <= idEnd)
   {
      _loc2_.array[_loc1_].position.relativeScale(vTmp,_loc3_);
      _loc2_.array[_loc1_].render(p);
      _loc1_ = _loc1_ + 1;
   }
};
delete RP;
Math.linearTween = function(t, b, c, d)
{
   return c * t / d + b;
};
Math.easeInQuad = function(t, b, c, d)
{
   return c * (t /= d) * t + b;
};
Math.easeOutQuad = function(t, b, c, d)
{
   return (- c) * (t /= d) * (t - 2) + b;
};
Math.easeInOutQuad = function(t, b, c, d)
{
   var _loc1_ = t;
   if((_loc1_ /= d / 2) < 1)
   {
      return c / 2 * _loc1_ * _loc1_ + b;
   }
   return (- c) / 2 * ((_loc1_ = _loc1_ - 1) * (_loc1_ - 2) - 1) + b;
};
Math.easeInCubic = function(t, b, c, d)
{
   var _loc1_ = t;
   return c * (_loc1_ /= d) * _loc1_ * _loc1_ + b;
};
Math.easeOutCubic = function(t, b, c, d)
{
   var _loc1_ = t;
   return c * ((_loc1_ = _loc1_ / d - 1) * _loc1_ * _loc1_ + 1) + b;
};
Math.easeInOutCubic = function(t, b, c, d)
{
   var _loc1_ = t;
   if((_loc1_ /= d / 2) < 1)
   {
      return c / 2 * _loc1_ * _loc1_ * _loc1_ + b;
   }
   return c / 2 * ((_loc1_ -= 2) * _loc1_ * _loc1_ + 2) + b;
};
Math.easeInQuart = function(t, b, c, d)
{
   var _loc1_ = t;
   return c * (_loc1_ /= d) * _loc1_ * _loc1_ * _loc1_ + b;
};
Math.easeOutQuart = function(t, b, c, d)
{
   var _loc1_ = t;
   return (- c) * ((_loc1_ = _loc1_ / d - 1) * _loc1_ * _loc1_ * _loc1_ - 1) + b;
};
Math.easeInOutQuart = function(t, b, c, d)
{
   var _loc1_ = t;
   if((_loc1_ /= d / 2) < 1)
   {
      return c / 2 * _loc1_ * _loc1_ * _loc1_ * _loc1_ + b;
   }
   return (- c) / 2 * ((_loc1_ -= 2) * _loc1_ * _loc1_ * _loc1_ - 2) + b;
};
Math.easeInQuint = function(t, b, c, d)
{
   var _loc1_ = t;
   return c * (_loc1_ /= d) * _loc1_ * _loc1_ * _loc1_ * _loc1_ + b;
};
Math.easeOutQuint = function(t, b, c, d)
{
   var _loc1_ = t;
   return c * ((_loc1_ = _loc1_ / d - 1) * _loc1_ * _loc1_ * _loc1_ * _loc1_ + 1) + b;
};
Math.easeInOutQuint = function(t, b, c, d)
{
   var _loc1_ = t;
   if((_loc1_ /= d / 2) < 1)
   {
      return c / 2 * _loc1_ * _loc1_ * _loc1_ * _loc1_ * _loc1_ + b;
   }
   return c / 2 * ((_loc1_ -= 2) * _loc1_ * _loc1_ * _loc1_ * _loc1_ + 2) + b;
};
Math.easeInSine = function(t, b, c, d)
{
   return (- c) * Math.cos(t / d * 1.5707963267948966) + c + b;
};
Math.easeOutSine = function(t, b, c, d)
{
   return c * Math.sin(t / d * 1.5707963267948966) + b;
};
Math.easeInOutSine = function(t, b, c, d)
{
   return (- c) / 2 * (Math.cos(3.141592653589793 * t / d) - 1) + b;
};
Math.easeInExpo = function(t, b, c, d)
{
   return t != 0 ? c * Math.pow(2,10 * (t / d - 1)) + b : b;
};
Math.easeOutExpo = function(t, b, c, d)
{
   return t != d ? c * (- Math.pow(2,-10 * t / d) + 1) + b : b + c;
};
Math.easeInOutExpo = function(t, b, c, d)
{
   var _loc1_ = t;
   var _loc2_ = b;
   var _loc3_ = c;
   if(_loc1_ == 0)
   {
      return _loc2_;
   }
   if(_loc1_ == d)
   {
      return _loc2_ + _loc3_;
   }
   if((_loc1_ /= d / 2) < 1)
   {
      return _loc3_ / 2 * Math.pow(2,10 * (_loc1_ - 1)) + _loc2_;
   }
   return _loc3_ / 2 * (- Math.pow(2,-10 * (_loc1_ = _loc1_ - 1)) + 2) + _loc2_;
};
Math.easeInCirc = function(t, b, c, d)
{
   return (- c) * (Math.sqrt(1 - (t /= d) * t) - 1) + b;
};
Math.easeOutCirc = function(t, b, c, d)
{
   var _loc1_ = t;
   return c * Math.sqrt(1 - (_loc1_ = _loc1_ / d - 1) * _loc1_) + b;
};
Math.easeInOutCirc = function(t, b, c, d)
{
   var _loc1_ = t;
   if((_loc1_ /= d / 2) < 1)
   {
      return (- c) / 2 * (Math.sqrt(1 - _loc1_ * _loc1_) - 1) + b;
   }
   return c / 2 * (Math.sqrt(1 - (_loc1_ -= 2) * _loc1_) + 1) + b;
};
Math.easeInElastic = function(t, b, c, d, a, p)
{
   var _loc1_ = p;
   var _loc2_ = t;
   var _loc3_ = c;
   if(_loc2_ == 0)
   {
      return b;
   }
   if((_loc2_ /= d) == 1)
   {
      return b + _loc3_;
   }
   if(!_loc1_)
   {
      _loc1_ = d * 0.3;
   }
   if(a < Math.abs(_loc3_))
   {
      a = _loc3_;
      var s = _loc1_ / 4;
   }
   else
   {
      var s = _loc1_ / 6.283185307179586 * Math.asin(_loc3_ / a);
   }
   return - a * Math.pow(2,10 * (_loc2_ -= 1)) * Math.sin((_loc2_ * d - s) * 6.283185307179586 / _loc1_) + b;
};
Math.easeOutElastic = function(t, b, c, d, a, p)
{
   var _loc1_ = c;
   var _loc2_ = p;
   var _loc3_ = t;
   if(_loc3_ == 0)
   {
      return b;
   }
   if((_loc3_ /= d) == 1)
   {
      return b + _loc1_;
   }
   if(!_loc2_)
   {
      _loc2_ = d * 0.3;
   }
   if(a < Math.abs(_loc1_))
   {
      a = _loc1_;
      var s = _loc2_ / 4;
   }
   else
   {
      var s = _loc2_ / 6.283185307179586 * Math.asin(_loc1_ / a);
   }
   return a * Math.pow(2,-10 * _loc3_) * Math.sin((_loc3_ * d - s) * 6.283185307179586 / _loc2_) + _loc1_ + b;
};
Math.easeInOutElastic = function(t, b, c, d, a, p)
{
   var _loc1_ = t;
   var _loc2_ = p;
   var _loc3_ = c;
   if(_loc1_ == 0)
   {
      return b;
   }
   if((_loc1_ /= d / 2) == 2)
   {
      return b + _loc3_;
   }
   if(!_loc2_)
   {
      _loc2_ = d * 0.44999999999999996;
   }
   if(a < Math.abs(_loc3_))
   {
      a = _loc3_;
      var s = _loc2_ / 4;
   }
   else
   {
      var s = _loc2_ / 6.283185307179586 * Math.asin(_loc3_ / a);
   }
   if(_loc1_ < 1)
   {
      return -0.5 * (a * Math.pow(2,10 * (_loc1_ -= 1)) * Math.sin((_loc1_ * d - s) * 6.283185307179586 / _loc2_)) + b;
   }
   return a * Math.pow(2,-10 * (_loc1_ -= 1)) * Math.sin((_loc1_ * d - s) * 6.283185307179586 / _loc2_) * 0.5 + _loc3_ + b;
};
Math.easeInBack = function(t, b, c, d, s)
{
   var _loc1_ = s;
   var _loc2_ = t;
   if(_loc1_ == undefined)
   {
      _loc1_ = 2;
   }
   return c * (_loc2_ /= d) * _loc2_ * ((_loc1_ + 1) * _loc2_ - _loc1_) + b;
};
Math.easeOutBack = function(t, b, c, d, s)
{
   var _loc1_ = t;
   var _loc2_ = s;
   if(_loc2_ == undefined)
   {
      _loc2_ = 2;
   }
   return c * ((_loc1_ = _loc1_ / d - 1) * _loc1_ * ((_loc2_ + 1) * _loc1_ + _loc2_) + 1) + b;
};
Math.easeInOutBack = function(t, b, c, d, s)
{
   var _loc1_ = t;
   var _loc2_ = s;
   if(_loc2_ == undefined)
   {
      _loc2_ = 2;
   }
   if((_loc1_ /= d / 2) < 1)
   {
      return c / 2 * (_loc1_ * _loc1_ * (((_loc2_ *= 1.525) + 1) * _loc1_ - _loc2_)) + b;
   }
   return c / 2 * ((_loc1_ -= 2) * _loc1_ * (((_loc2_ *= 1.525) + 1) * _loc1_ + _loc2_) + 2) + b;
};
Math.easeInBounce = function(t, b, c, d)
{
   return c - Math.easeOutBounce(d - t,0,c,d) + b;
};
Math.easeOutBounce = function(t, b, c, d)
{
   var _loc1_ = t;
   var _loc2_ = c;
   var _loc3_ = b;
   if((_loc1_ /= d) < 0.36363636363636365)
   {
      return _loc2_ * (7.5625 * _loc1_ * _loc1_) + _loc3_;
   }
   if(_loc1_ < 0.7272727272727273)
   {
      return _loc2_ * (7.5625 * (_loc1_ -= 0.5454545454545454) * _loc1_ + 0.75) + _loc3_;
   }
   if(_loc1_ < 0.9090909090909091)
   {
      return _loc2_ * (7.5625 * (_loc1_ -= 0.8181818181818182) * _loc1_ + 0.9375) + _loc3_;
   }
   return _loc2_ * (7.5625 * (_loc1_ -= 0.9545454545454546) * _loc1_ + 0.984375) + _loc3_;
};
Math.easeInOutBounce = function(t, b, c, d)
{
   var _loc1_ = d;
   var _loc2_ = t;
   var _loc3_ = c;
   if(_loc2_ < _loc1_ / 2)
   {
      return Math.easeInBounce(_loc2_ * 2,0,_loc3_,_loc1_) * 0.5 + b;
   }
   return Math.easeOutBounce(_loc2_ * 2 - _loc1_,0,_loc3_,_loc1_) * 0.5 + _loc3_ * 0.5 + b;
};
Math.sinD = function(angle)
{
   return Math.sin(angle * 0.017453292519943295);
};
Math.cosD = function(angle)
{
   return Math.cos(angle * 0.017453292519943295);
};
Math.tanD = function(angle)
{
   return Math.tan(angle * 0.017453292519943295);
};
Math.asinD = function(ratio)
{
   return Math.asin(ratio) * 57.29577951308232;
};
Math.acosD = function(ratio)
{
   return Math.acos(ratio) * 57.29577951308232;
};
Math.atanD = function(ratio)
{
   return Math.atan(ratio) * 57.29577951308232;
};
Math.atan2D = function(y, x)
{
   return Math.atan2(y,x) * 57.29577951308232;
};
Math.fixAngle = function(angle)
{
   var _loc1_ = angle;
   _loc1_ %= 360;
   if(_loc1_ >= 0)
   {
      return _loc1_;
   }
   return _loc1_ + 360;
};
if(typeof Math.cosD != "function")
{
   trace("error: Math.cosD function mission");
}
_global.Particle3d = function(x, y, z, timeline, mcID, depth, rot)
{
   var _loc1_ = this;
   var _loc2_ = rot;
   _loc1_.position = new Vector3d(x,y,z);
   _loc1_.timeline = timeline;
   _loc1_.mc = _loc1_.attachGraphic(mcID,depth);
   _loc1_.rotation = _loc2_ != undefined ? new Vector3d(_loc2_[0],_loc2_[1],_loc2_[2]) : new Vector3d(0,0,0);
   _loc1_.scale = 100;
   _loc1_.render();
};
Particle3d.prototype.attachGraphic = function(mcID, depth)
{
   return this.timeline.attachMovie(mcID,mcID + "_" + depth,depth);
};
Particle3d.prototype.render = function(perspective)
{
   var pers = this.position.getPerspective(perspective);
   this.screenPos = this.position.persProjectNew(pers);
   with(this.mc)
   {
      _x = this.screenPos.x;
      _y = - this.screenPos.y;
      _xscale = _yscale = this.scale * pers * 1.5;
      swapDepths(100000 - this.position.z * 100);
   }
};
_global.Point3d = function(x, y, z, timeline, taille, couleur, alpha, depth, rot)
{
   var _loc1_ = this;
   var _loc2_ = rot;
   _loc1_.position = new Vector3d(x,y,z);
   _loc1_.timeline = timeline;
   _loc1_.point = _loc1_.drawPoint(taille,couleur,alpha,depth);
   _loc1_.rotation = _loc2_ != undefined ? new Vector3d(_loc2_[0],_loc2_[1],_loc2_[2]) : new Vector3d(0,0,0);
   _loc1_.scale = 100;
   _loc1_.render();
};
Point3d.prototype.drawPoint = function(taille, couleur, alpha, depth)
{
   var newPoint = "point" + depth;
   this.timeline.createEmptyMovieClip(newPoint,depth);
   with(this.timeline[newPoint])
   {
      lineStyle(taille,couleur,alpha);
      lineTo(1,0);
   }
   return this.timeline[newPoint];
};
Point3d.prototype.render = function(perspective)
{
   var pers = this.position.getPerspective(perspective);
   this.screenPos = this.position.persProjectNew(pers);
   with(this.point)
   {
      _x = this.screenPos.x;
      _y = - this.screenPos.y;
      _xscale = _yscale = this.scale * pers * 1.5;
      swapDepths(100000 - this.position.z * 100);
   }
};
MovieClip.prototype.drawLine = function(x1, y1, x2, y2)
{
   with(this)
   {
      moveTo(x1,y1);
      lineTo(x2,y2);
   }
};
MovieClip.prototype.drawTri = function(p1, p2, p3)
{
   with(this)
   {
      moveTo(p1.x,p1.y);
      lineTo(p2.x,p2.y);
      lineTo(p3.x,p3.y);
      lineTo(p1.x,p1.y);
   }
};
MovieClip.prototype.drawQuad = function(p1, p2, p3, p4)
{
   with(this)
   {
      moveTo(p1.x,p1.y);
      lineTo(p2.x,p2.y);
      lineTo(p3.x,p3.y);
      lineTo(p4.x,p4.y);
      lineTo(p1.x,p1.y);
   }
};
MovieClip.prototype.drawRect = function(x1, y1, x2, y2)
{
   with(this)
   {
      moveTo(x1,y1);
      lineTo(x2,y1);
      lineTo(x2,y2);
      lineTo(x1,y2);
      lineTo(x1,y1);
   }
};
MovieClip.prototype.drawRectRel = function(x, y, width, height)
{
   this.drawRect(x,y,x + width,y + height);
};
MovieClip.prototype.drawRectCenter = function(x, y, w, h)
{
   this.drawRect(x - w / 2,y - h / 2,x + w / 2,y + h / 2);
};
MovieClip.prototype.drawSquare = function(x, y, width)
{
   this.drawRect(x,y,x + width,y + width);
};
MovieClip.prototype.drawSquareCent = function(x, y, width)
{
   var _loc1_ = width / 2;
   this.drawRect(x - _loc1_,y - _loc1_,x + _loc1_,y + _loc1_);
};
MovieClip.prototype.drawDot = function(x, y)
{
   this.drawRect(x - 0.5,y - 0.5,x + 0.5,y + 0.5);
};
MovieClip.prototype.drawPoly = function(pts)
{
   var _loc2_ = pts;
   var _loc3_ = this;
   _loc3_.moveTo(_loc2_[0].x,_loc2_[0].y);
   var _loc1_ = _loc2_.length;
   while(_loc1_--)
   {
      _loc3_.lineTo(_loc2_[_loc1_].x,_loc2_[_loc1_].y);
   }
};
MovieClip.prototype.drawRegPoly = function(x, y, radius, numPts, rotation)
{
   var _loc1_ = (-90 + rotation) * 0.017453292519943295;
   var pts = [];
   var _loc3_;
   var _loc2_;
   var dAngle = 6.283185307179586 / numPts;
   var cos = Math.cos;
   var sin = Math.sin;
   while(numPts--)
   {
      _loc1_ += dAngle;
      _loc3_ = radius * cos(_loc1_) + x;
      _loc2_ = radius * sin(_loc1_) + y;
      pts.push({x:_loc3_,y:_loc2_});
   }
   this.drawPoly(pts);
};
Math.sinD = function(angle)
{
   return Math.sin(angle * 0.017453292519943295);
};
Math.cosD = function(angle)
{
   return Math.cos(angle * 0.017453292519943295);
};
Math.acosD = function(ratio)
{
   return Math.acos(ratio) * 57.29577951308232;
};
_global.Vector3d = function(x, y, z)
{
   var _loc1_ = this;
   _loc1_.x = x;
   _loc1_.y = y;
   _loc1_.z = z;
};
Vector3d.prototype.toString = function()
{
   var _loc1_ = this;
   var x = Math.round(_loc1_.x * 1000) / 1000;
   var _loc3_ = Math.round(_loc1_.y * 1000) / 1000;
   var _loc2_ = Math.round(_loc1_.z * 1000) / 1000;
   return "[" + x + ", " + _loc3_ + ", " + _loc2_ + "]";
};
Vector3d.prototype.reset = function(x, y, z)
{
   this.constructor(x,y,z);
};
Vector3d.prototype.getClone = function()
{
   with(this)
   {
      return new constructor(x,y,z);
   }
};
Vector3d.prototype.equals = function(v)
{
   with(this)
   {
      return x == v.x && y == v.y && z == v.z;
   }
};
Vector3d.prototype.plus = function(v)
{
   with(this)
   {
      x += v.x;
      y += v.y;
      z += v.z;
   }
};
Vector3d.prototype.plusNew = function(v)
{
   with(this)
   {
      return new constructor(x + v.x,y + v.y,z + v.z);
   }
};
Vector3d.prototype.minus = function(v)
{
   with(this)
   {
      x -= v.x;
      y -= v.y;
      z -= v.z;
   }
};
Vector3d.prototype.minusNew = function(v)
{
   with(this)
   {
      return new constructor(x - v.x,y - v.y,z - v.z);
   }
};
Vector3d.prototype.negate = function()
{
   with(this)
   {
      x = - x;
      y = - y;
      z = - z;
   }
};
Vector3d.prototype.negateNew = function()
{
   with(this)
   {
      return new constructor(- x,- y,- z);
   }
};
Vector3d.prototype.scale = function(v)
{
   with(this)
   {
      x *= v.x;
      y *= v.y;
      z *= v.z;
   }
};
Vector3d.prototype.scaleNew = function(v)
{
   with(this)
   {
      return new constructor(x * v.x,y * v.y,z * v.z);
   }
};
Vector3d.prototype.relativeScale = function(v, s)
{
   var _loc1_ = this.minusNew(v);
   _loc1_.scale(s);
   _loc1_.plus(v);
   this.reset(_loc1_.x,_loc1_.y,_loc1_.z);
};
Vector3d.prototype.getLength = function()
{
   with(this)
   {
      return Math.sqrt(x * x + y * y + z * z);
   }
};
Vector3d.prototype.setLength = function(len)
{
   var _loc2_ = this;
   var _loc1_ = _loc2_.getLength();
   if(_loc1_)
   {
      _loc2_.scale(len / _loc1_);
   }
   else
   {
      _loc2_.x = len;
   }
};
Vector3d.prototype.dot = function(v)
{
   with(this)
   {
      return x * v.x + y * v.y + z * v.z;
   }
};
Vector3d.prototype.cross = function(v)
{
   with(this)
   {
      var cx = y * v.z - z * v.y;
      var cy = z * v.x - x * v.z;
      var cz = x * v.y - y * v.x;
      return new constructor(cx,cy,cz);
   }
};
Vector3d.prototype.getPerspective = function(viewDist)
{
   var _loc1_ = viewDist;
   if(_loc1_ == undefined)
   {
      _loc1_ = 1000;
   }
   return _loc1_ / (this.z + _loc1_);
};
Vector3d.prototype.persProject = function(p)
{
   with(this)
   {
      if(p == undefined)
      {
         p = getPerspective();
      }
      x *= p;
      y *= p;
      z = 0;
   }
};
Vector3d.prototype.persProjectNew = function(p)
{
   with(this)
   {
      if(p == undefined)
      {
         p = getPerspective();
      }
      return new constructor(p * x,p * y,0);
   }
};
Vector3d.prototype.rotateX = function(angle)
{
   with(Math)
   {
      var ca = cosD(angle);
      var sa = sinD(angle);
   }
   with(this)
   {
      var tempY = y * ca - z * sa;
      var tempZ = y * sa + z * ca;
      y = tempY;
      z = tempZ;
   }
};
Vector3d.prototype.rotateXTrig = function(ca, sa)
{
   with(this)
   {
      var tempY = y * ca - z * sa;
      var tempZ = y * sa + z * ca;
      y = tempY;
      z = tempZ;
   }
};
Vector3d.prototype.rotateY = function(angle)
{
   with(Math)
   {
      var ca = cosD(angle);
      var sa = sinD(angle);
   }
   with(this)
   {
      var tempX = x * ca + z * sa;
      var tempZ = x * (- sa) + z * ca;
      x = tempX;
      z = tempZ;
   }
};
Vector3d.prototype.rotateYTrig = function(ca, sa)
{
   with(this)
   {
      var tempX = x * ca + z * sa;
      var tempZ = x * (- sa) + z * ca;
      x = tempX;
      z = tempZ;
   }
};
Vector3d.prototype.rotateZ = function(angle)
{
   with(Math)
   {
      var ca = cosD(angle);
      var sa = sinD(angle);
   }
   with(this)
   {
      var tempX = x * ca - y * sa;
      var tempY = x * sa + y * ca;
      x = tempX;
      y = tempY;
   }
};
Vector3d.prototype.rotateZTrig = function(ca, sa)
{
   with(this)
   {
      var tempX = x * ca - y * sa;
      var tempY = x * sa + y * ca;
      x = tempX;
      y = tempY;
   }
};
Vector3d.prototype.rotateXY = function(a, b)
{
   with(Math)
   {
      var ca = cosD(a);
      var sa = sinD(a);
      var cb = cosD(b);
      var sb = sinD(b);
   }
   with(this)
   {
      var rz = y * sa + z * ca;
      y = y * ca - z * sa;
      z = x * (- sb) + rz * cb;
      x = x * cb + rz * sb;
   }
};
Vector3d.prototype.rotateXYTrig = function(ca, sa, cb, sb)
{
   with(this)
   {
      var rz = y * sa + z * ca;
      y = y * ca - z * sa;
      z = x * (- sb) + rz * cb;
      x = x * cb + rz * sb;
   }
};
Vector3d.prototype.rotateXYZ = function(a, b, c)
{
   with(Math)
   {
      var ca = cosD(a);
      var sa = sinD(a);
      var cb = cosD(b);
      var sb = sinD(b);
      var cc = cosD(c);
      var sc = sinD(c);
   }
   with(this)
   {
      var ry = y * ca - z * sa;
      var rz = y * sa + z * ca;
      var rx = x * cb + rz * sb;
      z = x * (- sb) + rz * cb;
      x = rx * cc - ry * sc;
      y = rx * sc + ry * cc;
   }
};
Vector3d.prototype.rotateXYZTrig = function(ca, sa, cb, sb, cc, sc)
{
   with(this)
   {
      var ry = y * ca - z * sa;
      var rz = y * sa + z * ca;
      var rx = x * cb + rz * sb;
      z = x * (- sb) + rz * cb;
      x = rx * cc - ry * sc;
      y = rx * sc + ry * cc;
   }
};
Vector3d.prototype.relativeRotateX = function(v, angle)
{
   var _loc1_ = this.minusNew(v);
   _loc1_.rotateX(angle);
   _loc1_.plus(v);
   this.reset(_loc1_.x,_loc1_.y,_loc1_.z);
};
Vector3d.prototype.relativeRotateY = function(v, angle)
{
   var _loc1_ = this.minusNew(v);
   _loc1_.rotateY(angle);
   _loc1_.plus(v);
   this.reset(_loc1_.x,_loc1_.y,_loc1_.z);
};
Vector3d.prototype.relativeRotateZ = function(v, angle)
{
   var _loc1_ = this.minusNew(v);
   _loc1_.rotateZ(angle);
   _loc1_.plus(v);
   this.reset(_loc1_.x,_loc1_.y,_loc1_.z);
};
Vector3d.prototype.relativeRotateXTrig = function(v, ca, sa)
{
   var _loc1_ = this.minusNew(v);
   _loc1_.rotateXTrig(ca,sa);
   _loc1_.plus(v);
   this.reset(_loc1_.x,_loc1_.y,_loc1_.z);
};
Vector3d.prototype.relativeRotateYTrig = function(v, ca, sa)
{
   var _loc1_ = this.minusNew(v);
   _loc1_.rotateYTrig(ca,sa);
   _loc1_.plus(v);
   this.reset(_loc1_.x,_loc1_.y,_loc1_.z);
};
Vector3d.prototype.relativeRotateZTrig = function(v, ca, sa)
{
   var _loc1_ = this.minusNew(v);
   _loc1_.rotateZTrig(ca,sa);
   _loc1_.plus(v);
   this.reset(_loc1_.x,_loc1_.y,_loc1_.z);
};
Vector3d.prototype.relativeScale = function(v, k)
{
   var _loc2_ = v;
   var _loc1_ = this.minusNew(_loc2_);
   _loc1_.scale(_loc2_);
   _loc1_.plus(_loc2_);
   this.reset(_loc1_.x,_loc1_.y,_loc1_.z);
};
Math.sinD = function(angle)
{
   return Math.sin(angle * 0.017453292519943295);
};
Math.cosD = function(angle)
{
   return Math.cos(angle * 0.017453292519943295);
};
Math.acosD = function(ratio)
{
   return Math.acos(ratio) * 57.29577951308232;
};
_global.Vector = function(x, y)
{
   this.x = x;
   this.y = y;
};
Vector.prototype.toString = function()
{
   var _loc2_ = Math.round(this.x * 1000) / 1000;
   var _loc1_ = Math.round(this.y * 1000) / 1000;
   return "[" + _loc2_ + ", " + _loc1_ + "]";
};
Vector.prototype.reset = function(x, y)
{
   this.constructor(x,y);
};
Vector.prototype.getClone = function()
{
   var _loc1_ = this;
   return new _loc1_.constructor(_loc1_.x,_loc1_.y);
};
Vector.prototype.plus = function(v)
{
   with(this)
   {
      x += v.x;
      y += v.y;
   }
};
Vector.prototype.plusNew = function(v)
{
   with(this)
   {
      return new constructor(x + v.x,y + v.y);
   }
};
Vector.prototype.minus = function(v)
{
   with(this)
   {
      x -= v.x;
      y -= v.y;
   }
};
Vector.prototype.minusNew = function(v)
{
   with(this)
   {
      return new constructor(x - v.x,y - v.y);
   }
};
Vector.prototype.negate = function()
{
   with(this)
   {
      x = - x;
      y = - y;
   }
};
Vector.prototype.negateNew = function(v)
{
   with(this)
   {
      return new constructor(- x,- y);
   }
};
Vector.prototype.scale = function(s)
{
   with(this)
   {
      x *= s;
      y *= s;
   }
};
Vector.prototype.scaleNew = function(s)
{
   with(this)
   {
      return new constructor(x * s,y * s);
   }
};
Vector.prototype.getLength = function()
{
   with(this)
   {
      return Math.sqrt(x * x + y * y);
   }
};
Vector.prototype.setLength = function(len)
{
   var _loc2_ = this;
   var _loc1_ = _loc2_.getLength();
   if(_loc1_)
   {
      _loc2_.scale(len / _loc1_);
   }
   else
   {
      _loc2_.x = len;
   }
};
Vector.prototype.getAngle = function()
{
   return Math.atan2D(this.y,this.x);
};
Vector.prototype.setAngle = function(ang)
{
   with(this)
   {
      var r = getLength();
      x = r * Math.cosD(ang);
      y = r * Math.sinD(ang);
   }
};
Vector.prototype.rotate = function(ang)
{
   with(Math)
   {
      var ca = cosD(ang);
      var sa = sinD(ang);
   }
   with(this)
   {
      var rx = x * ca - y * sa;
      var ry = x * sa + y * ca;
      x = rx;
      y = ry;
   }
};
Vector.prototype.rotateNew = function(ang)
{
   with(this)
   {
      var v = new constructor(x,y,z);
   }
   v.rotate(ang);
   return v;
};
Vector.prototype.dot = function(v)
{
   with(this)
   {
      return x * v.x + y * v.y;
   }
};
Vector.prototype.getNormal = function()
{
   with(this)
   {
      new constructor(- y,x);
   }
};
Vector.prototype.isNormalTo = function(v)
{
   return this.dot(v) == 0;
};
Vector.prototype.angleBetween = function(v)
{
   var _loc2_ = this.dot(v);
   var _loc1_ = _loc2_ / (this.getLength() * v.getLength());
   return Math.acosD(_loc1_);
};
with(Vector.prototype)
{
   addProperty("length",getLength,setLength);
   addProperty("angle",getAngle,setAngle);
}
