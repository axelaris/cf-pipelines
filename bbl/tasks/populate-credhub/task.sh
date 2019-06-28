#!/bin/bash -eu

pushd bbl-state/${BBL_ENV}/state
eval "$(bbl print-env)"
popd
CA=$(credhub get -n /bosh-controlplane/concourse/atc_tls -k ca)
CERT=$(credhub get -n /bosh-controlplane/concourse/atc_tls -k certificate)
KEY=$(credhub get -n /bosh-controlplane/concourse/atc_tls -k private_key)

credhub set -n /concourse/main/bbl/tls -t certificate -p "${KEY}" -c "${CERT}" -r "${CA}"