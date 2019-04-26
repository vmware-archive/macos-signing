#!/usr/bin/env bash

set -eu
set -o pipefail

# shellcheck source=./shared.inc.sh
. "$(dirname "${BASH_SOURCE[0]}")/shared.inc.sh"

readonly SSL_EXT_NAME='code sign ext'

getConf() {
cat <<EOF
[ req ]
prompt = no
distinguished_name = distinguished name

[ distinguished name ]
commonName = ${SIGNING_CN}
countryName = UK
localityName = London
organizationName = ACME
organizationalUnitName = SSL certs and things
emailAddress = nospam@mailinator.com
name = We and Us

[ ${SSL_EXT_NAME} ]
keyUsage = digitalSignature
extendedKeyUsage = codeSigning
EOF
}

echo "generating the private key ..."
openssl genrsa \
  -des3 -passout "pass:${CERT_PASS}" \
  -out "${KEY_FILE_NAME}" "${KEY_SIZE}"

echo ""
echo "generating the csr ..."
openssl req \
  -new -passin "pass:${CERT_PASS}" \
  -passout "pass:${CERT_PASS}" -key "${KEY_FILE_NAME}" \
  -out "${REQ_FILE_NAME}" \
  -config <( getConf ) -extensions "${SSL_EXT_NAME}"

echo ""
echo "generating the self-signed certificate ..."
openssl x509 \
  -req -passin "pass:${CERT_PASS}" -days "${CERT_VALID_DAYS}" \
  -in "${REQ_FILE_NAME}" -signkey "${KEY_FILE_NAME}" \
  -out "${CERT_FILE_NAME}" \
  -extfile <( getConf ) -extensions "${SSL_EXT_NAME}"

echo ""
echo "converting to pkcs12 ..."
openssl pkcs12 \
  -export -passin "pass:${CERT_PASS}" \
  -passout "pass:${CERT_PASS}" \
  -in "${CERT_FILE_NAME}" -inkey "${KEY_FILE_NAME}" \
  -out "${P12_FILE_NAME}"

echo ""
echo "setting up new keychain '${KEYCHAIN_NAME}' ..."
security create-keychain -p "${KEYCHAIN_PASS}" "${KEYCHAIN_NAME}"
security default-keychain -s "${KEYCHAIN_NAME}"
security unlock-keychain -p "${KEYCHAIN_PASS}" "${KEYCHAIN_NAME}"

echo ""
echo "importing pkcs12 into keychain ..."
security import \
  "${P12_FILE_NAME}" -k "${KEYCHAIN_NAME}" -P "${CERT_PASS}" \
  -T "$(command -v codesign)"

echo ""
echo "allowing codsign tools access to the keychain ..."
security set-key-partition-list \
  -S apple-tool:,apple:,codesign: -s -k "${KEYCHAIN_PASS}" \
  "${KEYCHAIN_NAME}"

