#!/bin/sh

echo "dams.owl -> dams.html"
xsltproc owl2html.xsl dams.owl > dams.html

echo "dams4.2.rdf -> dams4.2.html"
xsltproc rdfs2html.xsl dams4.2.rdf > dams4.2.html

echo "works.rdf -> works.html"
xsltproc rdfs2html.xsl works.rdf > works.html
