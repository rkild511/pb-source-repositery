<?php
// *********************************************************
// *********************************************************
// *********************************************************

$vars_coid  = '';
$vars_mysql = '';
$vars_users = '';
$vars_temps = '';
$vars_array = array();
$vars_errs  = false;

define('URL_REPS', '../upload/sources/');

// *********************************************************
// *********************************************************
// *********************************************************

//if (!isset($_SESSION['thothbox']))
//{
	session_start();
	$vars_len = 40;
	$vars_let = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
	srand(time());
	for ($i=0; $i<$vars_len; $i++)
	{
		$vars_coid.= substr($vars_let,(rand()%(strlen($vars_let))),1);
	}
	session_register('thothbox');
	$_SESSION['thothbox'] = $vars_coid;
//}
//else
//{
//	$vars_coid = $_SESSION['thothbox'];
//}

// *********************************************************
// *********************************************************
// *********************************************************

if ($_SERVER['HTTP_USER_AGENT'] != 'ThothBox')
{
	echo "forbidden";
	exit();
}

// *********************************************************
// *********************************************************
// *********************************************************

$server['version'] = '0.1';
$server['server']  = 'http://'.$_SERVER['SERVER_NAME'].$_SERVER['PHP_SELF'];
$server['message'] = 'Welcome to The official ThothBox server';

if (isset($_POST['info']))
{
	foreach ($server as $key=>$value)
	{
		echo $key.' : '.$value."\n\r";
	}
	exit();
}

// *********************************************************
// *********************************************************
// *********************************************************

if (file_exists('include_bde.php'))
{
	require_once('include_bde.php');
}
else
{
	$vars_errs = true;
}

// *********************************************************
// *********************************************************
// *********************************************************

function number_pad($number, $n)
{
	return str_pad((int) $number, $n, "0", STR_PAD_LEFT);
}

Function setSpecialChar($chaine)
{
	$string = strtolower($chaine);
	$string = strtr($string," ÀÁÂÃÄÅàáâãäåÒÓÔÕÖØòóôõöøÈÉÊËèéêëÇçÌÍÎÏìíîïÙÚÛÜùúûüÿÑñ","_aaaaaaaaaaaaooooooooooooeeeeeeeecciiiiiiiiuuuuuuuuynn");
	return $string;
}

function setOpenZipFile($vars_file, $vars_code)
{
	$i			= 0;
	$vars_array = array();
	$zip 		= @zip_open($vars_file);
	if ($zip)
	{
		echo 'id;filename;filesize;md5'."\n\r";
		while ($zip_entry = zip_read($zip))
		{
			if (zip_entry_filesize($zip_entry)>0)
			{
				$i++;
				$vars_array = unzip($vars_file, $i);
				echo $i.';'.zip_entry_name($zip_entry).';'.zip_entry_filesize($zip_entry).';'.md5($vars_array[1])."\n\r";
			}
		}
		zip_close($zip);
	}
}

function unzip($vars_file, $vars_fnum)
{
	$i         = 0;
	$vars_flen = 0;
	$vars_name = '';
	$vars_resu = '';
	$zip       = zip_open($vars_file);
	if ($zip)
	{
		while ($zip_entry = zip_read($zip))
		{
			if (zip_entry_filesize($zip_entry) > 0)
			{
				$i++;
				if ($i == $vars_fnum)
				{
					if (zip_entry_open($zip, $zip_entry, "r"))
					{
						$vars_name = zip_entry_name($zip_entry);
						$vars_flen = zip_entry_filesize($zip_entry);
						$vars_resu = zip_entry_read($zip_entry, zip_entry_filesize($zip_entry));
						zip_entry_close($zip_entry);
					}
				}
			}
		}
		zip_close($zip);
	}
	return array($vars_name, $vars_resu, $vars_flen);
}

// *********************************************************
// *********************************************************
// *********************************************************

