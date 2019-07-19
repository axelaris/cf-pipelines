#!/bin/bash -xeu

pushd bbl-state/${BBL_ENV}/state
set +x
eval "$(bbl print-env)"
set -x
popd
arguments="-l bbl-state/${BBL_ENV}/vars/mysql/bosh-vars.yml"
OPS_FILES=$(cat bbl-state/${BBL_ENV}/vars/mysql/ops-files)
for op in ${OPS_FILES}
do
arguments="${arguments} -o cf-mysql-deployment/operations/${op}"
done
bosh -n -d cf-mysql deploy cf-mysql-deployment/cf-mysql-deployment.yml ${arguments}
