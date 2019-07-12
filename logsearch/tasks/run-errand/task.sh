#!/bin/bash -eux

pushd bbl-state/${BBL_ENV}/state
set +x
eval "$(bbl print-env)"
set -x
popd

bosh -n -d logsearch run-errand ${ERRAND_NAME}
