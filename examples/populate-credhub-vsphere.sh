#!/bin/bash

git_private_key=`cat ../../dc-denver.pem`

for i in \
git_private_key \
bbl_state_repo \
git_commit_email \
BBL_VSPHERE_VCENTER_USER \
BBL_VSPHERE_VCENTER_PASSWORD \
BBL_VSPHERE_VCENTER_IP \
BBL_VSPHERE_VCENTER_DC \
BBL_VSPHERE_VCENTER_CLUSTER; do
  eval credhub set -n /concourse/main/$i -t value -v \"\$$i\"
done