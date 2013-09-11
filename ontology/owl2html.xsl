<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <xsl:output method="html"/>
  <xsl:variable name="title" select="/rdf:RDF/owl:Ontology/rdfs:label"/>
  <xsl:variable name="about" select="/rdf:RDF/owl:Ontology/@rdf:about"/>
  <xsl:template match="/">
    <html>
      <head>
        <title><xsl:value-of select="$title"/></title>
        <style>
          h4 { margin-bottom: 0.25em; }
          body { font-family: sans-serif; }
          .about { font-family: monospace; margin-left: 1em; }
          .label { margin-left: 1em; font-style:italic; }
          .comment { margin-left: 1em; }
          .property { margin-left: 1em; }
        </style>
      </head>
      <body>
        <h1><xsl:value-of select="$title"/></h1>
        <div class="about"><xsl:value-of select="$about"/></div>
        <xsl:for-each select="/rdf:RDF/owl:Ontology/rdfs:comment">
          <div class="comment"><xsl:value-of select="."/></div>
        </xsl:for-each>

        <div class="table-of-contents">
          <h2>Table of Contents</h2>
          <xsl:if test="/rdf:RDF/owl:Class">
            <h3>Classes</h3>
            <xsl:for-each select="/rdf:RDF/owl:Class">
              <xsl:sort select="@rdf:about"/>
              <xsl:call-template name="link"/>
            </xsl:for-each>
          </xsl:if>

          <xsl:if test="/rdf:RDF/owl:ObjectProperty">
            <h3>Object Properties</h3>
            <xsl:for-each select="/rdf:RDF/owl:ObjectProperty">
              <xsl:sort select="@rdf:about"/>
              <xsl:call-template name="link"/>
            </xsl:for-each>
          </xsl:if>

          <xsl:if test="/rdf:RDF/owl:DatatypeProperty">
            <h3>Datatype Properties</h3>
            <xsl:for-each select="/rdf:RDF/owl:DatatypeProperty">
              <xsl:sort select="@rdf:about"/>
              <xsl:call-template name="link"/>
            </xsl:for-each>
          </xsl:if>
        </div>

        <div class="contents">
          <h2>Entity Definitions</h2>
          <xsl:if test="/rdf:RDF/owl:Class">
            <h3>Classes</h3>
            <xsl:for-each select="/rdf:RDF/owl:Class">
              <xsl:sort select="@rdf:about"/>
              <xsl:call-template name="description"/>
            </xsl:for-each>
          </xsl:if>

          <xsl:if test="/rdf:RDF/owl:ObjectProperty">
            <h3>Object Properties</h3>
            <xsl:for-each select="/rdf:RDF/owl:ObjectProperty">
              <xsl:sort select="@rdf:about"/>
              <xsl:call-template name="description"/>
            </xsl:for-each>
          </xsl:if>

          <xsl:if test="/rdf:RDF/owl:DatatypeProperty">
            <h3>Datatype Properties</h3>
            <xsl:for-each select="/rdf:RDF/owl:DatatypeProperty">
              <xsl:sort select="@rdf:about"/>
              <xsl:call-template name="description"/>
            </xsl:for-each>
          </xsl:if>
        </div>
      </body>
    </html>
  </xsl:template>
  <xsl:template name="link">
    <xsl:variable name="id">
      <xsl:choose>
        <xsl:when test="@rdf:about and contains(@rdf:about,$about)">
          <xsl:value-of select="substring-after(@rdf:about,$about)"/>
        </xsl:when>
        <xsl:when test="@rdf:resource and contains(@rdf:resource,$about)">
          <xsl:value-of select="substring-after(@rdf:resource,$about)"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$id != ''">
        <a href="#{$id}"><xsl:value-of select="$id"/></a>
      </xsl:when>
      <xsl:when test="contains(@rdf:resource,'http://www.loc.gov/mads/rdf/v1#')">
        <a href="{@rdf:resource}">mads:<xsl:value-of select="substring-after(@rdf:resource,'#')"/></a>
      </xsl:when>
      <xsl:when test="contains(@rdf:about,'http://www.loc.gov/mads/rdf/v1#')">
        <a href="{@rdf:about}">mads:<xsl:value-of select="substring-after(@rdf:about,'#')"/></a>
      </xsl:when>
      <xsl:when test="contains(@rdf:resource,'http://www.w3.org/2001/XMLSchema#')">
        <a href="{@rdf:resource}">xsd:<xsl:value-of select="substring-after(@rdf:resource,'#')"/></a>
      </xsl:when>
      <xsl:when test="owl:Class/owl:unionOf">
        <xsl:for-each select="owl:Class/owl:unionOf/*">
              <xsl:call-template name="link"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="descendant::*[rdf:type/@rdf:resource='http://www.w3.org/1999/02/22-rdf-syntax-ns#List']">
        <xsl:for-each select="descendant::rdf:Description">
          <xsl:if test="position() &gt; 1">, </xsl:if>
          <xsl:value-of select="rdf:first"/>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
    <xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template name="description">
    <xsl:if test="contains(@rdf:about, $about)">
      <xsl:variable name="id" select="substring-after(@rdf:about,$about)"/>
      <xsl:variable name="subj" select="@rdf:about"/>
      <div id="{$id}">
        <h4><xsl:value-of select="$id"/></h4>
        <xsl:if test="rdfs:label">
          <div class="label"><xsl:value-of select="rdfs:label"/></div>
        </xsl:if>
        <xsl:for-each select="rdfs:comment">
          <div class="comment"><xsl:value-of select="."/></div>
        </xsl:for-each>
        <div class="property">type:
          <xsl:value-of select="substring-after(name(),'owl:')"/>
        </div>
        <xsl:if test="rdfs:subClassOf[@rdf:resource]">
          <div class="property">subclass of:
            <xsl:for-each select="rdfs:subClassOf[@rdf:resource]">
              <xsl:call-template name="link"/>
            </xsl:for-each>
          </div>
        </xsl:if>
        <xsl:if test="//*[rdfs:subClassOf/@rdf:resource = $subj]">
          <div class="property">has subclasses:
            <xsl:for-each select="//*[rdfs:subClassOf/@rdf:resource = $subj]">
              <xsl:call-template name="link"/>
            </xsl:for-each>
          </div>
        </xsl:if>
        <xsl:if test="rdfs:subPropertyOf">
          <div class="property">sub-property of:
            <xsl:for-each select="rdfs:subPropertyOf">
              <xsl:call-template name="link"/>
            </xsl:for-each>
          </div>
        </xsl:if>
        <xsl:if test="//*[contains(rdfs:range/@rdf:resource,$id)]">
          <div class="property">used with:
            <xsl:for-each select="//*[contains(rdfs:range/@rdf:resource,$id)]">
              <xsl:sort select="@rdf:about"/>
              <xsl:call-template name="link"/>
            </xsl:for-each>
          </div>
        </xsl:if>
        <xsl:if test="rdfs:subClassOf[not(@rdf:resource)]/owl:Restriction[owl:minQualifiedCardinality|owl:maxQualifiedCardinality|owl:minQualifiedCardinality]">
          <div class="property">properties:
            <xsl:for-each select="rdfs:subClassOf[not(@rdf:resource)]/owl:Restriction[owl:minQualifiedCardinality|owl:maxQualifiedCardinality|owl:minQualifiedCardinality]">
              <xsl:sort select="owl:onProperty/@rdf:resource"/>
              <xsl:if test="position() &gt; 1">, </xsl:if>
              <xsl:variable name="only" select="owl:minQualifiedCardinality"/>
              <xsl:variable name="min">
                <xsl:choose>
                  <xsl:when test="owl:minQualifiedCardinality">
                    <xsl:value-of select="owl:minQualifiedCardinality"/>
                  </xsl:when>
                  <xsl:otherwise>0</xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:variable name="max">
                <xsl:choose>
                  <xsl:when test="owl:maxQualifiedCardinality">
                    <xsl:value-of select="owl:maxQualifiedCardinality"/>
                  </xsl:when>
                  <xsl:otherwise>m</xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:for-each select="owl:onProperty">
                <xsl:call-template name="link"/>
              </xsl:for-each>
              <xsl:text>(</xsl:text>
              <xsl:choose>
                <xsl:when test="$only != ''">
                  <xsl:value-of select="$only"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$min"/>-<xsl:value-of select="$max"/>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:text>)</xsl:text>
            </xsl:for-each>
          </div>
        </xsl:if>
        <xsl:if test="rdfs:domain">
          <div class="property">
            domain:
            <xsl:for-each select="rdfs:domain">
              <xsl:call-template name="link"/>
            </xsl:for-each>
          </div>
        </xsl:if>
        <xsl:if test="rdfs:range">
          <div class="property">
            range:
            <xsl:for-each select="rdfs:range">
              <xsl:call-template name="link"/>
            </xsl:for-each>
          </div>
        </xsl:if>
      </div>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
