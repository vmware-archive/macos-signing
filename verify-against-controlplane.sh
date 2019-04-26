#!/usr/bin/env bash

set -eu
set -o pipefail

# shellcheck source=./shared.inc.sh
. "$(dirname "${BASH_SOURCE[0]}")/shared.inc.sh"

echo "getting the integration testing framework ..."
go get -u sigs.k8s.io/testing_frameworks/integration

"${GOPATH}/src/sigs.k8s.io/testing_frameworks/integration/scripts/download-binaries.sh"

echo ""
echo "configure testframework to use the local kubectl ..."
export TEST_ASSET_KUBECTL="${KUBECTL_FILE_NAME}"

kubectlTest() {
  go run ./verify-against-controlplane.go "$@"
}

echo ""
echo "Test if we can connect to the controlplane ..."
kubectlTest version

echo ""
echo "Test if we can read from disk ..."
kubectlTest apply -f ./testdata/some-namespace.yml

echo ""
echo "Test if we can write to disk ..."
kubectlTest cluster-info dump --output-directory=./output/cluster.dump
