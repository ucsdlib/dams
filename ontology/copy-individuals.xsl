<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <xsl:output method="xml" indent="yes"/>

  <!-- recursively copy everything by default -->
  <xsl:template match="@*|node()">
    <xsl:copy select=".">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- suppress extra space -->
  <xsl:template match="text()">
    <xsl:if test="normalize-space(.) != ''">
      <xsl:value-of select="."/>
    </xsl:if>
  </xsl:template>

  <!-- suppress owl and comments -->
  <xsl:template match="owl:Class"/>
  <xsl:template match="owl:DatatypeProperty"/>
  <xsl:template match="owl:ObjectProperty"/>
  <xsl:template match="owl:Ontology"/>
  <xsl:template match="comment()"/>
</xsl:stylesheet>
