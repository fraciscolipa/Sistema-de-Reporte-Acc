<?php
function conexionBD(){
	$con = pg_pconnect("host=localhost port=5432 dbname=pablo user=pablo password=pablo");
	return $con;
}
?>
