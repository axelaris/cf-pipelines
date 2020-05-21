# PCF Pipelines
This branch contains pipelines and some notes for Pivotal Cloud Foundry deployment.

## Variables
Before start deploying, you have to place following secrets into CredHub:

| Credhub path                          | Type | Variable description                                         |
| :------------------------------------ | ---- | ------------------------------------------------------------ |
| `/concourse/pcf/pivnet-token`         | v    | The token you can get from [PivNet](https://network.pivotal.io/users/dashboard/edit-profile) |
| `/concourse/pcf/s3_access_key_id`     | v    | This is a Minio user, default is `admin`                     |
| `/concourse/pcf/s3_secret_access_key` | v    | Get it here: `/bosh-controlplane/minio/minio_secretkey`      |
| `/concourse/pcf/credhub-ca`           | c    | Get it from BBL env: `CREDHUB_CA_CERT`                       |
| `/concourse/pcf/credhub-client`       | v    | Get it from BBL env: `CREDHUB_CLIENT`                        |
| `/concourse/pcf/credhub-secret`       | v    | Get it from BBL env: `CREDHUB_SECRET`                        |
| `/concourse/pcf/deploy-key`           | s    | Get it here: `/concourse/main/deploy-key`                    |
| `/concourse/pcf/vcenter-username`     | v    | Username to access vCenter                                   |
| `/concourse/pcf/vcenter-password`     | v    | Password to access vCenter                                   |
| `/concourse/pcf/ssh-public-key`       | s    | ~/.ssh/id_rsa.pub                                            |
| `/concourse/pcf/ops-user`             | v    | Desired Ops Manager user                                     |
| `/concourse/pcf/ops-pass`             | v    | Desired Ops Manager password                                 |
| `/concourse/pcf/ops-cert`             | s    | SSL Cert for Ops Manager                                     |
| `/concourse/pcf/ssl-cert`             | s    | SSL Cert for PAS Deployment                                  |
| `/concourse/pcf/pas_secret`           | v    | PAS Secret Key                                               |
| `/bosh-controlplane/minio/ssl-cert`   | c    | Certificate for Minio                                        |

#### Types for values:

- v - value
- c - certificate (can contain CA, certificate and private key)
- s - ssh (can contain public and private keys)

## Minio

Minio is an Amazon S3 alternative. You will use it to download and cache all artifacts needed for Tanzu services deployment.

```
$ cd dc-example/controlplane/minio
$ ./deploy.sh
```

After deploying, please go to UI and create following buckets:

- `products`
- `platform-automation`
- `pcf-backup`

## Pipelines:

```
$ fly -t my-target sp -p download -c download.yml -l ../dc-example/pcf/download-vars.yml
$ fly -t my-target sp -p deploy -c deploy.yml -l ../dc-example/pcf/deploy-vars.yml
```

## Documentation:

- [Creating a Director config file](https://docs.pivotal.io/platform-automation/v4.3/how-to-guides/creating-a-director-config-file.html)

- [Task Reference](https://docs.pivotal.io/platform-automation/v4.3/how-to-guides/creating-a-director-config-file.html)

