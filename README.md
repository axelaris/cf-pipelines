# cf-pipelines
This repo contains [Concourse](https://concourse-ci.org) pipelines for [CF deployment](https://github.com/cloudfoundry/cf-deployment), as well as recommended workflow for creating everything from scratch.

## Jumpbox
Usually, it is recommended to have a jumpbox VM in chosen cloud environment to run all deployments from there. I recommend to use Ubuntu 16.04 LTS with following CLI tools installed:

- [bbl](https://github.com/cloudfoundry/bosh-bootloader/releases)
- [bosh](https://bosh.io/docs/cli-v2-install)
- [credhub](https://github.com/cloudfoundry-incubator/credhub-cli/releases)
- [cf](https://docs.cloudfoundry.org/cf-cli/install-go-cli.html)
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

## Concourse
The main purpose of Controlplane is to keep a Concourse deployment. Here is a walkthrough of deployment:

- Go to [bosh.io](https://bosh.io/stemcells/), find and upload an appropriate stemcell
- Clone [Concourse](https://github.com/concourse/concourse-bosh-deployment/) repo and check it out to latest stable tag.
- Goto `/cluster` dir and create a [deploy-concourse.sh](examples/deploy-concourse.sh) script there.
- Put the Credhub CA into a file: `echo "$CREDHUB_CA_CERT" >credhub_ca`
- Run `./deploy-concourse.sh`