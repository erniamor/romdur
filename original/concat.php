



<?php

require ("parse.php") ; // on appelle la fonction parse pour la déclarer


$db = mysql_connect('localhost', 'UTILISATEUR', 'MOT_DE_PASSE') /* identifiants retirés pour la publication */;
mysql_select_db('romdur_option',$db);

$req = mysql_query("SELECT id,nom,pseudo,config,date FROM style ORDER BY style.date") or die('FATAL ERROR SQL !<br>'.$sqltot.'<br>'.mysql_error());
$data_option = '';
while($data = mysql_fetch_array($req))
{
$data_option .= $data['id'].'|'.$data['nom'].'|'.$data['pseudo'].'|'.$data['config'].'|'.$data['date'].'§';
}


 
Parse("data_option", $data_option);




mysql_close();
?>