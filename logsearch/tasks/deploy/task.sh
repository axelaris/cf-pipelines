#!/bin/bash -eux

pushd bbl-state/${BBL_ENV}/state
set +x
eval "$(bbl print-env)"
popd
set -x

arguments="-l bbl-state/${BBL_ENV}/vars/logsearch/bosh-vars.yml"
OPS_FILES=$(cat bbl-state/${BBL_ENV}/vars/logsearch/ops-files | grep -v ^#)
for op in ${OPS_FILES}
do
  arguments="${arguments} -o logsearch-boshrelease/deployment/${op}"
done

bosh -n -d logsearch deploy logsearch-boshrelease/deployment/logsearch-deployment.yml ${arguments}
