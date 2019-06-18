#!/bin/bash -xeu

pushd bbl-state/${BBL_ENV}/state
set +x
eval "$(bbl print-env)"
set -x
popd
arguments="-l bbl-state/${BBL_ENV}/vars/prometheus/bosh-vars.yml"
for op in ${OPS_FILES}
do
arguments="${arguments} -o prometheus-boshrelease/manifests/operators/${op}"
done
bosh -n -d prometheus deploy prometheus-boshrelease/manifests/prometheus.yml ${arguments}
