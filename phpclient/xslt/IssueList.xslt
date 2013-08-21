<?xml version="1.0" encoding="ISO-8859-1" ?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  
  <xsl:output method="html" version="1.1" encoding="UTF-8" indent="no"/>

  <xsl:include href="page.inc.xslt"/>
  <xsl:include href="image.xslt"/>

  <xsl:template match="/page">
    <xsl:variable name="title" select="issue/title"/>
    <xsl:variable name="reference" select="issue/reference"/>
    <xsl:call-template name="page">
      <xsl:with-param name="base" select="/page/@base"/>
      <xsl:with-param name="title" select="'Bugs of project xxx'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="issues">
    <h2>Bugs of project xxx</h2>
    <p>
      <table>
        <xsl:for-each select="issue">
          <tr>
            <td>
              <xsl:call-template name="image">
                <xsl:with-param name="src" select="typeIcon"/>
              </xsl:call-template>      
            </td>
            <td id="reference">
              <a href="{/page/@self}issue/{reference}"><xsl:value-of select="reference"/></a>
            </td>
            <td>
              <xsl:value-of select="title"/>
            </td>
          </tr>
        </xsl:for-each>
      </table>
    </p>

  </xsl:template>

</xsl:stylesheet>

