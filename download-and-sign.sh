#!/usr/bin/env bash

set -eu
set -o pipefail

curl -Lq "$KUBECTL_URL" > kubectl

codesign -s 'SigningTests' kubectl
