<?php 

require 'session.php';

require 'config.php';

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

$clientSideXSLT = false;
$urlRewrite = false;

try
{
// find out whether to use client side XSLT or not
	if( array_key_exists( "clientSideXSLT", $_GET ) ) {
		$clientSideXSLT = $_GET["clientSideXSLT"];
	} else {
		$browser = detect_browser( );
		error_log( $browser );
		
		$clientSideXSLT = false;
		if( in_array( $browser, $BROWSERS_USING_CLIENT_XSLT ) ) {
			$clientSideXSLT = true;
		}
	}

// find out whether Apache/mod_rewrite is around and we should beatify
// URLs
	if( $_SERVER['HTTP_MOD_REWRITE'] == 'On' ) {
		$urlRewrite = true;
	}

// set correct header, whether we return XML and the browser loads XSLT
// and XML to create XHTML or whether we return XHTML directy after processing
// it on the server
	if( $clientSideXSLT ) {
		header( "Content-Type: text/xml" );
	} else {
		header( "Content-Type: text/html" );
	}

// parse URL parameters, TODO: map with XSLT back to requests
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

// connect to wolframe daemon and execute query
	$sslopt = array(
		"local_cert" => $WOLFRAME_COMBINED_CERTS,
		"verify_peer" => false
	);
	$conn = new Wolframe\Session( $WOLFRAME_SERVER, $WOLFRAME_PORT, $sslopt, "NONE");
		
	if (($result = $conn->request( $query)) === FALSE)
	{
		throw new Exception( $conn->lasterror());
	}
	else
	{
// determine name of XSLT stylesheeet from document type
		preg_match('/[<][!]DOCTYPE[ ]*\w+ SYSTEM[ ]*["](\w+)[.]/', $result, $matches);
		$rr = explode( '?>', $result, 2);
		$rrr = explode( '>', $rr[1], 2);
		$xmlDoc = $rrr[1];
		$xsltFile = $matches[1] . '.xslt';
		
		//~ error_log( $xmlDoc );

		echo render( $xmlDoc, $xsltFile );
	}
}
catch ( \Exception $e)
{
	$xml = "<error>" . $e->getMessage() . "</error>";

	render( $xml, "error.xslt" );
}

function render( $xmlDoc, $xsltFile )
{
	global $clientSideXSLT;
		
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


