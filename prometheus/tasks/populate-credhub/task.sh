#!/bin/bash -eu

pushd bbl-state/${BBL_ENV}/state
eval "$(bbl print-env)"
popd
set -x
BBL_ENV_NAME="/bosh-bbl-env-${BBL_ENV}/prometheus"
credhub set -n ${BBL_ENV_NAME}/bosh_url -t value -v "${BOSH_ENVIRONMENT}"
credhub set -n ${BBL_ENV_NAME}/bosh_username -t value -v "${BOSH_CLIENT}"
credhub set -n ${BBL_ENV_NAME}/bosh_password -t value -v "${BOSH_CLIENT_SECRET}"
credhub set -n ${BBL_ENV_NAME}/bosh_ca_cert -t value -v "${BOSH_CA_CERT}"
