#!/usr/bin/env bash

set -eu
set -o pipefail

curl -Lq "$KUBECTL_URL" > kubectl

echo 'donwloaded. Starting signing process ...'

codesign -s 'SigningTests' kubectl

echo 'Signing done.'
