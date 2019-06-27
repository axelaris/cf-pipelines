#!/bin/bash

git_private_key=`cat ../../dc-aws.pem`

for i in \
git_private_key \
bbl_state_repo \
git_commit_email \
BBL_IAAS \
BBL_AWS_ACCESS_KEY_ID \
BBL_AWS_SECRET_ACCESS_KEY \
BBL_AWS_REGION; do
  eval credhub set -n /concourse/main/$i -t value -v \"\$$i\"
done