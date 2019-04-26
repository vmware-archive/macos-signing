#!/usr/bin/env bash

readonly TMP_DIR="$( mktemp -d )"
trap 'rm -rf -- "${TMP_DIR}"' EXIT

readonly CERT_PASS='foobar'
readonly KEY_SIZE=2048
readonly KEY_FILE_NAME="${TMP_DIR}/server.key"
readonly REQ_FILE_NAME="${TMP_DIR}/server.csr"
readonly CERT_FILE_NAME="${TMP_DIR}/server.crt"
readonly P12_FILE_NAME="${TMP_DIR}/server.p12"
readonly CERT_VALID_DAYS=10
readonly KEYCHAIN_PASS='randomPass'
readonly KEYCHAIN_NAME='signing.keychain'
readonly SIGNING_CN='SigningTests'

readonly KUBECTL_FILE_NAME='./kubectl'
