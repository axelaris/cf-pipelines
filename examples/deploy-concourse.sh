bosh  deploy -d concourse concourse.yml \
  -l ../versions.yml \
  -o operations/basic-auth.yml \
  -o operations/credhub.yml \
  -o operations/worker-ephemeral-disk.yml \
  --var local_user.username=admin \
  --var local_user.password="xxxxxxxx" \
  --var external_url=http://concourse.example.com:8080 \
  --var network_name=default \
  --var web_vm_type=default \
  --var db_vm_type=default \
  --var db_persistent_disk_type=50GB \
  --var worker_ephemeral_disk=50GB_ephemeral_disk \
  --var worker_vm_type=default \
  --var deployment_name=concourse \
  --var credhub_url=$CREDHUB_SERVER \
  --var credhub_client_id=$CREDHUB_CLIENT \
  --var credhub_client_secret=$CREDHUB_SECRET \
  --var-file credhub_ca_cert=credhub_ca

# vSphere
# -o operations/static-web.yml \
# --var web_ip=192.168.2.10 \

# AWS
# -o operations/privileged-http.yml \
# -o operations/web-network-extension.yml \
# --var web_network_name=default \
# --var web_network_vm_extension=lb \

# TLS
# -o operations/privileged-https.yml \
# -o operations/tls.yml \
# -o operations/tls-vars.yml \
# --var external_host=ci.example.com \
# --var external_url=https://concourse.example.com \
#
# Replace default certs with your own:
# credhub set -n /bosh-${BBL_ENV_NAME}/concourse/atc_tls -t certificate -p "`cat atc_tls.key`" -c "`cat atc_tls.cert`" -r "`cat atc_tls.ca`"

# Internal proxy:
# -o operations/http-proxy.yml \
# --var http_proxy_url="http://proxy:8080" \
# --var https_proxy_url="http://proxy:8080" \
# --var no_proxy="10.0.0.1,.example.com" \
