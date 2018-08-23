<?php
require_once '../conexion.php';
session_start();
if(!isset($_SESSION['id_operador'])){
   header("location: ../index.php");
}
   $con = conexionBD();
   if(!$con) exit(1);
   $id_operador = $_SESSION['id_operador'];

   $query = "select em.id_emergencia,em.lat,em.lng,em.nivel,em.id_operador,em.id_hospital,em.observacion,us.nombres,us.apellidos,us.id_usuario from emergencia as em inner join usuario as us on em.id_usuario = us.id_usuario where em.id_operador = $id_operador and emergencia_vista = 't' order by em.id_emergencia";
   $emergencias = pg_query($con, $query);
   $res= array();

   while ($row = pg_fetch_assoc($emergencias)) {
      array_push($res, array('id_emergencia'=>$row['id_emergencia'],'lat'=>$row['lat'],'lng'=>$row['lng'],'nivel'=>$row['nivel'],'id_operador'=>$row['id_operador'],'id_hospital'=>$row['id_hospital'],'observacion'=>$row['observacion'],'id_usuario'=>$row['id_usuario'],'nombres'=>$row['nombres'],'apellidos'=>$row['apellidos']));
   }

   pg_free_result($emergencias);
   pg_close($con);

   echo json_encode($res);
?>

