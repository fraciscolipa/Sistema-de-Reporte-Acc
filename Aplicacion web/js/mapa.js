var markerArray = [];
var directionsService;
var map;
var directionsDisplay;
var stepDisplay;


function initMap()
{
        directionsService = new google.maps.DirectionsService;

        map = new google.maps.Map(document.getElementById('map'), {
          zoom: 2,
          center: {lat: latE, lng: lngE}
        });

        directionsDisplay = new google.maps.DirectionsRenderer({map: map});

        stepDisplay = new google.maps.InfoWindow;

        dibujarRutas();
}

function calculateAndDisplayRoute(directionsDisplay, directionsService,
          markerArray, stepDisplay, map, lat1, lng1, lat2, lng2, color, url, pos) {

        directionsService.route({
          origin: {lat: lat1, lng: lng1},
          destination: {lat: lat2, lng: lng2},
          travelMode: 'DRIVING'
        }, function(response, status) {
          if (status === 'OK') {

            hospitales[pos].tiempo = response.routes[0].legs[0].duration.text;
            hospitales[pos].segundos = response.routes[0].legs[0].duration.value;
            hospitales[pos].direccion = response.routes[0].legs[0].start_address;
            hospitales[pos].path = response.routes[0].overview_polyline;

            direccionE = response.routes[0].legs[0].end_address;

            var flightPath = new google.maps.Polyline({
              path: google.maps.geometry.encoding.decodePath(response.routes[0].overview_polyline),
              geodesic: true,
              strokeColor: color,
              strokeOpacity: 0.5,
              strokeWeight: 6
            });

            flightPath.setMap(map);

            //alert(google.maps.geometry.encoding.decodePath(response.routes[0].overview_polyline));
            var marker = new google.maps.Marker({
              position: response.routes[0].legs[0].start_location,
              map: map,
              animation: google.maps.Animation.DROP,
              draggable:false,
              icon: url              
            });

            google.maps.event.addListener(marker, 'click', function() {
              stepDisplay.setContent(formatearInfo(hospitales[pos]));
              stepDisplay.open(map, marker);
            });

          } else {
            window.alert('Directions request failed due to ' + status);
          }
        });
}

function dibujarRutas() {

  calculateAndDisplayRoute(directionsDisplay, directionsService,
          markerArray, stepDisplay, map, hospitales[2].lat, hospitales[2].lng, latE, lngE, '#FF7514','http://maps.google.com/mapfiles/ms/icons/orange-dot.png',2);

  calculateAndDisplayRoute(directionsDisplay, directionsService,
          markerArray, stepDisplay, map, hospitales[1].lat, hospitales[1].lng, latE, lngE, '#FFFF00','http://maps.google.com/mapfiles/ms/icons/yellow-dot.png',1);

  calculateAndDisplayRoute(directionsDisplay, directionsService,
          markerArray, stepDisplay, map, hospitales[0].lat, hospitales[0].lng, latE, lngE, '#00FF00','http://maps.google.com/mapfiles/ms/icons/green-dot.png',0);

  var marker = new google.maps.Marker({
              position: new google.maps.LatLng(latE, lngE),
              map: map,
              animation: google.maps.Animation.BOUNCE,
              icon: 'http://maps.google.com/mapfiles/ms/icons/red-dot.png'          
            });

  google.maps.event.addListener(marker, 'click', function() {
              stepDisplay.setContent(direccionE);
              stepDisplay.open(map, marker);
            });


  map.setCenter(nuevoCentro());
  var distancia = Math.max(difLat(), difLng());
  map.setZoom(zoomIdeal(distancia));


}

function formatearInfo(hosp){
  var codigo = "<b>Lugar: </b>"+hosp.hospital+"<br>";
  codigo += "<b>Dirección: </b>"+hosp.direccion+"<br>";
  codigo += "<b>Tiempo en llegar: </b>"+hosp.tiempo+"<br><hr>";
  codigo += "<b>Cargo del Contacto: </b>"+hosp.cargo+"<br>";
  codigo += "<b>Nombres del Contacto: </b>"+hosp.nombres+"<br>";
  codigo += "<b>Teléfono: </b>"+hosp.telefono+"<br>";

  return codigo;

}

function difLat(){
  var maximo = latE;
  var minimo = latE;

  for(var i = 0; i < hospitales.length; ++i){
    if(maximo <  hospitales[i].lat) maximo = hospitales[i].lat;
    if(minimo >  hospitales[i].lat) minimo = hospitales[i].lat;
  }

  return Math.abs(maximo - minimo);
}

function difLng(){
  var maximo = lngE;
  var minimo = lngE;

  for(var i = 0; i < hospitales.length; ++i){
    if(maximo <  hospitales[i].lng) maximo = hospitales[i].lng;
    if(minimo >  hospitales[i].lng) minimo = hospitales[i].lng;
  }

  return Math.abs(maximo - minimo);
}

function zoomIdeal(distancia){
  if(distancia <  0.07641096132) return 13;
  if(distancia <  0.14300329732) return 12;
  if(distancia <  0.29384655738) return 11;
  if(distancia <  0.57492254702) return 10;
  if(distancia <  1.2) return 9;
  return 8;
}

function nuevoCentro(){
  var sumLat = latE;
  var sumLng = lngE;

  for(var i = 0; i < hospitales.length; ++i){
    sumLat += hospitales[i].lat;
    sumLng += hospitales[i].lng;
  }

  return new google.maps.LatLng(sumLat / 4, sumLng / 4);
}
