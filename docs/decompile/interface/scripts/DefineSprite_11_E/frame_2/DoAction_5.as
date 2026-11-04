stop();
var i = 0;
while(i < univers.array.length)
{
   var end = new vector3d(0,0,900);
   univers.array[i].position.x = end.x;
   univers.array[i].position.y = end.y;
   univers.array[i].position.z = end.z;
   univers.array[i].render();
   i++;
}
_global.colorAccueil = false;
this.activeBT(false);
if(_global.firstEnter)
{
   introAccueil();
   _global.firstEnter = false;
}
else
{
   var choix = random(100);
   if(choix >= 96)
   {
      retourAccueil_v0();
   }
   else
   {
      retourAccueil_v1();
   }
}
