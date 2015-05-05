<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:np="http://ncbi.gov/portal/XSLT/namespace"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
  <xsl:import href="xml2json.xsl"/>

  <!-- 
    <Id> is special. 99% of the time, it appears without any attributes, so we'll write it to JSON
    as a simple number. But when any of the siblings contain an attribute, then all of the Ids in
    this collection must be written as objects.
    
    The following template only ever matches an Id when it appears by itself, not as a group.
    That happens inside (Link, Provider, IdUrlSet,
    IdLinkSet. 
    
    In those cases where Ids appear as a group (IdList or IdCheckList),
    see the custom templates for those elements.
  -->
  <xsl:template match='Id'>
    <xsl:param name="context" select="'unknown'"/>
    <xsl:choose>
      <xsl:when test='not(@*)'>
        <xsl:call-template name="id-as-number">
          <xsl:with-param name="context" select="$context"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="id-as-object">
          <xsl:with-param name="context" select="$context"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- 
    id-as-number - write out an Id as a simple number.
  -->
  <xsl:template name="id-as-number">
    <xsl:param name="context" select="'unknown'"/>
    <n>
      <xsl:if test="$context = 'o'">
        <xsl:attribute name="k">
          <xsl:value-of select="'id'"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:value-of select="normalize-space(.)"/>
    </n>
  </xsl:template>

  <!-- 
    id-as-object - write an Id element and its attributes as a JSON object
  -->
  <xsl:template name="id-as-object">
    <xsl:param name="context" select="'unknown'"/>
    <o>
      <xsl:if test="$context = 'o'">
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
  </xsl:template>

  <!-- 
    id-group - this named template is called from the templates that match IdList or IdCheckList, where
    a group of child Id elements can appear.  They will all either be written as numbers or as objects.
  -->
  <xsl:template name='id-group'>
    <xsl:param name="context" select="'unknown'"/>
    <a>
      <xsl:if test="$context = 'o'">
        <xsl:attribute name="k">
          <xsl:value-of select="'ids'"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="Id[@HasLinkOut or @HasNeighbor]">
          <xsl:for-each select="Id">
            <xsl:call-template name="id-as-object">
              <xsl:with-param name="context" select="'a'"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="id-as-number">
            <xsl:with-param name="context" select="'a'"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </xsl:template>


  <!-- 
    <IdList>
  -->
  <xsl:template match="IdList">
    <xsl:param name="context" select="'unknown'"/>
    <xsl:call-template name="id-group">
      <xsl:with-param name="context" select="$context"/>
    </xsl:call-template>
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

  <!-- 
    <IdCheckList>
  -->
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
          <xsl:call-template name="id-group">
            <xsl:with-param name='context' select='"o"'/>
          </xsl:call-template>
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
      <xsl:apply-templates select="Id">
        <xsl:with-param name="context" select="'o'"/>
      </xsl:apply-templates>
      <xsl:choose>
        <xsl:when test="ObjUrl">
          <a k='objurls'>
            <xsl:apply-templates select="ObjUrl">
              <xsl:with-param name="context" select="'a'"/>
            </xsl:apply-templates>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="Info">
            <xsl:with-param name="context" select="'o'"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </o>
  </xsl:template>

  <!-- 
    LinkSet: context is array (these always appear inside a "linksets" array)
    
  -->
  <xsl:template match="LinkSet">
    <o>
      <xsl:apply-templates select="DbFrom|IdList">
        <xsl:with-param name="context" select="'o'"/>
      </xsl:apply-templates>
      <a k='linksetdbs'>
        <xsl:apply-templates select="LinkSetDb">
          <xsl:with-param name="context" select="'a'"/>
        </xsl:apply-templates>
      </a>
      <a k='linksetdbhistories'>
        <xsl:apply-templates select="LinkSetDbHistory">
          <xsl:with-param name="context" select="'a'"/>
        </xsl:apply-templates>
      </a>
      <xsl:apply-templates select="WebEnv|IdUrlList|IdCheckList">
        <xsl:with-param name="context" select="'o'"/>
      </xsl:apply-templates>
      <xsl:choose>
        <xsl:when test="count(ERROR) > 1">
          <a k='ERRORS'>
            <xsl:apply-templates select="ERROR">
              <xsl:with-param name="context" select="'a'"/>
            </xsl:apply-templates>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="ERROR">
            <xsl:with-param name="context" select="'o'"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </o>
  </xsl:template>



  <xsl:template match="eLinkResult">
    <xsl:param name="context" select="'unknown'"/>
    <a k='linksets'>
      <xsl:apply-templates select="LinkSet">
        <xsl:with-param name="context" select="'a'"/>
      </xsl:apply-templates>
    </a>
    <xsl:apply-templates select='ERROR'>
      <xsl:with-param name='context' select='"o"'/>
    </xsl:apply-templates>
  </xsl:template>
</xsl:stylesheet>