$vars_user = (isset($_POST ['user'])  ? $_POST['user']   : NULL);
$vars_file = (isset($_POST ['file'])  ? $_POST['file']   : NULL);
$vars_code = (isset($_POST['code'])   ? $_POST['code']   : NULL);
$vars_find = (isset($_POST['search']) ? $_POST['search'] : NULL);

// *********************************************************
// *********************************************************
// *********************************************************

if ($vars_errs != true)
{
	if ($vars_user=='id')
	{
		echo $vars_coid;
		exit();
	}
	$db_connect = mysql_connect($_MYSQL_SERVER, $_MYSQL_USER, $_MYSQL_PASS);
	if($db_connect && $vars_coid)
	{
		//
		// AFFICHE LES 10 DERNIERS FICHIERS SOURCES.
		//
		if (!$vars_find && !$vars_code && !$vars_file)
		{
			$db_query = mysql_db_query($_MYSQL_BDE, 'SELECT * FROM code_sourcecode ORDER BY id DESC LIMIT 10', $db_connect);
			$db_count = mysql_num_rows($db_query);
			if ($db_count != 0)
			{
				$vars_users = mysql_result($db_query, 0, 'strUser');
				if ($vars_users)
				{
					$db_querb = @mysql_db_query($_MYSQL_BDE,"SELECT username FROM kod_members WHERE id='$vars_users'",$db_connect);
					$db_counb = @mysql_num_rows($db_querb);
					$vars_users = NULL;
					if ($db_counb) {
						$vars_users = mysql_result($db_querb, 0, 'username');
						mysql_free_result($db_querb);
					}
				}
				echo 'id;codename;author;date;category;compatibility'."\n\r";
				for ($i=0; $i<$db_count; $i++)
				{
					echo mysql_result($db_query, $i, 'id').';'.stripslashes(mysql_result($db_query, $i, 'strName')).';'.$vars_users.';'.mysql_result($db_query, $i, 'datDate').';'.mysql_result($db_query, $i, 'strCategory').';'.mysql_result($db_query, $i, 'strVerOS')."\n\r";
				}
				mysql_free_result($db_query);
			}
			exit();
		}
		//
		// AFFICHE LE RESULTAT DE LA RECHERCHE.
		//
		if ($vars_find)
		{
			$vars_temps = explode(' ', $vars_find);
			for($i=0; $i<sizeof($vars_temps); $i++)
			{
				if ($vars_temps[$i]) {
					if ($i>0) {
						$vars_mysql.= ' OR ';
					}
					$vars_mysql.= "strName LIKE '%".$vars_temps[$i]."%'";
					$vars_mysql.= "OR strComment LIKE '%".$vars_temps[$i]."%'";
					$vars_mysql.= "OR strTerminat LIKE '%".$vars_temps[$i]."%'";
				}
			}
			$db_query = mysql_db_query($_MYSQL_BDE, 'SELECT * FROM code_sourcecode WHERE '.$vars_mysql.' ORDER BY id DESC', $db_connect);
			$db_count = mysql_num_rows($db_query);
			if ($db_count != 0)
			{
				$vars_users = mysql_result($db_query, 0, 'strUser');
				if ($vars_users)
				{
					$db_querb = @mysql_db_query($_MYSQL_BDE,"SELECT username FROM kod_members WHERE id='$vars_users'",$db_connect);
					$db_counb = @mysql_num_rows($db_querb);
					$vars_users = NULL;
					if ($db_counb) {
						$vars_users = mysql_result($db_querb, 0, 'username');
						mysql_free_result($db_querb);
					}
				}
				echo 'id;codename;author;date;category'."\n\r";
				for ($i=0; $i<$db_count; $i++)
				{
					echo mysql_result($db_query, $i, 'id').';'.stripslashes(mysql_result($db_query, $i, 'strName')).';'.$vars_users.';'.mysql_result($db_query, $i, 'datDate').';'.mysql_result($db_query, $i, 'strCategory').';'.mysql_result($db_query, $i, 'strVerOS')."\n\r";
				}
				mysql_free_result($db_query);
			}
			exit();
		}
		//
		// AFFICHE LES FICHIERS DU ZIP.
		//
		if ($vars_code && !$vars_file)
		{
			$db_query = mysql_db_query($_MYSQL_BDE, 'SELECT * FROM code_sourcecode WHERE id='.$vars_code, $db_connect);
			$db_count = mysql_num_rows($db_query);
			if ($db_count != 0)
			{
				$vars_users = mysql_result($db_query, 0, 'strUser');
				if ($vars_users)
				{
					$db_querb = @mysql_db_query($_MYSQL_BDE,"SELECT username FROM kod_members WHERE id='$vars_users'",$db_connect);
					$db_counb = @mysql_num_rows($db_querb);
					$vars_users = NULL;
					if ($db_counb) {
						$vars_users = mysql_result($db_querb, 0, 'username');
						mysql_free_result($db_querb);
					}
				}
				$vars_temps = URL_REPS.strtolower($vars_users).'_sourcepb_'.number_pad(mysql_result($db_query, 0, 'id'), 5).'.zip';
				if (file_exists($vars_temps))
				{
					setOpenZipFile($vars_temps, $vars_code);
				}
				else
				{
					//$vars_temps = stripslashes(mysql_result($db_query, 0, 'strName'));
					$vars_temps = stripslashes(mysql_result($db_query, 0, 'strSource'));
					echo 'id;filename;filesize;md5'."\n\r";
					echo '-1;main.pb;'.strlen(stripslashes(mysql_result($db_query, 0, 'strSource'))).';'.md5($vars_temps)."\n\r";
				}
				mysql_free_result($db_query);
			}
			exit();
		}
		//
		// EXTRAIS LE FICHIER DU ZIP OU BASE.
		//
		if ($vars_code && $vars_file)
		{
			$db_query = mysql_db_query($_MYSQL_BDE, 'SELECT * FROM code_sourcecode WHERE id='.$vars_code, $db_connect);
			$db_count = mysql_num_rows($db_query);
			if ($db_count != 0)
			{
				$vars_users = mysql_result($db_query, 0, 'strUser');
				if ($vars_users)
				{
					$db_querb = @mysql_db_query($_MYSQL_BDE,"SELECT username FROM kod_members WHERE id='$vars_users'",$db_connect);
					$db_counb = @mysql_num_rows($db_querb);
					$vars_users = NULL;
					if ($db_counb) {
						$vars_users = mysql_result($db_querb, 0, 'username');
						mysql_free_result($db_querb);
					}
				}
				if ($vars_file != -1)
				{
					$vars_temps = URL_REPS.strtolower($vars_users).'_sourcepb_'.number_pad(mysql_result($db_query, 0, 'id'), 5).'.zip';
					$vars_array = unzip($vars_temps, $vars_file);
					if ($vars_array[0] && $vars_array[1])
					{
						header('Content-Description: File Transfer');
						header('Content-Tranfer-Encoding: none');
						header('Content-Length: '.$vars_array[2]);
						header('Content-Type: application/force-download; name="'.basename(setSpecialChar($vars_array[0])).'"');
						header('Content-Disposition: attachment; filename="'.basename(setSpecialChar($vars_array[0])).'"');
						echo $vars_array[1];
					}
					mysql_free_result($db_query);
					exit();
				}
				else
				{
					$vars_temps = mysql_result($db_query, 0, 'strName');
					header('Content-Description: File Transfer');
					header('Content-Tranfer-Encoding: none');
					header('Content-Length: '.strlen(mysql_result($db_query, 0, 'strSource')));
					header('Content-Type: application/octet-stream; name="'.setSpecialChar(stripslashes($vars_temps)).'.pb"');
					header('Content-Disposition: attachment; filename="'.setSpecialChar(stripslashes($vars_temps)).'.pb"');
					echo stripslashes(mysql_result($db_query, 0, 'strSource'));
					mysql_free_result($db_query);
					exit();
				}
			}
			exit();
		}
	}
}
?>