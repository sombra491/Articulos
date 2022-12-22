#!"E:\Desarrollador\perl\bin\perl.exe"
use strict;
use CGI ':standard';
use DBI;
my $user = param('user');
my $password = param('password');
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
my $cabeceraError="
<?xml version='1.0' encoding='utf-8'?>
  <user>
	<owner></owner>
	<firstName></firstName>
	<lastName></lastName>
	</user>";
my $error=	'<table style="width:100%">
  <tr>
    <th>
	<h2><a href="../index.html">Iniciar secion</a> </h2></th>
    <th>
	<h2><a href="../registrarse.html">Registrarse</a> </h2></th>
  </tr>
</table>
<center>
	<form method=POST action="./login.pl">
			<h4> Usuario (user)</h4> 
			<input type=text name=user size=100 maxlength=50 value="" style="height: 30px;" required>
			<h4> Contraseña (password)</h4> 
			<input type=password name=password size=100 maxlength=50 value="" style="height: 30px;" required>
			<br>
			<input type=submit value="iniciar" style="height: 30px;">
	</form>
</center>';
my $userName;
my $passwordB;
my $info;
my $lastName;
my $firstName;
my $sth = $dbh->prepare("SELECT * FROM users WHERE (userName=?)");
$sth->execute($user);
while( my @row = $sth->fetchrow_array ) {
$userName=$row[0];	
$passwordB=$row[1];
$lastName=$row[2];
$firstName=$row[3];
}
$sth->finish;

my $cabecera="
<?xml version='1.0' encoding='utf-8'?>
  <user>
	<owner>".$userName."</owner>
	<firstName>".$firstName."</firstName>
	<lastName>".$lastName."</lastName>
	</user>";
##condicionales
if ($userName eq ""){$info=$cabecera.$error;}
elsif ($password eq $passwordB){$info=$cabecera.'
<h2>Articulos</h2>
<h4>Aqui podra escribir sus paginas usando un subconjunto de Markdown,
si desea ver la paginas creadas </h4>
<form method=POST action="./list.pl">
	<input type=hidden name=owner value='.$userName.'>
	<input type=submit value="lista" style="height: 30px;">
</form>
<form method=POST action="./article.pl">
	<input type=hidden name=owner value='.$userName.'>
	<input type=submit value="Articulos" style="height: 30px;">
</form>
<h4><a href="../index.html">Regresar al principal</a></h4>';}
else {$info=$cabeceraError.$error;}
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