#!/bin/bash

SOLR_HOME=/apps/solr/solr

# basic subject alternative names
SANS=DNS:localhost,IP:127.0.0.1
# get extra SANs from the command line
EXTRA_SANS=$1
# subject DN
DN="CN=$(hostname), OU=SSDR, O=UMD Libraries, L=College Park, ST=MD, C=US"
# passwords
KEY_PASSWORD=changeme
STORE_PASSWORD=changeme

if [ -e /apps/dist ]; then
    # persistant keystore location
    KEYSTORE=/apps/dist/solr-ssl.keystore.jks
else
    # transient location
    KEYSTORE="$SOLR_HOME"/solr-ssl.keystore.jks
fi

# append extra SANs, if any were provided
if [ -n "$EXTRA_SANS" ]; then
    SANS="$SANS","$EXTRA_SANS"
fi

# only generate this cert once then cache in /apps/dist; that way there won't be
# repeated prompts to enable a security exception in the browser
if [ ! -e "$KEYSTORE" ]; then
    keytool -genkeypair -alias solr-ssl -keyalg RSA -keysize 2048 \
        -keypass "$KEY_PASSWORD" -storepass "$STORE_PASSWORD" -validity 9999 \
        -keystore "$KEYSTORE" -ext SAN="$SANS" -dname "$DN"
fi

cp "$KEYSTORE" "$SOLR_HOME"
