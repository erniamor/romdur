function resetMoteurApi()
{
   _level0.MoteurApi.apiOn.length = 0;
   _level0.MoteurApi.apiOff.length = 0;
}
function setApiLocal(apiNom, apiStyle)
{
   var _loc1_ = apiNom;
   _level0.MoteurApi.apiOn[_loc1_].styleMethode = "local";
   _level0.MoteurApi.apiOn[_loc1_].styleLocal = apiStyle;
   _level0.MoteurApi.apiOn[_loc1_].fonction = typageFonction(_level0.MoteurApi.apiOn[_loc1_].typeObjet,"local");
}
function setApiGlobal(apiNom)
{
   var _loc1_ = apiNom;
   _level0.MoteurApi.apiOn[_loc1_].styleMethode = "global";
   _level0.MoteurApi.apiOn[_loc1_].fonction = typageFonction(_level0.MoteurApi.apiOn[_loc1_].typeObjet,"global");
}
function typageFonction(typeObjet, typeMethode)
{
   if(typeMethode == "global")
   {
      switch(typeObjet)
      {
         case "standardLine":
            return apiStandardLine;
         case "standardCurve":
            return apiStandardCurve;
         case "standardFillLine":
            return apiStandardFillLine;
         case "standardFillCurve":
            return apiStandardFillCurve;
         case "cercle":
            return apiCercle;
         case "cercleCutted":
            return apiCercleCutted;
         case "liaisonCylindre":
            return apiLiaisonCylindre;
         case "liaisonCerclePic":
            return apiLiaisonCerclePic;
         case "etoile":
            return apiEtoile;
         case "cube":
            return apiCube;
         default:
            return;
      }
   }
   else
   {
      switch(typeObjet)
      {
         case "standardLine":
            return apiStandardLineLocal;
         case "standardCurve":
            return apiStandardCurveLocal;
         case "standardFillLine":
            return apiStandardFillLineLocal;
         case "standardFillCurve":
            return apiStandardFillCurveLocal;
         case "cercle":
            return apiCercleLocal;
         case "cercleCutted":
            return apiCercleCuttedLocal;
         case "liaisonCylindre":
            return apiLiaisonCylindreLocal;
         case "liaisonCerclePic":
            return apiLiaisonCerclePicLocal;
         case "etoile":
            return apiEtoileLocal;
         case "cube":
            return apiCubeLocal;
         default:
            return;
      }
   }
}
function apiActiveEtat(nomObj)
{
   var _loc1_ = nomObj;
   if(_level0.MoteurApi.apiOff[_loc1_] != undefined)
   {
      _level0.MoteurApi.apiOn[_loc1_] = _level0.MoteurApi.apiOff[_loc1_];
      _level0.MoteurApi.apiOn[_loc1_].etat = true;
      delete _level0.MoteurApi.apiOff[_loc1_];
   }
}
function apiDesactiveEtat(nomObj)
{
   var _loc1_ = nomObj;
   if(_level0.MoteurApi.apiOn[_loc1_] != undefined)
   {
      _level0.MoteurApi.apiOff[_loc1_] = _level0.MoteurApi.apiOn[_loc1_];
      _level0.MoteurApi.apiOff[_loc1_].etat = false;
      _level0.MoteurApi.apiOn[_loc1_].mc.clear();
      delete _level0.MoteurApi.apiOn[_loc1_];
   }
}
function apiStandardLine(apiObj)
{
   with(apiObj)
   {
      mc.clear();
      mc.lineStyle(_level0.MoteurApi.style[styleId][0],_level0.MoteurApi.style[styleId][1],_level0.MoteurApi.style[styleId][2]);
      mc.moveTo(repere.array[pts[0]].screenPos.x,- repere.array[pts[0]].screenPos.y);
      var i = 1;
      while(i < pts.length)
      {
         mc.lineTo(repere.array[pts[i]].screenPos.x,- repere.array[pts[i]].screenPos.y);
         i++;
      }
   }
}
function apiStandardLineLocal(apiObj)
{
   with(apiObj)
   {
      mc.clear();
      mc.lineStyle(styleLocal[0],styleLocal[1],styleLocal[2]);
      mc.moveTo(repere.array[pts[0]].screenPos.x,- repere.array[pts[0]].screenPos.y);
      var i = 1;
      while(i < pts.length)
      {
         mc.lineTo(repere.array[pts[i]].screenPos.x,- repere.array[pts[i]].screenPos.y);
         i++;
      }
   }
}
function apiStandardCurve(apiObj)
{
   with(apiObj)
   {
      mc.clear();
      mc.lineStyle(_level0.MoteurApi.style[styleId][0],_level0.MoteurApi.style[styleId][1],_level0.MoteurApi.style[styleId][2]);
      mc.moveTo(repere.array[pts[0]].screenPos.x,- repere.array[pts[0]].screenPos.y);
      var i = 1;
      while(i < pts.length)
      {
         mc.curveTo(repere.array[pts[i]].screenPos.x,- repere.array[pts[i]].screenPos.y,repere.array[pts[i + 1]].screenPos.x,- repere.array[pts[i + 1]].screenPos.y);
         i += 2;
      }
   }
}
function apiStandardCurveLocal(apiObj)
{
   with(apiObj)
   {
      mc.clear();
      mc.lineStyle(styleLocal[0],styleLocal[1],styleLocal[2]);
      mc.moveTo(repere.array[pts[0]].screenPos.x,- repere.array[pts[0]].screenPos.y);
      var i = 1;
      while(i < pts.length)
      {
         mc.curveTo(repere.array[pts[i]].screenPos.x,- repere.array[pts[i]].screenPos.y,repere.array[pts[i + 1]].screenPos.x,- repere.array[pts[i + 1]].screenPos.y);
         i += 2;
      }
   }
}
function apiStandardFillLine(apiObj)
{
   with(apiObj)
   {
      mc.clear();
      mc.lineStyle(_level0.MoteurApi.style[styleId][0],_level0.MoteurApi.style[styleId][1],_level0.MoteurApi.style[styleId][2]);
      mc.beginFill(_level0.MoteurApi.style[styleId][3],_level0.MoteurApi.style[styleId][4]);
      mc.moveTo(repere.array[pts[0]].screenPos.x,- repere.array[pts[0]].screenPos.y);
      var i = 1;
      while(i < pts.length)
      {
         mc.lineTo(repere.array[pts[i]].screenPos.x,- repere.array[pts[i]].screenPos.y);
         i++;
      }
      mc.endFill();
   }
}
function apiStandardFillLineLocal(apiObj)
{
   with(apiObj)
   {
      mc.clear();
      mc.lineStyle(styleLocal[0],styleLocal[1],styleLocal[2]);
      mc.beginFill(styleLocal[3],styleLocal[4]);
      mc.moveTo(repere.array[pts[0]].screenPos.x,- repere.array[pts[0]].screenPos.y);
      var i = 1;
      while(i < pts.length)
      {
         mc.lineTo(repere.array[pts[i]].screenPos.x,- repere.array[pts[i]].screenPos.y);
         i++;
      }
      mc.endFill();
   }
}
function apiStandardFillCurve(apiObj)
{
   with(apiObj)
   {
      mc.clear();
      mc.lineStyle(_level0.MoteurApi.style[styleId][0],_level0.MoteurApi.style[styleId][1],_level0.MoteurApi.style[styleId][2]);
      mc.beginFill(_level0.MoteurApi.style[styleId][3],_level0.MoteurApi.style[styleId][4]);
      mc.moveTo(repere.array[pts[0]].screenPos.x,- repere.array[pts[0]].screenPos.y);
      var i = 1;
      while(i < pts.length)
      {
         mc.curveTo(repere.array[pts[i]].screenPos.x,- repere.array[pts[i]].screenPos.y,repere.array[pts[i + 1]].screenPos.x,- repere.array[pts[i + 1]].screenPos.y);
         i += 2;
      }
      mc.endFill();
   }
}
function apiStandardFillCurveLocal(apiObj)
{
   with(apiObj)
   {
      mc.clear();
      mc.lineStyle(styleLocal[0],styleLocal[1],styleLocal[2]);
      mc.beginFill(styleLocal[3],styleLocal[4]);
      mc.moveTo(repere.array[pts[0]].screenPos.x,- repere.array[pts[0]].screenPos.y);
      var i = 1;
      while(i < pts.length)
      {
         mc.curveTo(repere.array[pts[i]].screenPos.x,- repere.array[pts[i]].screenPos.y,repere.array[pts[i + 1]].screenPos.x,- repere.array[pts[i + 1]].screenPos.y);
         i += 2;
      }
      mc.endFill();
   }
}
function apiCercle(apiObj)
{
   with(apiObj)
   {
      mc.clear();
      mc.lineStyle(_level0.MoteurApi.style[styleId][0],_level0.MoteurApi.style[styleId][1],_level0.MoteurApi.style[styleId][2]);
      mc.beginFill(_level0.MoteurApi.style[styleId][3],_level0.MoteurApi.style[styleId][4]);
      mc.moveTo(repere.array[pts[0]].screenPos.x,- repere.array[pts[0]].screenPos.y);
      var i = 1;
      while(i < pts.length - 1)
      {
         mc.curveTo(repere.array[pts[i]].screenPos.x,- repere.array[pts[i]].screenPos.y,repere.array[pts[i + 1]].screenPos.x,- repere.array[pts[i + 1]].screenPos.y);
         i += 2;
      }
      mc.endFill();
   }
}
function apiCercleLocal(apiObj)
{
   with(apiObj)
   {
      mc.clear();
      mc.lineStyle(styleLocal[0],styleLocal[1],styleLocal[2]);
      mc.beginFill(styleLocal[3],styleLocal[4]);
      mc.moveTo(repere.array[pts[0]].screenPos.x,- repere.array[pts[0]].screenPos.y);
      var i = 1;
      while(i < pts.length - 1)
      {
         mc.curveTo(repere.array[pts[i]].screenPos.x,- repere.array[pts[i]].screenPos.y,repere.array[pts[i + 1]].screenPos.x,- repere.array[pts[i + 1]].screenPos.y);
         i += 2;
      }
      mc.endFill();
   }
}
function apiCercleCutted(apiObj)
{
   with(apiObj)
   {
      mc.clear();
      mc.lineStyle(_level0.MoteurApi.style[styleId][0],_level0.MoteurApi.style[styleId][1],_level0.MoteurApi.style[styleId][2]);
      mc.moveTo(repere.array[pts[0]].screenPos.x,- repere.array[pts[0]].screenPos.y);
      var i = 1;
      while(i < pts.length - 3)
      {
         mc.curveTo(repere.array[pts[i]].screenPos.x,- repere.array[pts[i]].screenPos.y,repere.array[pts[i + 1]].screenPos.x,- repere.array[pts[i + 1]].screenPos.y);
         i += 2;
      }
   }
}
function apiCercleCuttedLocal(apiObj)
{
   with(apiObj)
   {
      mc.clear();
      mc.lineStyle(styleLocal[0],styleLocal[1],styleLocal[2]);
      mc.moveTo(repere.array[pts[0]].screenPos.x,- repere.array[pts[0]].screenPos.y);
      var i = 1;
      while(i < pts.length - 3)
      {
         mc.curveTo(repere.array[pts[i]].screenPos.x,- repere.array[pts[i]].screenPos.y,repere.array[pts[i + 1]].screenPos.x,- repere.array[pts[i + 1]].screenPos.y);
         i += 2;
      }
   }
}
function apiLiaisonCerclePic(apiObj)
{
   with(apiObj)
   {
      mc.clear();
      mc.lineStyle(_level0.MoteurApi.style[styleId][0],_level0.MoteurApi.style[styleId][1],_level0.MoteurApi.style[styleId][2]);
      var inc = 0;
      var i = pts[1];
      while(i <= pts[1] + 3)
      {
         mc.moveTo(repere.array[pts[0] + inc].screenPos.x,- repere.array[pts[0] + inc].screenPos.y);
         mc.lineTo(repere.array[i].screenPos.x,- repere.array[i].screenPos.y);
         inc += 4;
         i++;
      }
   }
}
function apiLiaisonCerclePicLocal(apiObj)
{
   with(apiObj)
   {
      mc.clear();
      mc.lineStyle(styleLocal[0],styleLocal[1],styleLocal[2]);
      var inc = 0;
      var i = pts[1];
      while(i <= pts[1] + 3)
      {
         mc.moveTo(repere.array[pts[0] + inc].screenPos.x,- repere.array[pts[0] + inc].screenPos.y);
         mc.lineTo(repere.array[i].screenPos.x,- repere.array[i].screenPos.y);
         inc += 4;
         i++;
      }
   }
}
function apiLiaisonCylindre(apiObj)
{
   with(apiObj)
   {
      mc.clear();
      mc.lineStyle(_level0.MoteurApi.style[styleId][0],_level0.MoteurApi.style[styleId][1],_level0.MoteurApi.style[styleId][2]);
      var i = 0;
      while(i < pts[0].length)
      {
         mc.moveTo(repere.array[pts[0][i]].screenPos.x,- repere.array[pts[0][i]].screenPos.y);
         mc.lineTo(repere.array[pts[1][i]].screenPos.x,- repere.array[pts[1][i]].screenPos.y);
         i += 2;
      }
   }
}
function apiLiaisonCylindreLocal(apiObj)
{
   with(apiObj)
   {
      mc.clear();
      mc.lineStyle(styleLocal[0],styleLocal[1],styleLocal[2]);
      var i = 0;
      while(i < pts[0].length)
      {
         mc.moveTo(repere.array[pts[0][i]].screenPos.x,- repere.array[pts[0][i]].screenPos.y);
         mc.lineTo(repere.array[pts[1][i]].screenPos.x,- repere.array[pts[1][i]].screenPos.y);
         i += 2;
      }
   }
}
function apiEtoile(apiObj)
{
   with(apiObj)
   {
      var idInit = pts[1];
      var idC = pts[0];
      mc.clear();
      mc.lineStyle(_level0.MoteurApi.style[styleId][0],_level0.MoteurApi.style[styleId][1],_level0.MoteurApi.style[styleId][2]);
      mc.beginFill(_level0.MoteurApi.style[styleId][3],_level0.MoteurApi.style[styleId][4]);
      mc.moveTo(repere.array[idInit].screenPos.x,- repere.array[idInit].screenPos.y);
      mc.curveTo(repere.array[idC].screenPos.x,- repere.array[idC].screenPos.y,repere.array[idInit + 1].screenPos.x,- repere.array[idInit + 1].screenPos.y);
      mc.curveTo(repere.array[idC].screenPos.x,- repere.array[idC].screenPos.y,repere.array[idInit + 2].screenPos.x,- repere.array[idInit + 2].screenPos.y);
      mc.curveTo(repere.array[idC].screenPos.x,- repere.array[idC].screenPos.y,repere.array[idInit + 3].screenPos.x,- repere.array[idInit + 3].screenPos.y);
      mc.curveTo(repere.array[idC].screenPos.x,- repere.array[idC].screenPos.y,repere.array[idInit].screenPos.x,- repere.array[idInit].screenPos.y);
      mc.endFill();
   }
}
function apiEtoileLocal(apiObj)
{
   with(apiObj)
   {
      var idInit = pts[1];
      var idC = pts[0];
      mc.clear();
      mc.lineStyle(styleLocal[0],styleLocal[1],styleLocal[2]);
      mc.beginFill(styleLocal[3],styleLocal[4]);
      mc.moveTo(repere.array[idInit].screenPos.x,- repere.array[idInit].screenPos.y);
      mc.curveTo(repere.array[idC].screenPos.x,- repere.array[idC].screenPos.y,repere.array[idInit + 1].screenPos.x,- repere.array[idInit + 1].screenPos.y);
      mc.curveTo(repere.array[idC].screenPos.x,- repere.array[idC].screenPos.y,repere.array[idInit + 2].screenPos.x,- repere.array[idInit + 2].screenPos.y);
      mc.curveTo(repere.array[idC].screenPos.x,- repere.array[idC].screenPos.y,repere.array[idInit + 3].screenPos.x,- repere.array[idInit + 3].screenPos.y);
      mc.curveTo(repere.array[idC].screenPos.x,- repere.array[idC].screenPos.y,repere.array[idInit].screenPos.x,- repere.array[idInit].screenPos.y);
      mc.endFill();
   }
}
function apiCube(apiObj)
{
   with(apiObj)
   {
      var id = pts[0];
      mc.clear();
      mc.lineStyle(_level0.MoteurApi.style[styleId][0],_level0.MoteurApi.style[styleId][1],_level0.MoteurApi.style[styleId][2]);
      mc.beginFill(_level0.MoteurApi.style[styleId][3],_level0.MoteurApi.style[styleId][4]);
      mc.drawQuad(repere.array[id].screenPos,repere.array[id + 1].screenPos,repere.array[id + 2].screenPos,repere.array[id + 3].screenPos);
      mc.endFill();
      mc.beginFill(_level0.MoteurApi.style[styleId][3],_level0.MoteurApi.style[styleId][4]);
      mc.drawQuad(repere.array[id + 4].screenPos,repere.array[id + 5].screenPos,repere.array[id + 6].screenPos,repere.array[id + 7].screenPos);
      mc.endFill();
      mc.beginFill(_level0.MoteurApi.style[styleId][3],_level0.MoteurApi.style[styleId][4]);
      mc.drawQuad(repere.array[id].screenPos,repere.array[id + 4].screenPos,repere.array[id + 7].screenPos,repere.array[id + 3].screenPos);
      mc.endFill();
      mc.beginFill(_level0.MoteurApi.style[styleId][3],_level0.MoteurApi.style[styleId][4]);
      mc.drawQuad(repere.array[id + 1].screenPos,repere.array[id + 5].screenPos,repere.array[id + 6].screenPos,repere.array[id + 2].screenPos);
      mc.endFill();
      mc.beginFill(_level0.MoteurApi.style[styleId][3],_level0.MoteurApi.style[styleId][4]);
      mc.drawQuad(repere.array[id].screenPos,repere.array[id + 1].screenPos,repere.array[id + 5].screenPos,repere.array[id + 4].screenPos);
      mc.endFill();
      mc.beginFill(_level0.MoteurApi.style[styleId][3],_level0.MoteurApi.style[styleId][4]);
      mc.drawQuad(repere.array[id + 3].screenPos,repere.array[id + 2].screenPos,repere.array[id + 6].screenPos,repere.array[id + 7].screenPos);
      mc.endFill();
   }
}
function apiCubeLocal(apiObj)
{
   with(apiObj)
   {
      var id = pts[0];
      mc.clear();
      mc.lineStyle(styleLocal[0],styleLocal[1],styleLocal[2]);
      mc.beginFill(styleLocal[3],styleLocal[4]);
      mc.drawQuad(repere.array[id].screenPos,repere.array[id + 1].screenPos,repere.array[id + 2].screenPos,repere.array[id + 3].screenPos);
      mc.endFill();
      mc.beginFill(styleLocal[3],styleLocal[4]);
      mc.drawQuad(repere.array[id + 4].screenPos,repere.array[id + 5].screenPos,repere.array[id + 6].screenPos,repere.array[id + 7].screenPos);
      mc.endFill();
      mc.beginFill(styleLocal[3],styleLocal[4]);
      mc.drawQuad(repere.array[id].screenPos,repere.array[id + 4].screenPos,repere.array[id + 7].screenPos,repere.array[id + 3].screenPos);
      mc.endFill();
      mc.beginFill(styleLocal[3],styleLocal[4]);
      mc.drawQuad(repere.array[id + 1].screenPos,repere.array[id + 5].screenPos,repere.array[id + 6].screenPos,repere.array[id + 2].screenPos);
      mc.endFill();
      mc.beginFill(styleLocal[3],styleLocal[4]);
      mc.drawQuad(repere.array[id].screenPos,repere.array[id + 1].screenPos,repere.array[id + 5].screenPos,repere.array[id + 4].screenPos);
      mc.endFill();
      mc.beginFill(styleLocal[3],styleLocal[4]);
      mc.drawQuad(repere.array[id + 3].screenPos,repere.array[id + 2].screenPos,repere.array[id + 6].screenPos,repere.array[id + 7].screenPos);
      mc.endFill();
   }
}
stop();
_level0.createEmptyMovieClip("MoteurApi",-41554);
_level0.MoteurApi.apiOn = new Array();
_level0.MoteurApi.apiOff = new Array();
_level0.MoteurApi.style = new Array();
_level0.MoteurApi.style[0] = [1,"0x3E4A4D",40,"0xD3D6D6",20];
_level0.MoteurApi.style[1] = [1,"0x3E4A4D",50,"0x4E5E61",10];
_level0.MoteurApi.style[2] = [1,"0x16343F",50,"0xFFFFFF",20];
_level0.MoteurApi.onEnterFrame = function()
{
   with(_level0.MoteurApi)
   {
      for(ClipCourant in apiOn)
      {
         apiOn[ClipCourant].fonction(apiOn[ClipCourant]);
      }
   }
};
MovieClip.prototype.createApi = function(repere, pts, nom, argStyleId, typeObjet, etat, methode)
{
   var _loc1_ = new Object();
   _loc1_.mc = this;
   _loc1_.repere = repere;
   _loc1_.pts = pts;
   _loc1_.name = nom;
   _loc1_.styleId = argStyleId;
   _loc1_.styleLocal = new Array();
   _loc1_.styleMethode = methode;
   _loc1_.typeObjet = typeObjet;
   _loc1_.etat = etat;
   _loc1_.fonction = typageFonction(typeObjet,methode);
   if(etat)
   {
      _level0.MoteurApi.apiOn[_loc1_.name] = _loc1_;
   }
   else
   {
      _level0.MoteurApi.apiOff[_loc1_.name] = _loc1_;
   }
};
MovieClip.prototype.drawQuad = function(p1, p2, p3, p4)
{
   with(this)
   {
      moveTo(p1.x,- p1.y);
      lineTo(p2.x,- p2.y);
      lineTo(p3.x,- p3.y);
      lineTo(p4.x,- p4.y);
      lineTo(p1.x,- p1.y);
   }
};
