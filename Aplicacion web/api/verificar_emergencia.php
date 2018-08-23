<?php
require_once '../conexion.php';
session_start();
if(!isset($_SESSION['id_operador'])){
   header("location: ../index.php");
}
?>
<?php
   $con = conexionBD();
   if(!$con) exit(1);
   $id_operador = $_SESSION['id_operador'];
   $query = "select id_emergencia from emergencia where id_operador = $id_operador and emergencia_vista = 'f' limit 1";
   $usuarios = pg_query($con, $query);
   $usuario = pg_fetch_assoc($usuarios);
   $id_emergencia = $usuario['id_emergencia']; 
   $res= array('id_emergencia' => $id_emergencia);
   
   $query = "update emergencia set emergencia_vista = 't' where id_emergencia = $id_emergencia";
   pg_query($con, $query);

   pg_free_result($usuarios);
   pg_close($con);

   echo json_encode($res);
?>

