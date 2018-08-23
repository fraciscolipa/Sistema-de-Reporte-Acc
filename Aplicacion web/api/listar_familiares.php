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

   $id_usuario = $_GET['id_usuario'];
   $query = "SELECT telefono,nombres_contacto,apellidos_contacto,relacion FROM usuario_telefono WHERE id_usuario = $id_usuario";
   $familia = pg_query($con, $query);
   $res= array();

   while ($row = pg_fetch_assoc($familia)) {
      array_push($res, array('telefono'=>$row['telefono'],'nombres'=>$row['nombres_contacto'],'apellidos'=>$row['apellidos_contacto'],'relacion'=>$row['relacion']));
   }

   pg_free_result($familia);
   pg_close($con);
   echo json_encode($res);

?>



