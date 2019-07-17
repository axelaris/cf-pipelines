#!/bin/bash -eu

pushd bbl-state/${BBL_ENV}/state
eval "$(bbl print-env)"
popd

FROM="/bosh-${BBL_ENV}/cf"
TO="/bosh-${BBL_ENV}/logsearch"

CF_PASS=$(credhub get -n ${FROM}/cf_admin_password | grep ^value | awk '{print $2}')
credhub set -n ${TO}/cf_admin_password -t value -v ${CF_PASS}
UAA_PASS=$(credhub get -n ${FROM}/uaa_admin_client_secret | grep ^value | awk '{print $2}')
credhub set -n ${TO}/uaa_admin_client_secret -t value -v ${UAA_PASS}
credhub generate -n ${TO}/cf-kibana_client_secret -t password -l 10
credhub set -n ${TO}/system_domain -t value -v ${SYSTEM_DOMAIN}
