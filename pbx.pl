BEGIN { require "./DEFINITY_ossi.pm"; import DEFINITY_ossi; }

use Data::Dumper;

my $DEBUG = 0;
my $progname="pbx.pl";
 ($loc)=@ARGV;
$c=@ARGV;
if ($c eq 0) {&help};

# print "$command\n";
our $node = new DEFINITY_ossi($loc, $DEBUG);
unless( $node && $node->status_connection() ) {
	die("ERROR: Login failed for ". $node->get_node_name() );
}
$command="";
while ($command ne "quit")    {
    	print "enter Command : \n";
    	$command=<STDIN>;
		$node->pbx_command("$command");
		if ( $node->last_command_succeeded() ) {
 			my @ossi_output = $node->get_ossi_objects();
 			foreach my $hash_ref(@ossi_output) {
 				print Dumper($hash_ref);
 				#$key=keys(%$hash_ref);
 				#print $key." = ".$hash_ref{$key}."\n";
 			}

 		}
 		$node->pbx_command("$CANCEL");
 		
		#if ( $node->pbx_vt220_command("$command") ) 
		#{
		#	$result=$node->get_vt220_output();
			#print "$result\n";
			# print DEBUG "$node->get_vt220_output()";
		#}
   }
   $node->do_logoff();
   close OUT;


sub help()
{
	print "\n\nusage : $progname \"pbx location\"";
	print "\tie : $progname LX \n";
	print "press <enter> to close\n";
	$ans=<STDIN>;
	exit;
}