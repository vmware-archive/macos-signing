#!/usr/bin/env bash

set -eu
set -o pipefail

# shellcheck source=./shared.inc.sh
. "$(dirname "${BASH_SOURCE[0]}")/shared.inc.sh"




curl -Lq "$KUBECTL_URL" > kubectl

echo 'donwloaded. Starting signing process ...'

codesign --keychain "${KEYCHAIN_NAME}" \
  --force --verbose -s "${SIGNING_CN}" \
  kubectl

echo 'Signing done.'
