#!/bin/bash -eu

pushd bbl-state/${BBL_ENV}/state
eval "$(bbl print-env)"
popd
set -x
CH="/bosh-bbl-env-${BBL_ENV}"
CHP="${CH}/prometheus"
credhub set -n ${CHP}/bosh_url -t value -v "${BOSH_ENVIRONMENT}"
credhub set -n ${CHP}/bosh_username -t value -v "${BOSH_CLIENT}"
credhub set -n ${CHP}/bosh_password -t value -v "${BOSH_CLIENT_SECRET}"
credhub set -n ${CHP}/bosh_ca_cert -t value -v "${BOSH_CA_CERT}"

PW=$(credhub get -n ${CH}/cf/uaa_clients_cf_exporter_secret | grep ^value | awk '{print $2}')
credhub set -n ${CHP}/uaa_clients_cf_exporter_secret -t value -v ${PW}

PW=$(credhub get -n ${CH}/cf/uaa_clients_firehose_exporter_secret | grep ^value | awk '{print $2}')
credhub set -n ${CHP}/uaa_clients_firehose_exporter_secret -t value -v ${PW}