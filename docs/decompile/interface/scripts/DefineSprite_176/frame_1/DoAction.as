stop();
this.contact_txt.embedFonts = true;
this.contact_txt.textColor = "0x181731";
this.onRollOver = function()
{
   this.contact_txt.textColor = "0x494996";
   _global.snd_glob_contact.stop();
   _global.snd_glob_contact.start();
};
this.onRollOut = function()
{
   this.contact_txt.textColor = "0x181731";
};
this.onRelease = function()
{
   getURL("mailto:contact@romdur.com");
};
