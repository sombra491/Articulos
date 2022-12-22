#!"E:\Desarrollador\perl\bin\perl.exe"
use strict;
use CGI ':standard';
use DBI;
my $owner = param('owner');
my $title = param('title');
my $text = param('text');
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
my $error ='<div><form method=GET action="./new.pl">
			<h4> Titulo</h4> 
			<input type=hidden name=owner value='.$owner.'>
			<input type=text name=title size=30 maxlength=30 value="" style="height: 30px;" required>
			<br>
			<br>
			<textarea name=text rows="20" cols="60"></textarea>
			<br>
			<input type=submit value="guardar" style="height: 30px;">
			</form></div>'.'
			<form method=GET action="./list.pl">
				<input type=hidden name=owner value='.$owner.'>
				<input type=submit value="cancelar" style="height: 30px;">
			</form>';
if($title eq $title1){$info=$error;}
else{$info='<h4>Se creo '.$title.' de '.$owner.'</h4>'.
'<textarea rows="20" cols="60" readonly>'.$text.'</textarea>'.
'
			<form method=GET action="./list.pl">
				<input type=hidden name=owner value='.$owner.'>
				<input type=submit value="lista" style="height: 30px;">
			</form>';
my $sth = $dbh->prepare("INSERT INTO articles(title,owner,text) VALUES (?,?,?)");
$sth->execute($title,$owner,$text );
$sth->finish;}
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