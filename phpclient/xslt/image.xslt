<?xml version="1.0" encoding="ISO-8859-1" ?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:template name="image">
  <xsl:param name="src"/>
   
  <xsl:choose>
    <xsl:when test="$src=':/images/type_bug.png'">
       <img src="/wolfzilla/images/type_bug.png" alt="Bug" height="16" width="16"/>
    </xsl:when>
    <xsl:when test="$src=':/images/type_improvement.png'">
       <img src="/wolfzilla/images/type_improvement.png" alt="Bug" height="16" width="16"/>
    </xsl:when>
    <xsl:when test="$src=':/images/type_new_feature.png'">
       <img src="/wolfzilla/images/type_new_feature.png" alt="Bug" height="16" width="16"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
