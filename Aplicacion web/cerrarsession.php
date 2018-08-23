<?php
   require_once 'conexion.php';
   session_start();

   $con = conexionBD();
   if(!$con) exit(1);

   $query = "update operador set activo = 'f' where id_operador = $_SESSION[id_operador]";
   pg_query($con, $query);
   pg_close($con);

   if(session_destroy()) {
    header("Location: index.php");
    }
?>