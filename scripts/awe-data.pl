use JSON; 
use Data::Dumper;
use File::Which;

my $id = shift;
$id = $ENV{AWE_JOB} if $ENV{AWE_JOB} && !$id;

unless ($id) { 
	print "Usage: awe-data <id>\n";
	print "Downloads output(s) from the last step\n";
	exit;
}
unless (which "awe-job") {
	print "awe-job command not installed\n";
	exit;
}

# $jstring.=$_ while(<>); 
$jstring = `awe-job $id`;

$r=decode_json($jstring);

$LAST = $#{ $r->{data}->{tasks} };

foreach $a (@{ $r->{data}->{tasks} }) {
	my $task_id = $1 if $a->{taskid} =~ /\_(\d+)/;
	$outputs = $a->{outputs} if $task_id == $LAST;
}


foreach $filename ( keys %$outputs ) {
        $cmd = 'curl -s ' . $outputs->{$filename}->{url} . ' > ' . $filename . "\n";
        print "downloading $filename with command:\n$cmd\n";
	system($cmd);
}
