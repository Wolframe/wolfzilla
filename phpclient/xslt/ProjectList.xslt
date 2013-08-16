<?xml version="1.0" encoding="ISO-8859-1" ?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  
  <xsl:output method="html" version="1.1" encoding="UTF-8" indent="no"/>

  <xsl:include href="page.inc.xslt"/>
  <xsl:include href="image.xslt"/>

  <xsl:template match="/page">
    <xsl:call-template name="page">
      <xsl:with-param name="base" select="/page/@base"/>
      <xsl:with-param name="title" select="'List of projects'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="projects">
    <h2>List of projects</h2>
    <p>
      <table>
        <xsl:for-each select="project">
          <tr>
            <td>
              <a href="{/page/@self}issues/{shortcut}"><xsl:value-of select="shortcut"/></a>
            </td>
            <td>
              <xsl:value-of select="description"/>
            </td>
          </tr>
        </xsl:for-each>
      </table>
    </p>
  </xsl:template>
  
</xsl:stylesheet>
