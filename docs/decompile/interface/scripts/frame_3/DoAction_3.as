MovieClip.prototype.getCube3dPoints = function(repere, x, y, z, long, larg, haut, taille, couleur, alpha)
{
   var _loc1_ = repere;
   _loc1_.idObjet.push(_loc1_.array.length);
   var _loc2_ = taille != undefined ? taille : 3;
   var c = couleur != undefined ? couleur : "0x000000";
   var a = alpha != undefined ? alpha : 100;
   var lo = long / 2;
   var _loc3_ = larg / 2;
   var h = haut / 2;
   var depth = _loc1_.array.length;
   _loc1_.array.push(new Point3d(x - lo,y + _loc3_,z + h,this,_loc2_,couleur,alpha,depth++));
   _loc1_.array.push(new Point3d(x + lo,y + _loc3_,z + h,this,_loc2_,couleur,alpha,depth++));
   _loc1_.array.push(new Point3d(x + lo,y - _loc3_,z + h,this,_loc2_,couleur,alpha,depth++));
   _loc1_.array.push(new Point3d(x - lo,y - _loc3_,z + h,this,_loc2_,couleur,alpha,depth++));
   _loc1_.array.push(new Point3d(x - lo,y + _loc3_,z - h,this,_loc2_,couleur,alpha,depth++));
   _loc1_.array.push(new Point3d(x + lo,y + _loc3_,z - h,this,_loc2_,couleur,alpha,depth++));
   _loc1_.array.push(new Point3d(x + lo,y - _loc3_,z - h,this,_loc2_,couleur,alpha,depth++));
   _loc1_.array.push(new Point3d(x - lo,y - _loc3_,z - h,this,_loc2_,couleur,alpha,depth++));
};
MovieClip.prototype.getCercle3dPoints = function(repere, x, y, z, rx, ry, taille, couleur, alpha)
{
   var _loc1_ = repere;
   _loc1_.idObjet.push(_loc1_.array.length);
   var _loc2_ = taille != undefined ? taille : 3;
   var _loc3_ = couleur != undefined ? couleur : "0x000000";
   var a = alpha != undefined ? alpha : 100;
   var depth = _loc1_.array.length;
   _loc1_.array.push(new Point3d(x + rx,y,z,this,_loc2_,_loc3_,a,depth++));
   _loc1_.array.push(new Point3d(rx + x,0.4142 * ry + y,z,this,_loc2_,_loc3_,a,depth++));
   _loc1_.array.push(new Point3d(0.7071 * rx + x,0.7071 * ry + y,z,this,_loc2_,_loc3_,a,depth++));
   _loc1_.array.push(new Point3d(0.4142 * rx + x,ry + y,z,this,_loc2_,_loc3_,a,depth++));
   _loc1_.array.push(new Point3d(x,ry + y,z,this,_loc2_,_loc3_,a,depth++));
   _loc1_.array.push(new Point3d(-0.4142 * rx + x,ry + y,z,this,_loc2_,_loc3_,a,depth++));
   _loc1_.array.push(new Point3d(-0.7071 * rx + x,0.7071 * ry + y,z,this,_loc2_,_loc3_,a,depth++));
   _loc1_.array.push(new Point3d(- rx + x,0.4142 * ry + y,z,this,_loc2_,_loc3_,a,depth++));
   _loc1_.array.push(new Point3d(- rx + x,y,z,this,_loc2_,_loc3_,a,depth++));
   _loc1_.array.push(new Point3d(- rx + x,-0.4142 * ry + y,z,this,_loc2_,_loc3_,a,depth++));
   _loc1_.array.push(new Point3d(-0.7071 * rx + x,-0.7071 * ry + y,z,this,_loc2_,_loc3_,a,depth++));
   _loc1_.array.push(new Point3d(-0.4142 * rx + x,- ry + y,z,this,_loc2_,_loc3_,a,depth++));
   _loc1_.array.push(new Point3d(x,- ry + y,z,this,_loc2_,_loc3_,a,depth++));
   _loc1_.array.push(new Point3d(0.4142 * rx + x,- ry + y,z,this,_loc2_,_loc3_,a,depth++));
   _loc1_.array.push(new Point3d(0.7071 * rx + x,-0.7071 * ry + y,z,this,_loc2_,_loc3_,a,depth++));
   _loc1_.array.push(new Point3d(rx + x,-0.4142 * ry + y,z,this,_loc2_,_loc3_,a,depth++));
   _loc1_.array.push(new Point3d(rx + x,y,z,this,_loc2_,_loc3_,a,depth++));
   _loc1_.array.push(new Point3d(rx + x,y,z,this,_loc2_,_loc3_,a,depth++));
};
MovieClip.prototype.getEtoile3dPoints = function(repere, x, y, z, long, larg, haut, taille, couleur, alpha)
{
   var _loc1_ = repere;
   _loc1_.idObjet.push(_loc1_.array.length);
   var _loc2_ = taille != undefined ? taille : 3;
   var c = couleur != undefined ? couleur : "0x000000";
   var a = alpha != undefined ? alpha : 100;
   var lo = long / 2;
   var lr = larg / 2;
   var h = haut / 2;
   var _loc3_ = _loc1_.array.length;
   _loc1_.array.push(new Point3d(x + lo,y + lr,h,this,_loc2_,couleur,alpha,_loc3_++));
   _loc1_.array.push(new Point3d(x + lo,y - lr,h,this,_loc2_,couleur,alpha,_loc3_++));
   _loc1_.array.push(new Point3d(x - lo,y - lr,h,this,_loc2_,couleur,alpha,_loc3_++));
   _loc1_.array.push(new Point3d(x - lo,y + lr,h,this,_loc2_,couleur,alpha,_loc3_++));
   _loc1_.array.push(new Point3d(x,y,h,this,_loc2_,couleur,alpha,_loc3_++));
};
MovieClip.prototype.getCarre3dPoints = function(repere, x, y, z, long, larg, haut, taille, couleur, alpha)
{
   var _loc1_ = repere;
   _loc1_.idObjet.push(_loc1_.array.length);
   var _loc2_ = taille != undefined ? taille : 3;
   var c = couleur != undefined ? couleur : "0x000000";
   var a = alpha != undefined ? alpha : 100;
   var lo = long / 2;
   var _loc3_ = larg / 2;
   var h = haut / 2;
   var depth = _loc1_.array.length;
   _loc1_.array.push(new Point3d(x + lo,y + _loc3_,h,this,_loc2_,couleur,alpha,depth++));
   _loc1_.array.push(new Point3d(x + lo,y - _loc3_,h,this,_loc2_,couleur,alpha,depth++));
   _loc1_.array.push(new Point3d(x - lo,y - _loc3_,h,this,_loc2_,couleur,alpha,depth++));
   _loc1_.array.push(new Point3d(x - lo,y + _loc3_,h,this,_loc2_,couleur,alpha,depth++));
};
