<?php
require_once 'conexion.php';
session_start();
if(!isset($_SESSION['id_operador'])){
   header("location: index.php");
}
?>
<!DOCTYPE html>
<html>
<head>
      <title>Bienvenido Operador</title>
      <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
      <link rel="stylesheet" type="text/css" href="css/styles.css">
      <script type="text/javascript" src="js/jquery-3.2.1.min.js"></script>
      <script type="text/javascript" src="js/consultas.js"></script>
      

      <style>
      /* Always set the map height explicitly to define the size of the div
       * element that contains the map. */
      #floating-panel {
        top: 10px;
        right: 0px;
        z-index: 5;
        text-align: right;
        font-family: 'Roboto','sans-serif';
        padding-right: 0px;
      }
    </style>

</head>
   
   <body bgcolor = "#FFFFFF" onload="mainLoop()">
   <div id="floating-panel">
   <a href="cerrarsession.php"><button onclick="regresar()" class="btn btn-primary">Cerrar Session</button></a>
   </div>

   <center>
      <img id="logo" src='img/operador.png' width='100px' border='0'/></br>
      <div id="vista"></div>
   </center>
   <div class='thumb audio'><audio class='player_audio' src='mp3/alerta3.mp3' loop="true"></audio></div>


   
   </body>
</html>