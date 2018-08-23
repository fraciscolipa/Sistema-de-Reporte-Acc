
//emergencias(id_emergencia,id_usuario,id_auto,nivel, lat,lng)



//ver hospitales (hospital, telefonos, nombres y apellidos contacto)(lat,lng)

//ver datos usuario (apellidos y nombres, apellidos y nomrbes de contacto 
//telefono y relacion)(id_usuario)

//ver datos auto (placa marca)(id_auto)
var emergencias = [];//Se actualiza cuando hay nuevas emergencias
//var hospitales = [];
//var audio;

//var latEm;
//var lngEm;


function sleep(ms)
{
  return new Promise(resolve => setTimeout(resolve, ms));
}

async function mainLoop(){
  await sleep(2000);
  console.log('empezar a verificar...');
  verificarEmergencia();
}

function audioPlay()
{
  $('.player_audio')[0].play();
}

function audioStop()
{
  //getActualizarEmergencia();
  $('.player_audio')[0].pause();
  $('.player_audio')[0].load();
  
  $("#vista").html("");
  $("#logo").show(1000);
  listarEmergencias();
  mainLoop();
}

function codigoSirena()
{
  var codigo = "<img src='http://www.gifs-animados.es/gifs-imagenes/l/luces-de-alarma/gifs-animados-luces-de-alarma-146068.gif' width='600px' border='0'/></br>";
  codigo += "<button onclick='audioStop()' type='button' class='btn btn-danger'>Ver emergencia</button>";
  return codigo;
}

//////////////////////////////////////////////////////////////77
//Verifica si el operador tiene asignada una emergencia
function verificarEmergencia()
{
	$.ajax({
    type: "GET",
    url: "api/verificar_emergencia.php",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: successVerificarEmergencia,
    error: function(err) {
      mainLoop();
    }
  });
  return false;
}

function successVerificarEmergencia(data)
{
  if(data == null) {
    mainLoop();
    return false;
  }

  $("#logo").hide(0);
  $("#vista").hide(0);
  audioPlay();
  $("#vista").html(codigoSirena());
  $("#vista").show(1000);

}

//////////////////////////////////////////////////////////////////
//Actualiza la tabla de emergencias
function codigoEmergencias()
{
  var codigo = "<center><h1>Lista de Emergencias</h1></center>";
  codigo += "<table class='table table-striped' style='width:834px'>";
  codigo += "<thead><tr>";
  codigo += "<th>Código</th><th>Nivel</th><th>Usuario</th>";
  codigo += "<th>Hospitales</th><th>Familiares</th>";
  codigo += "<th>Archivar</th>";
  codigo += "</tr></thead>";
  codigo += "<tbody>";

  for(var i = 0; i < emergencias.length; ++i){
    codigo += "<tr>";
    codigo += "<td>"+ emergencias[i].id_emergencia+"</td>";
    codigo += "<td>"+ emergencias[i].nivel+"</td>";
    codigo += "<td>"+ emergencias[i].apellidos+", "+emergencias[i].nombres+"</td>";
    codigo += "<td>"+ "<a href='mapa.php?lat="+emergencias[i].lat+"&lng="+emergencias[i].lng+"'>ver</a>"+"</td>";
    codigo += "<td>"+ "<a href='#' onclick = 'listarFamiliares("+emergencias[i].id_usuario+")'>ver</a>"+"</td>";
    codigo += "<td>"+ "<a href='#' onclick = 'formularioArchivar("+emergencias[i].id_emergencia+")'>ok</a>"+"</td>";
    codigo += "</tr>";  
  }  
  codigo += "</tbody></table>";

  return codigo;

}

function listarEmergencias()
{
  $.ajax({
    type: "GET",
    url: "api/listar_emergencias.php",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: successListarEmergencias,
    error: function(err) {
    }
  });
  return false;
}

function successListarEmergencias(data)
{
  emergencias = data;
  $("#vista").hide(0);

  if(emergencias.length == 0){
    $("#vista").html("<h1>No hay ninguna emergencia</h1>");
  }
  else{
    $("#vista").html(codigoEmergencias());
  }

  $("#vista").show(1000);
}


//////////////////////////////////////////////////////////////////
//Muestra los parientes de usuario
function codigoFamiliares(familia)
{
  var codigo = "<center><h1>Lista de Familiares</h1></center>";
  codigo += "<table class='table table-striped' style='width:834px'>";
  codigo += "<thead><tr>";
  codigo += "<th>Teléfono</th><th>Nombres</th><th>Apellidos</th>";
  codigo += "<th>Parentesco</th>";
  codigo += "</tr></thead>";
  codigo += "<tbody>";

  for(var i = 0; i < familia.length; ++i){
    codigo += "<tr>";
    codigo += "<td>"+ familia[i].telefono+"</td>";
    codigo += "<td>"+ familia[i].nombres+"</td>";
    codigo += "<td>"+ familia[i].apellidos+"</td>";
    codigo += "<td>"+ familia[i].relacion+"</td>";
    codigo += "</tr>";  
  }  
  codigo += "</tbody></table>";

  codigo += "<button onclick='listarEmergencias()' type='button' class='btn btn-primary'>Retroceder</button>";

  return codigo;

}

function listarFamiliares(id)
{
  $.ajax({
    type: "GET",
    data: { id_usuario: id},
    url: "api/listar_familiares.php",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: successListarFamiliares,
    error: function(err) {
      alert("Hubo un problema");
    }
  });
  return false;
}

function successListarFamiliares(data)
{
  $("#vista").html("");
  $("#vista").hide(0);

  var codigo = codigoFamiliares(data);

  $("#vista").html(codigo);
  $("#vista").show(1000);
}

//////////////////////////////////////////////////////////////////
//Archivar Emergencia
function formularioArchivar(idEmergencia)
{
  var codigo = "<center>";    
  codigo += "<div class='form-consulta'>"; 	
	codigo += "<label>Observaciones de la emergencia</label>";
	codigo += "<textarea id='observacion' class='campo-form'></textarea>";
  codigo += "</br>";
  codigo += "<center>";
	codigo += "<button class='btn btn-primary' onclick='archivar("+idEmergencia+")'>Archivar</button>"; 
  codigo += " <button class='btn btn-primary' onclick='listarEmergencias()'>Cancelar</button>";
  codigo += "</center>";
  codigo += "</div>";
  codigo += "</center>";

  $("#vista").html("");
  $("#vista").hide(0);

  $("#vista").html(codigo);
  $("#vista").show(1000);
}

function archivar(idEmergencia){
  var miObservacion = $("#observacion").val();
  
  $.ajax({
    type: "GET",
    url: "api/archivar.php",
    data: { id_emergencia: idEmergencia, observacion : miObservacion},
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: successArchivar,
    error: function(err) {
      alert("Se presento un problema");
    }
  });
  return false;
}

function successArchivar(data) {
  alert("Emergencia Archivada");
  listarEmergencias();
}





listarEmergencias();





function irOperador(){
  location.href ="operador.php";
}



//getActualizarEmergencia();
//setInterval('getEmergencia()',10000);



//Si llega nuevas emergencias actualizar la lista de emergencias(get)
// y marca como visto en las tablas