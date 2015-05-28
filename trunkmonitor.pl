
#
#
#
 use Data::Dumper;
use MIME::Lite;
MIME::Lite->send('smtp','smtp.com');
use DateTime;
use Date::Manip;
use DBI;

&dbconnect();

$limit=120; #60 minutes limit for sending duplicate mails
my $dtus = DateTime->now(time_zone => 'America/New_York');
my $dt = DateTime->now(time_zone => 'Europe/Paris');
$dateus=$dtus->ymd." ".$dtus->hms;
$date=$dt->ymd." ".$dt->hms;
$mail=1;
$error=1;

BEGIN { require "/opt/lampp/htdocs/pbx/DEFINITY_ossi.pm"; import DEFINITY_ossi; }

my $DEBUG = 0;
my @line = @ARGV;

foreach $loc(@line){
	our $node = new DEFINITY_ossi($loc, $DEBUG);
	unless( $node && $node->status_connection() ) {
		die("ERROR: Login failed for ". $node->get_node_name() );
	}
	$command="monitor traffic trunk-group ";
	$node->pbx_command("$command");
	if ( $node->last_command_succeeded() ) {
		my @ossi_output = $node->get_ossi_objects();
		foreach my $hash_ref(@ossi_output) {
			foreach my $key (sort keys %$hash_ref) {
				$value=$hash_ref->{$key};
				#print "$key => $value\n";
				if (($key ne "0001ff00") and ($value ne "")){
					#print "$key => $value\n";
					@t=split(/ {1,}/,$value);  #split on 1 or more space
					print "$key = $t[0] | $t[1] | $t[2]\n";
					$date=DateTime->now(time_zone => "local")->strftime('%F %T');
		 			$sql="INSERT INTO `voice`.`monitor` (`id` ,`location` ,`trunk` ,`trunksize` ,`usage`,`datetaken`) VALUES ( NULL , '$loc', '$t[0]','$t[1]','$t[2]','$date')";
					&DoQuery("$sql");
				}
        		
    		}
		 	print "=======================\n";

		}
	}
	$node->pbx_command("$CANCEL");
	
	
    $node->do_logoff();

}



sub DoQuery()
{
    my $query=$_[0];
    $sth = $dbh->prepare("$query") or die "Cannot prepare statement: ". $dbh->errstr;
    $sth->execute() or die "Cannot execute query: " . $dbh->errstr;
}
# create dbconnection
sub dbconnect()
{
$host="mysql.com";
$database="voice";
$user="root";
$password="password";

    $dsn = "DBI:mysql:database=$database;host=$host;";
    $dbh = DBI->connect($dsn, $user, $password) || die "Database connection not made: $DBI::errstr";;
}
