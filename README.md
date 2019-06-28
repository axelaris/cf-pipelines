# cf-pipelines
This repo contains [Concourse](https://concourse-ci.org) pipelines for [CF deployment](https://github.com/cloudfoundry/cf-deployment), as well as recommended workflow for creating everything from scratch.

## Jumpbox
Usually, it is recommended to have a jumpbox VM in chosen cloud environment to run all deployments from there. I recommend to use Ubuntu 16.04 LTS with following CLI tools installed:

- [bbl](https://github.com/cloudfoundry/bosh-bootloader/releases) [tested on 8.1.0]
- [bosh](https://bosh.io/docs/cli-v2-install) [tested on 5.5.1]
- [credhub](https://github.com/cloudfoundry-incubator/credhub-cli/releases) [tested on 2.5.1]
- [cf](https://docs.cloudfoundry.org/cf-cli/install-go-cli.html) [tested on 6.40.1]
- git, libcurl4-gnutls-dev

## State/Config/Vars repo
In spite of this repository, containing only public parts (pipelines and tasks), you'll need an additional repository to keep a private data, such as variables, configuration and BBL state. It's directory structure should be like that:

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

Where `controlplane`, `nonprod` and `staging` - deployment environments, `config` is used to provide overrides to BBL, `state` contaings BBL state, and `vars` is for pipelines or BOSH variables.

Please use a following walkthrough to create that:

- Create a private git repo. It is a good practice to set the name corresponding to your datacenter name, e.g. **dc-denver** 
- From your jumpbox, create a new keypair, and upload a public part to the repo as a deploy key: `ssh-keygen -f dc-denver.pem`
- Create a **controlplane/config** dir, and put override files for BBL. These files will be copied to BBL state directory after `bbl plan` step, and before `bbl up`.
- Go to **controlplane/state** directory, create [.envrc](https://direnv.net) file, and fill it with envirionment variables, needed to authenticate against IaaS ([example](examples/.envrc-vsphere)).
- Commit changes
- Do `bbl plan --lb-type concourse`, then copy override files over: `cp -pr ../config/* .`
- Commit changes
- Do `bbl up`
- Commit changes
- Put a line ```eval "`bbl print-env`"``` to the `.envrc` file

## Concourse
The main purpose of Controlplane is to keep a Concourse deployment. Here is a walkthrough of deployment:

- Go to [bosh.io](https://bosh.io/stemcells/), find and upload an appropriate stemcell
- Clone [Concourse](https://github.com/concourse/concourse-bosh-deployment/) repo and check it out to latest stable tag.
- Goto `/cluster` dir and create a [deploy-concourse.sh](examples/deploy-concourse.sh) script there.
- Put the Credhub CA into a file: `echo "$CREDHUB_CA_CERT" >credhub_ca`
- Run `./deploy-concourse.sh`
- *Optional: Save filled `deploy-concourse.sh` script into `controlplane/concourse` folder for future reference.* 

## Pipelines

- Before running any pipeline, you have to put some important variables, such as IAAS credentials to Credhub. Please use [populate-credhub.sh](examples/populate-credhub-aws.sh) example. You have to put and run this script from `/state` directory to catch some env variables.
- Clone this repo
- Goto [start](start) folder, fill vars file, and fly this pipeline to Concourse
- Prepare directory for new environment (ex. nonprod-1):
	- Create `nonprod-1/config` directory, put override files there
	- Create `nonprod-1/vars` directory, and directories for all other pipelines there
	- Put and fill vars files for all pipelines
	- Commit changes
- Trigger **start** pipeline