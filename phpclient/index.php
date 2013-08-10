<?php 
header("Content-Type: text/xml");
require 'session.php';
use Wolframe\Session as Session;

try
{
	$sslpath = "certs";
	$sslopt = array(
		"local_cert" => "$sslpath/combinedcert.pem",
		"verify_peer" => false
	);
	$conn = new Session( "127.0.0.1", 7961, $sslopt, "NONE");
	
	$uri = $_SERVER["PATH_INFO"];
	$parts = explode( "/", $uri );
	$cmd = $parts[1];
	
	if( $cmd == "projects" ) {
		$query = <<<EOF
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!DOCTYPE projects SYSTEM 'listProjects'>
<projects/>
EOF;
	} elseif( $cmd == "issues" ) {
		$project = $parts[2];
		$query = <<<EOF
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!DOCTYPE issues SYSTEM 'listIssues'>
<issues>
	<project id="$project"/>
</issues>
EOF;
	} elseif( $cmd == "issue" ) {
		$issue = $parts[2];
		$query = <<<EOF
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!DOCTYPE issue SYSTEM 'readIssue'>
<issue id="$issue"/>
EOF;
	} else {
		throw new Exception( "Unknown command '" . $cmd . "'" );
	}
		
	if (($result = $conn->request( $query)) === FALSE)
	{
		throw new Exception( $conn->lasterror());
	}
	else
	{
		$random = uniqid( md5( rand( ) ) );
		preg_match('/[<][!]DOCTYPE[ ]*\w+ SYSTEM[ ]*["](\w+)[.]/', $result, $matches);
		$rr = explode( '?>', $result, 2);
		$rrr = explode( '>', $rr[1], 2);
		$output = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
			. "\n"
			. '<?xml-stylesheet type="text/xsl" href="/wolfzilla/xslt/'
			. $matches[1]
			. ".xslt?random=$random\"?>\n"
			. $rrr[1];
		echo $output;
	}
}
catch ( \Exception $e)
{
	$random = uniqid( md5( rand( ) ) );
	echo '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
			. "\n"
			. '<?xml-stylesheet type="text/xsl" href="/wolfzilla/xslt/error'
			. ".xslt?random=$random\"?>\n";
			
	echo "<error>" . $e->getMessage() . "</error>";
}
?>

