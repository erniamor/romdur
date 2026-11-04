<?
   // Fonction pour parser les variables vers FLASH
   function Parse($variable,$valeur) {
       echo "&" . $variable . "=" . utf8_encode(urlencode($valeur));
   }
?>
