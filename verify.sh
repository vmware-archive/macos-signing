#!/usr/bin/env bash

set -eu
set -o pipefail

# shellcheck source=./shared.inc.sh
. "$(dirname "${BASH_SOURCE[0]}")/shared.inc.sh"

readonly certPrefix="${KUBECTL_FILE_NAME}.signing-cert."

echo "displaying & valiudating code signature ..."
codesign -d -v -v -v \
  --extract-certificates="${certPrefix}" \
  --requirements=- \
  --entitlements=- \
  "${KUBECTL_FILE_NAME}"

echo ""
echo "inspecting signing certificate ..."
openssl x509 -inform DER -in "${certPrefix}0" -noout -text
