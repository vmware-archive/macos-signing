#!/usr/bin/env bash

set -eu
set -o pipefail

getConf() {
cat <<EOF
[ req ]
prompt             = no
distinguished_name = my dn

[ my dn ]
# The bare minimum is probably a commonName
commonName = SigningTests
countryName = UK
localityName = Longon
organizationName = ACME
organizationalUnitName = SSL certs and things
stateOrProvinceName = none
emailAddress = hhorl@pivotal.io
name = Hannes Hoerl
surname = Hoerl
givenName = Hannes
initials = HH
dnQualifier = some

[ my server exts ]
keyUsage = digitalSignature
extendedKeyUsage = codeSigning
EOF
}

echo "generating the private key ..."
openssl genrsa -des3 -passout pass:foobar -out server.key 2048

echo ""
echo "generating the CSR (certificate signing request) ..."
openssl req -new -passin pass:foobar -passout pass:foobar -key server.key -out server.csr -config <( getConf ) -extensions 'my server exts'

echo ""
echo "generating the self-signed certificate ..."
openssl x509 -req -passin pass:foobar -days 10 -in server.csr -signkey server.key -out server.crt -extfile <( getConf ) -extensions 'my server exts'

echo ""
echo "convert crt + RSA private key into a PKCS12 (PFX) file ..."
openssl pkcs12 -export -passin pass:foobar -passout pass:foobar -in server.crt -inkey server.key -out server.pfx

security create-keychain -p mysecretpassword signing.keychain
security default-keychain -s signing.keychain
security unlock-keychain -p mysecretpassword signing.keychain

echo ""
echo "importing the certificate ..."
security import server.pfx -k signing.keychain -P foobar -T "$(which codesign)"


# security dump-keychain
curl -Lq "$KUBECTL_URL" > kubectl
echo "Download complete. Signing..."
codesign -s 'SigningTests' kubectl
