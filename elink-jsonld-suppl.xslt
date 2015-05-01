<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
  <xsl:import href="xml2json.xsl"/>

  <xsl:template match="LinkSetDb">
    <xsl:param name="context" select="'unknown'"/>
    <o>
      <xsl:if test="$context = 'o'">
        <xsl:attribute name="k">
          <xsl:value-of select="'linksetdb'"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select='DbTo|LinkName|Info|ERROR'>
        <xsl:with-param name="context" select="'o'"/>
      </xsl:apply-templates>
      <xsl:if test='Link'>
        <a k="links">
          <xsl:apply-templates select="Link">
            <xsl:with-param name="context" select="'a'"/>
          </xsl:apply-templates>
        </a>
      </xsl:if>
    </o>
  </xsl:template>

</xsl:stylesheet>
