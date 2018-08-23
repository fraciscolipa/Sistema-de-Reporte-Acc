<?php
require_once 'conexion.php';
session_start();
$error = "";

//Si llego datos del formulario
if (isset($_POST['correo']) && isset($_POST['clave'])) 
{
   $con = conexionBD();
   if(!$con) exit(1);
   
   //Obtiene datos del correo actual de los operadores
   $query = "select id_operador,clave,nombres,apellidos,clave from operador where correo = '$_POST[correo]'";
   $usuarios = pg_query($con, $query);
   $nUser = pg_num_rows($usuarios);
   if($nUser > 0){
      $usuario = pg_fetch_assoc($usuarios);
      //Si la clave es registrada es igual a la ingresada por el formulario
      //entonces se crean las variables session
      if($_POST['clave'] == $usuario['clave']){
        $_SESSION['id_operador'] = $usuario['id_operador'];
        $_SESSION['nombre'] = $usuario['nombres']." ".$usuario['apellidos'];
        $query = "update operador set activo = 't' where id_operador = $_SESSION[id_operador]";
        pg_query($con, $query);
      }
      else
        $error = "Fallo el inicio de  session";
   }
   else
      $error = "Fallo el inicio de session";

   pg_free_result($usuarios);
   pg_close($con);
}

//Si se crearon las variables session entonces que se dirija a la ventana principal del operador
if(isset($_SESSION['id_operador'])){
   header("location: operador.php");
}
?>

<!DOCTYPE html>
<html>
<head>  
      <title>Bienvenido Operador</title>
      <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css" id="bootstrap-css">
      <link rel="stylesheet" type="text/css" href="css/login.css">
      <script type="text/javascript" src="js/jquery-3.2.1.min.js"></script>
      <script type="text/javascript" src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
   </head>
   
   <body>
    
   <div class="custom_body">
    <div class="container">
    	<div class="row">
    	    
    	    <div class="login_box">
    	        <section class="main-box">
        	        <form action = "" method = "post">
        	        <div class="input-box">
            	        <span class="input-group-addon i_icon"><i class="glyphicon glyphicon-user"></i></span>
                        <input id="email" type="text" class="form-control input_layout" name="correo" placeholder="operador@gmail.com">
                    </div>
                    <div class="input-box">
            	         <span class="input-group-addon i_icon"><i class="glyphicon glyphicon-lock"></i></span>
                       <input id="password" type="password" class="form-control input_layout" name="clave" placeholder="operador">
                    </div>
                    <input type="submit" name="login" class="btn btn-default btn_style" value="Ingresar">
                    </form>
                </section>    
    	    </div>
    	    
    	</div>
    </div>
</div>

      
      <!--<div class="modal-dialog">
      <div class="loginmodal-container">
           
        <h1>Login de Operador</h1><br>
        <form action = "" method = "post">
          <input type="text" name="correo" placeholder="operador@gmail.com">
          <input type="password" name="clave" placeholder="operador">
            <input type="submit" name="login" class="login loginmodal-submit" value="Ingresar">
        </form>
      </div>
    </div>-->
   </body>
</html>
