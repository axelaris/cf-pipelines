#!/bin/bash -xeu

pushd bbl-state/${BBL_ENV}/state
set +x
eval "$(bbl print-env)"
set -x
popd
arguments="-l bbl-state/${BBL_ENV}/vars/cf/bosh-vars.yml"
for op in ${OPS_FILES}
do
arguments="${arguments} -o ${op}"
done
bosh -n -d cf deploy cf-deployment/cf-deployment.yml ${arguments}
