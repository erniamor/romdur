<?
$nom=$_POST["var0"];
$pseudo=$_POST["var1"];
$config=$_POST["var2"];
//
$db=mysql_connect('localhost', 'UTILISATEUR', 'MOT_DE_PASSE') /* identifiants retirés pour la publication */;
mysql_select_db('romdur_option',$db);


$sql="INSERT INTO style(id,nom,pseudo,config,date) VALUES ('','$nom', '$pseudo', '$config', NOW())";
mysql_query($sql);


mysql_close();
?>