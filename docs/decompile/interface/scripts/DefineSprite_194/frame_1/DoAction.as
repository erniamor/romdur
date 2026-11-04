function initPreset()
{
   var _loc1_ = _global;
   _loc1_.presetPageActu = 0;
   _loc1_.presetPageTotal = Math.ceil(_loc1_.dataOption.length / 6);
   actuPreset(_loc1_.presetPageActu);
}
function actuPreset(idPage)
{
   var _loc2_ = this;
   var _loc3_ = _global;
   _loc2_.page_txt.text = _loc3_.presetPageActu + 1 + " / " + _loc3_.presetPageTotal;
   var posYinit = 20;
   var decalY = 15;
   _loc2_.createEmptyMovieClip("presetList",222223);
   var iInit = idPage * 6;
   var iEnd = _loc3_.presetPageTotal != _loc3_.presetPageActu + 1 ? idPage * 6 + 6 : _loc3_.dataOption.length;
   var _loc1_ = iInit;
   while(_loc1_ < iEnd)
   {
      _loc2_.presetList.attachMovie("presetListBt","presetListBt" + _loc1_,_loc1_);
      _loc2_.presetList["presetListBt" + _loc1_]._txt.text = _loc3_.dataOption[_loc1_].nom;
      _loc2_.presetList["presetListBt" + _loc1_].id = _loc1_;
      _loc2_.presetList["presetListBt" + _loc1_]._x = 0;
      _loc2_.presetList["presetListBt" + _loc1_]._y = posYinit;
      posYinit += decalY;
      _loc1_ = _loc1_ + 1;
   }
   if(_loc3_.presetPageActu == 0)
   {
      desactivePrev();
   }
   else
   {
      activePrev();
   }
   if(_loc3_.presetPageTotal == _loc3_.presetPageActu + 1)
   {
      desactiveNext();
   }
   else
   {
      activeNext();
   }
}
function activePrev()
{
   var _loc1_ = this;
   _loc1_.presetPrevPage_btn.gotoAndStop(3);
   _loc1_.presetPrevPage_btn.onRelease = function()
   {
      _global.presetPageActu -= 1;
      this._parent.actuPreset(_global.presetPageActu);
   };
}
function desactivePrev()
{
   this.presetPrevPage_btn.gotoAndStop(2);
   delete this.presetPrevPage_btn.onRelease;
}
function activeNext()
{
   var _loc1_ = this;
   _loc1_.presetNextPage_btn.gotoAndStop(3);
   _loc1_.presetNextPage_btn.onRelease = function()
   {
      _global.presetPageActu += 1;
      this._parent.actuPreset(_global.presetPageActu);
   };
}
function desactiveNext()
{
   this.presetNextPage_btn.gotoAndStop(2);
   delete this.presetNextPage_btn.onRelease;
}
this.page_txt.embedFonts = true;
