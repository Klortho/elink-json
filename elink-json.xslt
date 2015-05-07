<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:np="http://ncbi.gov/portal/XSLT/namespace"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0"
                exclude-result-prefixes="np">
   <xsl:import href="elink-json-suppl.xslt"/>
   <xsl:output method="text" encoding="UTF-8"/>
   <xsl:param name="pretty" select="true()"/>
   <xsl:param name="lcnames" select="true()"/>
   <xsl:param name="dtd-annotation">
      <json type="elink" version="0.3">
         <config lcnames="true"/>
      </json>
   </xsl:param>
   <xsl:template match="SubjectType | HtmlTag | WebEnv | Attribute | MenuTag | FirstChar | Name | DbTo | Priority | LinkName | Category | QueryKey | SubProvider | Info | DbFrom | NameAbbr | @LNG | @HasLinkOut | @HasNeighbor">
      <xsl:param name="context" select="&#34;unknown&#34;"/>
      <xsl:call-template name="s">
         <xsl:with-param name="context" select="$context"/>
      </xsl:call-template>
   </xsl:template>
   <xsl:template match="ERROR">
      <xsl:param name="context" select="&#34;unknown&#34;"/>
      <xsl:call-template name="s">
         <xsl:with-param name="context" select="$context"/>
         <xsl:with-param name="k" select="&#34;ERROR&#34;"/>
      </xsl:call-template>
   </xsl:template>
   <xsl:template match="IdUrlSet">
      <xsl:param name="context" select="&#34;unknown&#34;"/>
      <!--Handling itemspec <o>-->
<o>
         <xsl:if test="$context = &#34;o&#34;">
            <xsl:attribute name="k">
               <xsl:value-of select="np:translate-name()"/>
            </xsl:attribute>
         </xsl:if>
         <!--Handling itemspec <m>-->
<xsl:apply-templates select="Id">
            <xsl:with-param name="context" select="'o'"/>
         </xsl:apply-templates>
         <!--Handling itemspec <a>-->
<a k="objurls">
            <xsl:apply-templates select="ObjUrl">
               <xsl:with-param name="context" select="&#34;a&#34;"/>
            </xsl:apply-templates>
         </a>
         <!--Handling itemspec <m>-->
<xsl:apply-templates select="Info">
            <xsl:with-param name="context" select="'o'"/>
         </xsl:apply-templates>
      </o>
   </xsl:template>
   <xsl:template match="Link | LinkSetDbHistory | LinkInfo | Provider">
      <xsl:param name="context" select="&#34;unknown&#34;"/>
      <xsl:call-template name="o">
         <xsl:with-param name="context" select="$context"/>
      </xsl:call-template>
   </xsl:template>
   <xsl:template match="Url | IconUrl">
      <xsl:param name="context" select="&#34;unknown&#34;"/>
      <xsl:call-template name="o">
         <xsl:with-param name="context" select="$context"/>
         <xsl:with-param name="kids" select="@*|node()"/>
      </xsl:call-template>
   </xsl:template>
   <xsl:template match="Url/text()">
      <xsl:param name="context" select="&#34;unknown&#34;"/>
      <xsl:call-template name="s">
         <xsl:with-param name="context" select="$context"/>
      </xsl:call-template>
   </xsl:template>
   <xsl:template match="IconUrl/text()">
      <xsl:param name="context" select="&#34;unknown&#34;"/>
      <xsl:call-template name="s">
         <xsl:with-param name="context" select="$context"/>
      </xsl:call-template>
   </xsl:template>
   <xsl:template match="IdLinkSet">
      <xsl:param name="context" select="&#34;unknown&#34;"/>
      <!--Handling itemspec <o>-->
<o>
         <xsl:if test="$context = &#34;o&#34;">
            <xsl:attribute name="k">
               <xsl:value-of select="np:translate-name()"/>
            </xsl:attribute>
         </xsl:if>
         <!--Handling itemspec <n>-->
<n k="id">
            <xsl:value-of select="np:number-value(Id)"/>
         </n>
         <!--Handling itemspec <a>-->
<a k="linkinfos">
            <xsl:apply-templates select="LinkInfo">
               <xsl:with-param name="context" select="&#34;a&#34;"/>
            </xsl:apply-templates>
         </a>
      </o>
   </xsl:template>
   <xsl:template match="IdUrlList | FirstChars">
      <xsl:param name="context" select="&#34;unknown&#34;"/>
      <xsl:call-template name="a">
         <xsl:with-param name="context" select="$context"/>
      </xsl:call-template>
   </xsl:template>
   <xsl:template match="ObjUrl">
      <xsl:param name="context" select="&#34;unknown&#34;"/>
      <!--Handling itemspec <o>-->
<o>
         <xsl:if test="$context = &#34;o&#34;">
            <xsl:attribute name="k">
               <xsl:value-of select="np:translate-name()"/>
            </xsl:attribute>
         </xsl:if>
         <!--Handling itemspec <m>-->
<xsl:apply-templates select="Url|IconUrl|LinkName">
            <xsl:with-param name="context" select="'o'"/>
         </xsl:apply-templates>
         <!--Handling itemspec <a>-->
<a k="subjecttypes">
            <xsl:apply-templates select="SubjectType">
               <xsl:with-param name="context" select="&#34;a&#34;"/>
            </xsl:apply-templates>
         </a>
         <!--Handling itemspec <a>-->
<a k="categories">
            <xsl:apply-templates select="Category">
               <xsl:with-param name="context" select="&#34;a&#34;"/>
            </xsl:apply-templates>
         </a>
         <!--Handling itemspec <a>-->
<a k="attributes">
            <xsl:apply-templates select="Attribute">
               <xsl:with-param name="context" select="&#34;a&#34;"/>
            </xsl:apply-templates>
         </a>
         <!--Handling itemspec <m>-->
<xsl:apply-templates select="Provider|SubProvider">
            <xsl:with-param name="context" select="'o'"/>
         </xsl:apply-templates>
      </o>
   </xsl:template>
   <xsl:template match="Score">
      <xsl:param name="context" select="&#34;unknown&#34;"/>
      <xsl:call-template name="n">
         <xsl:with-param name="context" select="$context"/>
      </xsl:call-template>
   </xsl:template>
</xsl:stylesheet>