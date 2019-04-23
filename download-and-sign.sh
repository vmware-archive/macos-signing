#!/usr/bin/env bash

set -eu
set -o pipefail

curl -Lq "$KUBECTL_URL" > kubectl

echo 'donwloaded. Starting signing process ...'

security dump-keychain

codesign -s 'SigningTests' kubectl

echo 'Signing done.'
