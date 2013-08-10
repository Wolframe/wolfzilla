<?xml version="1.0" encoding="ISO-8859-1" ?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  
  <xsl:output method="html" version="1.1" encoding="iso-8859-1" />
  
  <xsl:include href="image.xslt"/>
  
  <xsl:template match="/issues">
    <html>
      <head>
        <link rel="stylesheet" type="text/css" href="/wolfzilla/css/master.css"/>
      </head>
      <body>
                
        <div id="containerfull"> 

          <div id="header">
            <h1><a href="index.html">Project Wolframe</a></h1>
            <h2>Bugreporting...</h2>
          </div>

          <div id="menu">
            <ul>   
              <li><a class="current" href="index-main.html">Home</a></li>
              <li><a href="download.html">Downloads</a></li>
              <li><a href="documentation.html">Documentation</a></li>
              <li><a href="news.html">News</a></li>
              <li><a href="support.html">Support</a></li>
            </ul>
          </div>

          <div id="feature">
            <div class="left">
              <h2>Wolframe Application Server</h2>
              <p>This area can be used to put something special in focus. Products, a presentation or anything you may want to highlight. If not needed, this area can be removed completely.</p>
            </div>

            <div class="right">
              <h2>Wolframe Server Development Kit</h2>
              <p>Use div class="left" and "right" for two columns, or remove the two extra div:s to use a single column here.</p>
            </div>
            <div class="clear">&#160;</div>
          </div>

          <div id="main">
            <div id="sidebar">
              <div class="sidebarbox">
                <h2>Sidebar menu</h2>
                <ul class="sidemenu">
                  <li><a href="index.html">Sidebar link</a></li>
                  <li><a href="#">Subpages supported</a>
                    <ul>
                      <li><a href="index.html">Subpage one</a></li>
                      <li><a href="examples.html">Subpage two</a></li>
                    </ul></li>
                  <li><a href="#">Last page</a></li>
                </ul>
              </div>

              <div class="sidebarbox">
                <h2>Text box</h2>
                <p>This is a sidebar text box. It can be used for regular links:</p>
                <ul>
                  <li><a href="http://andreasviklund.com/templates/">More free templates</a></li>
                  <li><a href="http://andreasviklund.com/blog/">Andreas' blog</a></li>
                </ul>
              </div>
            </div>
    
            <div id="content">
              <h2>Bugs of project</h2>
              <p>
                <table>
                  <xsl:for-each select="issue">
                    <tr>
                      <td>
                        <xsl:call-template name="image">
                          <xsl:with-param name="src" select="typeIcon"/>
                        </xsl:call-template>                        
                      </td>
                      <td>
                        <a href="/wolfzilla/index.php/issue/{@id}"><xsl:value-of select="reference"/></a>
                      </td>
                      <td>
                        <xsl:value-of select="title"/>
                      </td>
                    </tr>
                  </xsl:for-each>
                </table>
              </p>

              <div class="clear">&#160;</div>
            </div>
		
            <div class="clear">&#160;</div>

        </div>
        
        <div id="footer">
          <div id="footersections">
            <div class="half">
              <h2>Footer area #1</h2>
              <p>This area uses the div class="half". You can replace it with two div:s if you give them class="quarter" to get a 4-column footer, or replace the two following div:s with one div with class="lasthalf" to get a 2-column footer. In this file, I have combined the "half", "quarter" and "lastquarter" classes.</p>
            </div>

            <div class="quarter">
              <h2>Footer area #2</h2>
              <p>This area uses the div class="quarter".</p>
              <p>Paragraphs and <a href="#">links</a> work here too.</p>
            </div>

            <div class="lastquarter">
              <h2>Footer menu</h2>
              <ul>
                <li><a href="index.html">Link #1</a></li>
                <li><a href="index.html">Link #2</a></li>
              </ul>
            </div>
            <div class="clear">&#160;</div> 
          </div>
        </div>

        <div id="credits">
          <p>&#xa9; 2011 - 2013 <a href="http://wolframe.org">Project Wolframe</a><br/>
          <span class="small">Template design by <a href="http://andreasviklund.com/">Andreas Viklund</a></span></p>
        </div>
        </div>
      </body>
    </html>
  </xsl:template>
  
</xsl:stylesheet>
