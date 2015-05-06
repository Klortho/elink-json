<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:np="http://ncbi.gov/portal/XSLT/namespace"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
  <xsl:import href="xml2json.xsl"/>

  <!-- 
    <Id> is special. 99% of the time, it appears without any attributes, so we'll write it to JSON
    as a simple number. But when any Id of a group of Ids includes an attribute (either @HasLinkOut
    or @HasNeighbor), then all of the Ids in that group must be written as objects.
    
    The following template only ever matches an Id when it appears by itself, not as a group.
    That happens inside Link, Provider, IdUrlSet, and IdLinkSet. 
    
    In those cases where Ids appear as a group, inside IdList or IdCheckList, see the custom templates for 
    those elements.
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
          <xsl:value-of select="'id'"/>
        </xsl:attribute>
      </xsl:if>
      <n k="value">
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
        <xsl:when test="Id[@*]">
          <xsl:for-each select="Id">
            <xsl:call-template name="id-as-object">
              <xsl:with-param name="context" select="'a'"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="Id">
            <xsl:call-template name="id-as-number">
              <xsl:with-param name="context" select="'a'"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </xsl:template>


  <!-- 
    <IdList> - This calls the id-group template, to ensure that all of the Id children are
    rendered the same way - either as a number or as an object.
  -->
  <xsl:template match="IdList">
    <xsl:param name="context" select="'unknown'"/>
    <xsl:call-template name="id-group">
      <xsl:with-param name="context" select="$context"/>
    </xsl:call-template>
  </xsl:template>

  <!--
    <LinkSetDb> - This custom template allows us to handle the Link children specially. Most often,
    a Link element will just have a single Id child. If that's the case for all of the Link children
    here, then we'll render them as an array of numbers. But if any of the Link children have a
    Score, then we'll render them all as objects.
  -->

  <xsl:template match="LinkSetDb">
    <xsl:param name="context" select="'unknown'"/>
    <o>
      <xsl:if test="$context = 'o'">
        <xsl:attribute name="k">
          <xsl:value-of select="'linksetdb'"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select='DbTo|LinkName|Info'>
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
      <xsl:apply-templates select='ERROR'>
        <xsl:with-param name="context" select="'o'"/>
      </xsl:apply-templates>
    </o>
  </xsl:template>

  <!-- 
    <IdCheckList> - This calls the id-group template, to ensure that all of the Id children are
    rendered the same way - either as a number or as an object.
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

  <!-- 
    <LinkSet> - context is array (these always appear inside a "linksets" array)
    The content model allows for ERROR elements in several places. This puts them all at the end, and
    renders them either as a single `ERROR` string (if there's only one) or an array of ERRORS. 
  -->
  <xsl:template match="LinkSet">
    <o>
      <xsl:apply-templates select="DbFrom|IdList">
        <xsl:with-param name="context" select="'o'"/>
      </xsl:apply-templates>
      <xsl:if test='LinkSetDb'>
        <a k='linksetdbs'>
          <xsl:apply-templates select="LinkSetDb">
            <xsl:with-param name="context" select="'a'"/>
          </xsl:apply-templates>
        </a>
      </xsl:if>
      <xsl:if test='LinkSetDbHistory'>
        <a k='linksetdbhistories'>
          <xsl:apply-templates select="LinkSetDbHistory">
            <xsl:with-param name="context" select="'a'"/>
          </xsl:apply-templates>
        </a>
      </xsl:if>
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

  <!-- 
    <eLinkResult> - Flatten the contents of this into the top-level object.
  -->

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
