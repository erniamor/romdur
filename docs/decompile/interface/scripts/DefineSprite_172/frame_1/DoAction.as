function update()
{
   with(this)
   {
      clear();
      lineStyle(1,"0x000000",0);
      colors = _global.colorDegrade;
      alphas = [100,100];
      ratios = [0,255];
      matrix = {matrixType:"box",x:-250,y:-250,w:500,h:500,r:1};
      beginGradientFill("radial",colors,alphas,ratios,matrix);
      moveto(-490,-365);
      lineto(490,-365);
      lineto(490,365);
      lineto(-490,365);
      lineto(-490,-365);
      endFill();
   }
}
stop();
_global.colorDegrade = [13421772,11513775];
update();
