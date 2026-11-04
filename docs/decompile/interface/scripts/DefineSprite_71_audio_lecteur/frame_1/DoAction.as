function activeLecteur()
{
   this.chargePiste();
   _root.multimedia.mcAudio.audio_indicateur.activeIndicateur();
   this.volume_mc._alpha = 100;
   this.play_bt._alpha = 100;
   this.play_bt.onRollOver = function()
   {
      this._xscale = 120;
      this._yscale = 120;
   };
   this.play_bt.onRollOut = function()
   {
      this._xscale = 100;
      this._yscale = 100;
   };
   this.play_bt.onRelease = function()
   {
      var _loc1_ = this;
      _loc1_.gotoAndStop(2);
      _loc1_._parent.pause_bt.gotoAndStop(1);
      _loc1_._parent.stop_bt.gotoAndStop(1);
      _loc1_._parent.piste.start(_loc1_._parent.positionActuel);
   };
   this.pause_bt._alpha = 100;
   this.pause_bt.onRollOver = function()
   {
      this._xscale = 120;
      this._yscale = 120;
   };
   this.pause_bt.onRollOut = function()
   {
      this._xscale = 100;
      this._yscale = 100;
   };
   this.pause_bt.onRelease = function()
   {
      var _loc1_ = this;
      _loc1_.gotoAndStop(2);
      _loc1_._parent.play_bt.gotoAndStop(1);
      _loc1_._parent.stop_bt.gotoAndStop(1);
      _loc1_._parent.positionActuel = Math.floor(_loc1_._parent.piste.position) / 1000;
      _loc1_._parent.piste.stop();
   };
   this.stop_bt._alpha = 100;
   this.stop_bt.onRollOver = function()
   {
      this._xscale = 120;
      this._yscale = 120;
   };
   this.stop_bt.onRollOut = function()
   {
      this._xscale = 100;
      this._yscale = 100;
   };
   this.stop_bt.onRelease = function()
   {
      var _loc1_ = this;
      _loc1_.gotoAndStop(2);
      _loc1_._parent.pause_bt.gotoAndStop(1);
      _loc1_._parent.play_bt.gotoAndStop(1);
      _loc1_._parent.piste.stop();
      _loc1_._parent.positionActuel = 0;
   };
   this.plus_bt._alpha = 100;
   this.plus_bt.onRollOver = function()
   {
      this._xscale = 120;
      this._yscale = 120;
   };
   this.plus_bt.onRollOut = function()
   {
      this._xscale = 100;
      this._yscale = 100;
   };
   this.plus_bt.onRelease = function()
   {
      with(this._parent)
      {
         piste.setVolume(Math.min(piste.getVolume() + volInc,volMax));
         volume_mc.vol_txt.text = piste.getVolume();
      }
   };
   this.moins_bt._alpha = 100;
   this.moins_bt.onRollOver = function()
   {
      this._xscale = 120;
      this._yscale = 120;
   };
   this.moins_bt.onRollOut = function()
   {
      this._xscale = 100;
      this._yscale = 100;
   };
   this.moins_bt.onRelease = function()
   {
      with(this._parent)
      {
         piste.setVolume(Math.max(piste.getVolume() - volInc,volMin));
         volume_mc.vol_txt.text = piste.getVolume();
      }
   };
}
function deactiveLecteur()
{
   var _loc1_ = this;
   _loc1_.play_bt._alpha = 30;
   _loc1_.pause_bt._alpha = 30;
   _loc1_.stop_bt._alpha = 30;
   _loc1_.plus_bt._alpha = 30;
   _loc1_.moins_bt._alpha = 30;
   _loc1_.volume_mc._alpha = 30;
   delete _loc1_.play_bt.onRollOver;
   delete _loc1_.play_bt.onRollOut;
   delete _loc1_.play_bt.onRelease;
   delete _loc1_.pause_bt.onRollOver;
   delete _loc1_.pause_bt.onRollOut;
   delete _loc1_.pause_bt.onRelease;
   delete _loc1_.stop_bt.onRollOver;
   delete _loc1_.stop_bt.onRollOut;
   delete _loc1_.stop_bt.onRelease;
   delete _loc1_.plus_bt.onRollOver;
   delete _loc1_.plus_bt.onRollOut;
   delete _loc1_.plus_bt.onRelease;
   delete _loc1_.moins_bt.onRollOver;
   delete _loc1_.moins_bt.onRollOut;
   delete _loc1_.moins_bt.onRelease;
}
MovieClip.prototype.chargePiste = function()
{
   var _loc1_ = _global;
   var _loc2_ = this;
   _loc2_.piste = new Sound();
   var _loc3_ = "externdata/audio/" + _loc1_.data_audio[_loc1_.idAudioInPlay].Fichier + ".mp3";
   _loc2_.piste.loadSound(_loc3_,true);
   _loc2_.play_bt.gotoAndStop(2);
   _loc2_.piste.onSoundComplete = function()
   {
      var _loc1_ = _global;
      if(_loc1_.idAudioInPlay == _loc1_.data_audio.length - 1)
      {
         _loc1_.idAudioInPlay = 0;
      }
      else
      {
         _loc1_.idAudioInPlay += 1;
      }
      activeLecteur();
   };
};
