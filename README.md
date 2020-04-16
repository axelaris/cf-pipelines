# cf-pipelines
This repo contains [Concourse](https://concourse-ci.org) pipelines for [CF deployment](https://github.com/cloudfoundry/cf-deployment), as well as recommended workflow for creating everything from scratch.

## Jumpbox
Usually, it is recommended to have a jumpbox VM in chosen cloud environment to run all deployments from there. I recommend to use Ubuntu 16.04 LTS with following CLI tools installed:

- [bbl](https://github.com/cloudfoundry/bosh-bootloader/releases) [tested on 8.4.0]
- [bosh](https://bosh.io/docs/cli-v2-install) [tested on 6.2.1]
- [credhub](https://github.com/cloudfoundry-incubator/credhub-cli/releases) [tested on 2.6.2]
- [cf](https://docs.cloudfoundry.org/cf-cli/install-go-cli.html) [tested on 6.48.0]
- git, libcurl4-gnutls-dev

## State/Config/Vars repo
In spite of this repository, containing only public parts (pipelines and tasks), you'll need an additional repository to keep private data, such as variables, configuration and BBL state. It's directory structure should be like that:

```
|
+--- controlplane
|  +--- config
|  +--- state
| 
+--- nonprod
|  +--- config
|  +--- state
|  +--- vars
|
+--- staging
|  +--- config
|  +--- state
|  +--- vars
|
+--- etc...
```

Where on first layer (`controlplane`, `nonprod`, `staging`) - will be deployment environments, and on second layer `config` will be used to provide overrides to BBL, `state` for BBL state, and `vars` is for Pipelines/BOSH variables. 

Please use a following walkthrough to create all of that:

- Create a private git repo. It is a good practice to set the name corresponding to your datacenter name, e.g. **dc-denver** 
- From your jumpbox, create a new keypair, and upload a public part to the repo as a deploy key: `ssh-keygen -f dc-denver.pem`
- Create a **controlplane/config** dir, and put override files for BBL. These files will be copied to BBL state directory after `bbl plan` step, but before `bbl up`.
- Go to **controlplane/state** directory, create [.envrc](https://direnv.net) file, and fill it with envirionment variables, needed to authenticate against IaaS ([example](examples/.envrc-vsphere)). Source it.
- Commit changes
- Do `bbl plan --lb-type concourse`, then copy override files over there: `cp -pr ../config/* .` (You don't need `lb-type` for vSphere)
- Commit changes
- Make `bbl up`
- Commit changes
- Put a line ```eval "`bbl print-env`"``` to the end of `.envrc` file

Here is an [example repository](https://github.com/axelaris/dc-example) for your reference.

After completing these steps you will have:

- Jumpbox vm (used as a Socks-proxy for communication with BOSH, usually not relevant for vSphere)
- BOSH Director VM with a proper *cloud-config*
- Credhub instance co-located with BOSH, and integrated in

## Concourse
The main purpose of Controlplane is to handle Concourse deployment. Here is a walkthrough of deployment:

- Go to [bosh.io](https://bosh.io/stemcells/), find and upload an appropriate stemcell [tested on 621.64]
- Clone [Concourse](https://github.com/concourse/concourse-bosh-deployment/) repo and check it out to latest stable tag [tested on 5.8.0]
- Goto `concourse-bosh-deployment/cluster` dir and create a [deploy-concourse.sh](examples/deploy-concourse.sh) script there.
- Put CredHub CA, SSL certificate and admin password into CredHub:
```
  $ set -n /bosh-controlplane/concourse/credhub_ca_cert -t value -v "$CREDHUB_CA_CERT"
  
  $ credhub set -n /bosh-controlplane/concourse/atc_tls -t certificate -r "" -c mycert.crt -p mycert.key
  
  $credhub set -n /bosh-controlplane/concourse/admin-password -t value -v "<my-password>"
```

- Run `./deploy-concourse.sh`
- *Optional: Save filled `deploy-concourse.sh` script into `controlplane/concourse` folder for future reference.* 
- *Optional: Put a record for Concourse server to DNS* 

## Pipelines

- Before running any pipeline, you have to put some important variables, such as IAAS credentials to Credhub. Please use [populate-credhub.sh](examples/populate-credhub-aws.sh) example. You have to put and run this script from `/state` directory to catch some env variables.

- Clone this repo

- Goto [start](start) folder, fill vars file, and fly this pipeline to Concourse

- Prepare directory for new environment (ex. nonprod-1):
	- Create `nonprod-1/config` directory, put override files there
	
	- Create `nonprod-1/vars` directory, and directories for all other pipelines there
	
	- Put and fill vars files for all pipelines
	
	- Commit changes
	
	- Place CredHub variables:
	
	```
	$ credhub set -n /concourse/main/deploy-key -t ssh -p dc-denver.pem
	$ credhub set -n /concourse/main/admin-password -t value -v "<my-password>"
	```
	
- Trigger **start** pipeline

- For the rest of pipelines, you will need to set additional CredHub credentials:

### bbl
- `/concourse/main/vcenter-user` - vCenter username
- `/concourse/main/vcenter-password` - vCenter password
- `/concourse/main/bbl/nonprod-1_ssl` [AWS only]

  [AWS] [[bug]](https://github.com/cloudfoundry/bosh-bootloader/pull/474) Please add 4443 port to `cf-router-lb-security-group`. 

Before setting all the rest CredHub values - make sure you've connected to appropriate environment, but not `controlplane` one
### cf

- `/bosh-nonprod-1/cf/router_ssl` - SSL Certificate

### logsearch

- `/bosh-nonprod-1/logsearch/haproxy-ssl` - SSL Certificate

