<?php 

require 'session.php';
use Wolframe\Session as Session;

function detect_browser( )
{
	$result = '';

	// TODO: don't do this all the time. maybe store it in the session
	include( 'browser_detection.inc' );
	if( $browser = browser_detection( 'full' ) ) {
		$result = $browser[0] . (int)$browser[1];
//		error_log( print_r( $browser, true ) );
	}
	
	return $result;
}

$canDoClientSideXSLT = array(
	"op12", "ie8", "ie9", "ie10", "moz23", "webkit27", "webkit28"
);

try
{
// find out whether to use client side XSLT or not
	$clientSideXSLT = false;
	if( array_key_exists( "clientSideXSLT", $_GET ) ) {
		$clientSideXSLT = $_GET["clientSideXSLT"];
	} else {
		$browser = detect_browser( );
		error_log( $browser );
		
		$clientSideXSLT = false;
		if( in_array( $browser, $canDoClientSideXSLT ) ) {
			$clientSideXSLT = true;
		}
	}

// set correct header, whether we return XML and the browser loads XSLT
// and XML to create XHTML or whether we return XHTML directy after processing
// it on the server
	if( $clientSideXSLT ) {
		header( "Content-Type: text/xml" );
	} else {
		header( "Content-Type: text/html" );
	}
	
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
		preg_match('/[<][!]DOCTYPE[ ]*\w+ SYSTEM[ ]*["](\w+)[.]/', $result, $matches);
		$rr = explode( '?>', $result, 2);
		$rrr = explode( '>', $rr[1], 2);
		$xmlDoc = $rrr[1];
		$xsltFile = $matches[1] . '.xslt';
		
		if( $clientSideXSLT ) {
			$random = uniqid( md5( rand( ) ) );
			$output = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
				. "\n"
				. '<?xml-stylesheet type="text/xsl" href="/wolfzilla/xslt/'
				. $xsltFile
				. "?random=$random\"?>\n"
				. $xmlDoc;
			echo $output;
		} else {
			$xslt = new DomDocument;
			$xslt->load( 'xslt/' . $xsltFile );
			$xml = new DomDocument;
			$xml->loadXml( $xmlDoc );
			$proc = new XsltProcessor( );
			$proc->importStylesheet( $xslt );
			$output = $proc->transformToXML( $xml );
			echo $output;
			unset( $proc );
		}

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

