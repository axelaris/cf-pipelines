#!/bin/bash -eux

pushd bbl-state/${BBL_ENV}/state
set +x
eval "$(bbl print-env)"
set -x
popd

SUFFIX="/bosh-${BBL_ENV}/logsearch"
for KEY in \
  cf_admin_password \
  uaa_admin_client_secret \
  cf-kibana_client_secret \
  kibana_oauth2_client_secret \
  system_domain;
  do
  credhub delete -n ${SUFFIX}/${KEY}
done

bosh -n -d logsearch delete-deployment
