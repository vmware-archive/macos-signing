#!/usr/bin/env bash

set -eu
set -o pipefail

# shellcheck source=./shared.inc.sh
. "$(dirname "${BASH_SOURCE[0]}")/shared.inc.sh"

echo "downloading kubectl ..."
curl -Lq "$KUBECTL_URL" > "${KUBECTL_FILE_NAME}"

echo ""
echo 'signing kubectl ...'
codesign --keychain "${KEYCHAIN_NAME}" \
  --force --verbose -s "${SIGNING_CN}" \
  "${KUBECTL_FILE_NAME}"
