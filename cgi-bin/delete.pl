#!"E:\Desarrollador\perl\bin\perl.exe"
use strict;
use CGI ':standard';
use DBI;
my $owner = param('owner');
my $title = param('title');
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
my $title1;
my $owner1;
my $info;
my $sth1 = $dbh->prepare("SELECT * FROM articles WHERE (title=?)");
$sth1->execute($title);
while( my @row = $sth1->fetchrow_array ) {
$title1=$row[0];	
$owner1=$row[1];
}
$sth1->finish;
if($owner1 eq $owner){$info='
<article>
<owner>'.$owner.'</owner>
<title>'.$title.'</title>
</article>
	<form method=GET action="./list.pl">
				<input type=hidden name=owner value='.$owner.'>
				<input type=submit value="lista" style="height: 30px;">
			</form>';
my $sth = $dbh->prepare("DELETE FROM articles WHERE (title=?)");
$sth->execute($title);
$sth->finish;}
else {$info='
<article>
<owner></owner>
<title></title>
</article>
	<form method=GET action="./list.pl">
				<input type=hidden name=owner value='.$owner.'>
				<input type=submit value="lista" style="height: 30px;">
			</form>';}
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