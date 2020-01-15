#!/bin/bash -eu

pushd bbl-state/${BBL_ENV}/state
eval "$(bbl print-env)"
popd

FROM="/bosh-${BBL_ENV}/cf"
TO="/bosh-${BBL_ENV}/logsearch"

for KEY in \
  cf_admin_password \
  uaa_admin_client_secret \
  kibana_oauth2_client_secret \
  uaa_clients_firehose_to_syslog_secret;
  do
  VALUE=$(credhub get -n ${FROM}/${KEY} | grep ^value | awk '{print $2}')
  credhub set -n ${TO}/${KEY} -t value -v ${VALUE}
done

credhub generate -n ${TO}/cf-kibana_client_secret -t password -l 10
credhub set -n ${TO}/system_domain -t value -v ${SYSTEM_DOMAIN}
