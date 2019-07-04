#!/bin/bash -eu

pushd bbl-state/${BBL_ENV}/state
eval "$(bbl print-env)"
popd
CFPSW=$(credhub get -n /bosh-${BBL_ENV}/cf/cf_admin_password | grep ^value | awk '{print $2}')
credhub set -n /bosh-${BBL_ENV}/prometheus/cf_admin_password -t value -v $CFPSW