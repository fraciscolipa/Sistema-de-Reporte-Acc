<?php
require_once 'gmail/gmail.php';
//require_once 'sms/sms.php';

/**Si no hay conexion a la base de datos terminar el script**/
$con = pg_pconnect("host=localhost port=5432 dbname=pablo user=pablo password=pablo");
if(!$con) exit(1);

$clienteGmail = getClienteGmail();
$servicioGmail = new Google_Service_Gmail($clienteGmail);

/**Obtiene 1 mensaje no leido y perteneciente al administrador del satelite**/
$user = 'me';
$mensajes = $servicioGmail->users_messages->listUsersMessages($user,['maxResults'=> 1, 'labelIds'=> 'UNREAD','q'=>'from:jatch21@gmail.com']);

/**Si no hay ningun mensaje nuevo se termina de ejecutar el script**/
$nMensajes = count($mensajes);
if($nMensajes == 0){
    pg_close($con);
    exit(1);
}

/**Obtiene datos del cuerpo del mensaje no leido**/
$mensajeId = $mensajes[0]->getId();
$mensaje = $servicioGmail->users_messages->get($user, $mensajeId, ['format'=>'minimal']);
$cuerpo = $mensaje->snippet;

$cuerpo = explode(" ", $cuerpo);
$id_user = $cuerpo[0];
$lat = 1.0 * $cuerpo[1];
$lng = 1.0 * $cuerpo[2];
$nivel = 1 * $cuerpo[3];

/**Retorna el id y celular del operador activo**/
$query = "select id_operador, celular from operador where activo = 't' order by natenciones";
$operadores = pg_query($con, $query);
$nOp = pg_num_rows($operadores);

/**Si no hay ningun operador disponible que termine el script**/
if($nOp == 0){
    pg_free_result($operadores);
    pg_close($con);
    exit(1);
}

/**Obtiene el id_operador y si celular**/
$operador = pg_fetch_assoc($operadores);
$id_operador = $operador['id_operador'];
$celular = $operador['celular'];

echo "Registrando emergencia... op:".$id_operador." celular:".$celular."\n";

/**Envia un SMS  al operador elegido, es un servicio de prueba por ello funciona solo con el numero registrado**/
//$clienteSMS = getClienteSMS();
//enviarSMS($clienteSMS, $celular, 'emergenciaunsa');

/**Cambio a leido el mensaje observado**/
$mods = new Google_Service_Gmail_ModifyMessageRequest();
$mods->setRemoveLabelIds(['UNREAD']);
$servicioGmail->users_messages->modify($user, $mensajeId, $mods);

/**Registrando la emergencia**/
$query = "insert into emergencia(lat,lng,nivel,fechahora,emergencia_vista,observacion,id_usuario,id_operador,id_hospital)";
$query .= "values($lat,$lng,$nivel,current_timestamp,'f','',$id_user,$id_operador,NULL)";
pg_query($con, $query);

/**Actualizar natenciones del operador**/ 
$query = "update operador set natenciones = natenciones + 1 where id_operador = $id_operador";
pg_query($con, $query);

pg_free_result($operadores);
pg_close($con);

?>
