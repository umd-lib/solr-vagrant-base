#!/bin/bash

SERVICE_USER_GROUP=vagrant:vagrant

# https://wiki.duraspace.org/display/FEDORA4x/Solr+Indexing+Quick+Guide#SolrIndexingQuickGuide-Install,ConfigureandStartSolr

# Solr
SOLR_VERSION=6.4.0
SOLR_TGZ=/apps/dist/solr-${SOLR_VERSION}.tgz
# look for a cached tarball
if [ ! -e "$SOLR_TGZ" ]; then
    SOLR_PKG_URL=http://archive.apache.org/dist/lucene/solr/${SOLR_VERSION}/solr-${SOLR_VERSION}.tgz
    curl -Lso "$SOLR_TGZ" "$SOLR_PKG_URL"
fi
tar xvzf "$SOLR_TGZ" --directory /apps

SOLR_INSTALL=/apps/solr-${SOLR_VERSION}
mkdir -p /apps/solr
cp -rp "$SOLR_INSTALL/server/solr" /apps/solr
SOLR_HOME=/apps/solr/solr

mkdir -p "$SOLR_HOME"
mkdir -p "$SOLR_HOME/cores"
mkdir -p /apps/ca

chown -R "$SERVICE_USER_GROUP" /apps/solr /apps/ca
