#!/bin/sh

echo "dams.owl -> dams.html"
xsltproc owl2html.xsl dams.owl > dams.html

echo "dams5.rdf -> dams5.html"
xsltproc rdfs2html.xsl dams5.rdf > dams5.html

echo "works.rdf -> works.html"
xsltproc rdfs2html.xsl works.rdf > works.html
