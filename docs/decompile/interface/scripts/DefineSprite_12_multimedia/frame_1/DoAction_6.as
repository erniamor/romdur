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
univers = new Repere3d(500);
var pt = 1;
var pc = "0x000000";
var pa = 0;
this.getCube3dPoints(univers,-159,0,-80,100,10,220,pt,pc,pa);
this.createEmptyMovieClip("cube0",10000);
this.cube0.apiNom = "cube0";
this.cube0.createApi(univers,createPtsArray(univers.idObjet[0],8),"cube0",0,"cube",false,"global");
this.getCube3dPoints(univers,-53,0,-80,100,10,220,pt,pc,pa);
this.createEmptyMovieClip("cube1",10001);
this.cube1.apiNom = "cube1";
this.cube1.createApi(univers,createPtsArray(univers.idObjet[1],8),"cube1",0,"cube",false,"global");
this.getCube3dPoints(univers,53,0,-80,100,10,220,pt,pc,pa);
this.createEmptyMovieClip("cube2",10002);
this.cube2.apiNom = "cube2";
this.cube2.createApi(univers,createPtsArray(univers.idObjet[2],8),"cube2",0,"cube",false,"global");
this.getCube3dPoints(univers,159,0,-80,100,10,220,pt,pc,pa);
this.createEmptyMovieClip("cube3",10003);
this.cube3.apiNom = "cube3";
this.cube3.createApi(univers,createPtsArray(univers.idObjet[3],8),"cube3",0,"cube",false,"global");
var inc = univers.array.length;
univers.array.push(new Point3d(0,0,0,this,2,pc,100,inc++));
univers.array.push(new Point3d(0,0,0,this,2,pc,100,inc++));
this.createEmptyMovieClip("ligne",20004);
this.ligne.createApi(univers,[32,33],"ligne",1,"standardLine",false,"global");
univers.rotateX(-6);
this.createEmptyMovieClip("BT_0",20005);
this.BT_0.attachTextFace("I",univers,4,false);
this.createEmptyMovieClip("BT_1",20006);
this.BT_1.attachTextFace("II",univers,12,false);
this.createEmptyMovieClip("BT_2",20007);
this.BT_2.attachTextFace("III",univers,20,false);
this.createEmptyMovieClip("BT_3",20008);
this.BT_3.attachTextFace("IV",univers,28,false);
this.saveRepere(univers,"multi_accueil");
