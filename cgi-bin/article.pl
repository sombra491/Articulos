#!"E:\Desarrollador\perl\bin\perl.exe"
use strict;
use CGI ':standard';
use DBI;
my $owner = param('owner');
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
my $info='<table style="width:50%">
  <tr>
    <th><h2>Nombre</h2></th>
    <th><h2>Ver</h2></th>
	<th><h2>Autor</h2></th>
	 </tr>';
my $sth = $dbh->prepare("SELECT * FROM articles");
$sth->execute();
while( my @row = $sth->fetchrow_array ) {
if($row[0] eq ""){}
else{		$info=$info.'<tr><th><h4>'.$row[0].'<h4></th>';
			$info=$info.'
			<th><form method=GET action="./view.pl">
				<input type=hidden name=owner value='.$owner.'>
				<input type=hidden name=title value='.$row[0].'>
				<input type=submit value="mirar" style="height: 30px;">
			</form></th>'.'
			<th><h4>'.$row[1].'</h4></th></tr>';}
}

$sth->finish;
$info=$info.'</table>
<h4><a href="../index.html">Regresar al principal</a></h4>';

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
	<title>$owner articulos</title>
	<link rel="stylesheet" type="text/css" href="index.css">
</head>
<body>
$info
</body>
</html>
ENDHTML