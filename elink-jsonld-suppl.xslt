<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
  <xsl:import href="xml2json.xsl"/>

  <xsl:param name='ids-as-numbers' 
    select='not(//Id[@HasLinkOut or @HasNeighbor])'/>

  <xsl:template match='Id'>
    <xsl:param name="context" select="&#34;unknown&#34;"/>
    <xsl:message>
      <xsl:text>ids-as-numbers = </xsl:text>
      <xsl:value-of select='$ids-as-numbers'/>
    </xsl:message>
    <xsl:choose>
      <xsl:when test='$ids-as-numbers'>
        <n>
          <xsl:if test="$context = 'o'">
            <xsl:attribute name="k">
              <xsl:value-of select="'id'"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:value-of select="normalize-space(.)"/>
        </n>
      </xsl:when>
      <xsl:otherwise>
        <o>
          <xsl:if test="$context = &#34;o&#34;">
            <xsl:attribute name="k">
              <xsl:value-of select="np:translate-name()"/>
            </xsl:attribute>
          </xsl:if>
          <n k="id">
            <xsl:value-of select="normalize-space(.)"/>
          </n>
          <xsl:apply-templates select="@*">
            <xsl:with-param name="context" select="'o'"/>
          </xsl:apply-templates>
        </o>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

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
          <xsl:choose>
            <!--
              If any of the links has a score, then render them all as JSON
              objects. Otherwise, just render a list of IDs.
            -->
            <xsl:when test='Link/Score'>
              <xsl:apply-templates select="Link">
                <xsl:with-param name="context" select="'a'"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="Link/Id">
                <xsl:with-param name="context" select="'a'"/>
              </xsl:apply-templates>
            </xsl:otherwise>
          </xsl:choose>
        </a>
      </xsl:if>
    </o>
  </xsl:template>

  <xsl:template match="IdCheckList">
    <xsl:param name="context" select="'unknown'"/>
    <o>
      <xsl:if test="$context = 'o'">
        <xsl:attribute name="k">
          <xsl:value-of select="'idchecklist'"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:choose>
        <xsl:when test='Id'>
          <a k="ids">
            <xsl:apply-templates select='Id'>
              <xsl:with-param name='context' select='"a"'/>
            </xsl:apply-templates>
          </a>
        </xsl:when>
        <xsl:when test='IdLinkSet'>
          <a k="idlinksets">
            <xsl:apply-templates select='IdLinkSet'>
              <xsl:with-param name='context' select='"a"'/>
            </xsl:apply-templates>
          </a>
        </xsl:when>
      </xsl:choose>
      <xsl:apply-templates select='ERROR'>
        <xsl:with-param name='context' select='"o"'/>
      </xsl:apply-templates>
    </o>
  </xsl:template>

  <xsl:template match='IdUrlSet'>
    <xsl:param name="context" select="'unknown'"/>
    <o>
      <xsl:if test="$context = 'o'">
        <xsl:attribute name="k">
          <xsl:value-of select="'idchecklist'"/>
        </xsl:attribute>
      </xsl:if>
    </o>
  </xsl:template>
</xsl:stylesheet>
