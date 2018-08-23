<?php
require_once '../conexion.php';
//session_start();
//if(!isset($_SESSION['id_operador'])){
//   header("location: ../index.php");
//}
   $con = conexionBD();
   if(!$con) exit(1);

   $id_emergencia = $_GET['id_emergencia'];
   $observacion = $_GET['observacion'];

   $query = "SELECT *from emergencia WHERE id_emergencia = $id_emergencia";   
   $emergencia = pg_query($con, $query);
   $row = pg_fetch_assoc($emergencia);

   //$query2 = "INSERT INTO historial(lat,lng,nivel,fechahora,fechacompletado,observacion,id_auto,id_operador,id_hospital)";

   $query2 = "INSERT INTO historial(lat,lng,nivel,fechahora,fechacompletado,observacion,id_usuario,id_operador) VALUES($row[lat],$row[lng],$row[nivel],'$row[fechahora]',CURRENT_TIMESTAMP,'$observacion',$row[id_usuario],$row[id_operador])";
   pg_query($con, $query2);

   $query = "DELETE FROM emergencia WHERE id_emergencia = $id_emergencia";
   pg_query($con, $query);

   pg_free_result($emergencia);
   pg_close($con);

   echo  json_encode("ok");
?>

