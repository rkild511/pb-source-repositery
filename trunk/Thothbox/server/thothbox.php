<?php
session_start();
//Server Version
$server['version']="0.1";
//Change this line if you want to move client to another server
$server['server']="http://".$_SERVER['SERVER_NAME'].$_SERVER['PHP_SELF'];
//If you want to display a message on the client !
$server['message']="Welcome to The official ThothBox server";

//Only ThothBox can use this server
if  ($_SERVER['HTTP_USER_AGENT']!="ThothBox") {
	echo "forbidden";
	exit();
}

// Send Server Info
if (isset($_POST['info'])) {
	foreach ($server as $key=>$value) {
	echo "$key : $value\n\r";
	}
	exit();
}

// Send Server Info
if (isset($_POST['search'])) {
	//foreach ($server as $key=>$value) {
	//echo "$key : $value\n\r";
	//}
	exit();
}

?>