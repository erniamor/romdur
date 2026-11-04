degrade.setMask(mask);
this.onRollOver = function()
{
   var _loc1_ = this;
   _loc1_._parent.shakeXBt(_loc1_.id);
   _global.snd_menu_bt.start();
   _loc1_.degrade._x = -50;
   _loc1_.onEnterFrame = function()
   {
      var _loc1_ = this;
      _loc1_.degrade._x += 22;
      if(_loc1_.degrade._x >= 250)
      {
         delete _loc1_.onEnterFrame;
      }
   };
};
stop();
this.onPress = function()
{
   var _loc1_ = _root;
   var _loc2_ = this;
   if(_loc2_.id == 19)
   {
      _loc2_._parent.sortieAccueil(function()
      {
         var _loc1_ = _root;
         _loc1_.attachMovie("cv","cv",11);
         _loc1_.cv._x = 490;
         _loc1_.cv._y = 365;
      }
      );
   }
   else if(_loc2_.id == 20)
   {
      _loc2_._parent.sortieAccueil(function()
      {
         var _loc1_ = _root;
         _loc1_.attachMovie("multimedia","multimedia",12);
         _loc1_.multimedia._x = 490;
         _loc1_.multimedia._y = 365;
      }
      );
   }
   else if(_loc2_.id == 21)
   {
      _loc2_._parent.sortieAccueil(function()
      {
         var _loc1_ = _root;
         _loc1_.attachMovie("lien","lien",13);
         _loc1_.lien._x = 490;
         _loc1_.lien._y = 365;
      }
      );
   }
   else
   {
      _loc2_._parent.sortieAccueil(function()
      {
         var _loc1_ = _root;
         _loc1_.attachMovie("info","info",14);
         _loc1_.info._x = 490;
         _loc1_.info._y = 365;
      }
      );
   }
};
BT_txt.embedFonts = true;
