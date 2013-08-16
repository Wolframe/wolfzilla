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
      <xsl:with-param name="title" select="concat($reference, ' - ', $title)"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="issue">
    <h2><xsl:value-of select="reference"/></h2>
    <p>
      <table>
        <tr>
          <td id="label">Created:
          </td>
          <td>
            <xsl:value-of select="creationDate"/>
          </td>
        </tr>
        <tr>
          <td id="label">Last Modification:
          </td>
          <td>
            <xsl:value-of select="lastModDate"/>
          </td>
        </tr>
        <tr>
          <td id="label">Title:
          </td>
          <td>
            <xsl:value-of select="title"/>
          </td>
        </tr>
        <tr>
          <td id="label">Type:
          </td>
          <td>
              <xsl:call-template name="image">
                <xsl:with-param name="src" select="typeIcon"/>
              </xsl:call-template>      
            <xsl:value-of select="typeName"/>
          </td>
        </tr>
        <tr>
          <td id="label">State:
          </td>
          <td>
            <xsl:value-of select="stateName"/>
          </td>
        </tr>
        <tr>
          <td id="label">Severity:
          </td>
          <td>
              <xsl:call-template name="image">
                <xsl:with-param name="src" select="severityIcon"/>
              </xsl:call-template>      
            <xsl:value-of select="severityName"/>
          </td>
        </tr>
        <tr>
          <td id="label">Priority:
          </td>
          <td>
            <xsl:value-of select="priorityName"/>
          </td>
        </tr>
        <tr>
          <td id="label">Reporter:
          </td>
          <td>
            <xsl:value-of select="reporterName"/>
          </td>
        </tr>
        <tr>
          <td id="label">Description:
          </td>
          <td id="description">
            <xsl:value-of select="description"/>
          </td>
        </tr>
      </table>
    </p>
  </xsl:template>
  
</xsl:stylesheet>
