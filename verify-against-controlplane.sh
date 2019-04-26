#!/usr/bin/env bash

set -eu
set -o pipefail

# shellcheck source=./shared.inc.sh
. "$(dirname "${BASH_SOURCE[0]}")/shared.inc.sh"

echo "getting the integration testing framework ..."
go get -v -u sigs.k8s.io/testing_frameworks/integration

"${GOPATH}/src/sigs.k8s.io/testing_frameworks/integration/scripts/download-binaries.sh"

export TEST_ASSET_KUBECTL="${KUBECTL_FILE_NAME}"

go run ./verify-against-controlplane.go
