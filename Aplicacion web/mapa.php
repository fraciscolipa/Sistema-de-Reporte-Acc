<?php
require_once 'conexion.php';
session_start();
if(!isset($_SESSION['id_operador'])){
   header("location: index.php");
}
?>
<?php
   $con = conexionBD();
   if(!$con) exit(1);

   $lat = $_GET['lat'];
   $lng = $_GET['lng'];
   
   $query = "SELECT id_hospital,hospital,direccion,lat,lng, ST_Distance(latlng, ST_GeomFromText('POINT($lat $lng)',4326))*1000/0.00936764 as distancia FROM hospital WHERE ST_DWithin(latlng,ST_GeomFromText('POINT($lat $lng)', 4326),(100000*0.00936764/1000) ) order by distancia limit 3";
   $hospitales = pg_query($con, $query);
   
   $res= array();
   while ($row = pg_fetch_assoc($hospitales)) {
      $id = $row['id_hospital'];
      $query2 = "SELECT telefono, nombres_contacto, apellidos_contacto, cargo FROM contacto_hospital where id_hospital = $id limit 1";
      $contactos = pg_query($con, $query2);
      $contacto = pg_fetch_assoc($contactos);
      $nombres = $contacto['apellidos_contacto'].", ".$contacto['nombres_contacto'];

      array_push($res, array('id_hospital'=>1*$row['id_hospital'],'hospital'=>$row['hospital'],'lat'=>1*$row['lat'],'lng'=>1*$row['lng'],'telefono'=>$contacto['telefono'],'nombres'=>$nombres,'cargo'=>$contacto['cargo'],'tiempo'=>'','segundos'=>0,'path'=>'','direccion'=>''));

      pg_free_result($contactos);
   }

   pg_free_result($hospitales);
   pg_close($con);

?>
<!DOCTYPE html>
<html>
  <head>
    <title>Hospital</title>
    <meta name="viewport" content="initial-scale=1.0">
    <meta charset="utf-8">
    <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
    <style>
      #map {
        height: 100%;
      }
      html, body {
        height: 100%;
        margin: 0;
        padding: 0;
      }
      #floating-panel {
        position: absolute;
        top: 10px;
        left: 49%;
        z-index: 5;
        text-align: center;
        font-family: 'Roboto','sans-serif';
        line-height: 30px;
        padding-left: -10px;
      }
    </style>

  <script type="text/javascript" src="js/jquery-3.2.1.min.js"></script>
  <!--<script src="http://code.jquery.com/jquery-1.9.1.min.js"></script>
  <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>-->

  <script type="text/javascript">
    var hospitales = <?php echo json_encode($res); ?>;
    var latE = <?php echo $_GET['lat']; ?>;
    var lngE = <?php echo $_GET['lng']; ?>;
    var direccionE = '';

    function regresar(){
      location.assign("operador.php");
    }

  </script>
  <script type="text/javascript" src="js/mapa.js"></script>

  <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyD1BH4nQdTUUiBqXsFMjDr3tJV6ySfD09g&callback=initMap"
    async defer></script>

  </head>
  <body>
    <div id="floating-panel">
      <button onclick="regresar()" class="btn btn-primary"> Regresar</button>
    </div>
    <div id="map"></div>
  </body>
</html>
