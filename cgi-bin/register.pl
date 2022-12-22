#!"E:\Desarrollador\perl\bin\perl.exe"
use strict;
use CGI ':standard';
use DBI;
my $userName = param('userName');
my $password = param('password');
my $firstName = param('firstName');
my $lastName = param('lastName');
##abrimos el mariadb
my $host="servidor"; 
my $base_datos="articulo";  
my $usuario="alumno";  
my $clave="pweb1";  
my $driver="mysql";  
##Conectamos con la BD. Si no podemos, mostramos un mensaje de error
my $dbh = DBI-> connect ("dbi:$driver:database=$base_datos;
host=$host", $usuario, $clave)
|| die "nError al abrir la base datos: $DBI::errstrn";
##operaciones
my $error=	'<table style="width:100%">
  <tr>
    <th>
	<h2><a href="../index.html">Iniciar secion</a> </h2></th>
    <th>
	<h2><a href="../registrarse.html">Registrarse</a> </h2></th>
  </tr>
</table>
<center>
	<form method=POST action="./register.pl">
			<h4> Usuario (userName)</h4> 
			<input type=text name=userName size=100 maxlength=50 value="" style="height: 30px;" required>
			<h4> Contraseña (password)</h4> 
			<input type=password name=password size=100 maxlength=50 value="" style="height: 30px;" required>
			<h4>primer nombre (firstName)</h4> 
			<input type=text name=firstName size=100 maxlength=50 value="" style="height: 30px;" required>
			<h4> Apellido (lastName)</h4> 
			<input type=text name=lastName size=100 maxlength=50 value="" style="height: 30px;" required>
			<br><br>
			<input type=submit value="registrarse" style="height: 30px;">
	</form>
</center>';	
##datos sacados	
my $userName1;
my $password1;
my $info;
my $lastName1;
my $firstName1;
my $sth = $dbh->prepare("SELECT * FROM users WHERE (userName=?)");
$sth->execute($userName);
while( my @row = $sth->fetchrow_array ) {
$userName1=$row[0];	
$password1=$row[1];
$lastName1=$row[2];
$firstName1=$row[3];
}
$sth->finish;
if($userName1 eq $userName){$info="
<?xml version='1.0' encoding='utf-8'?>
  <user>
	<owner></owner>
	<firstName></firstName>
	<lastName></lastName>
	</user>".$error;}	
else{
my $sth = $dbh->prepare("INSERT INTO users(userName,password,lastName,firstName) VALUES (?,?,?,?)");
$sth->execute($userName,$password,$lastName,$firstName);
$sth->finish;
$info="
<?xml version='1.0' encoding='utf-8'?>
  <user>
	<owner>".$userName."</owner>
	<firstName>".$firstName."</firstName>
	<lastName>".$lastName."</lastName>
	</user>";
}
##Nos desconectamos de la BD. Mostramos un mensaje en caso de error
$dbh-> disconnect ||
warn "nFallo al desconectar.nError: $DBI::errstrn";

##imprimir html
print "Content-type: text/html\n\n";
print <<ENDHTML;
<html>
  <head>
	<!-- La cabecera del index-->
	<meta charset="utf-8"> 	
	<title>Articulo</title>
	<link rel="stylesheet" type="text/css" href="index.css">
</head>
<body>
$info
</body>
</html>
ENDHTML