# tf-ami-deployer Repository

Welcome to the tf-ami-deployer repository! This repository serves as a toolkit for deploying infrastructure using Terraform. Here, you'll find resources, templates, and documentation to help you streamline your deployment process.

## Table of Contents

- [tf-ami-deployer Repository](#tf-ami-deployer-repository)
  - [Table of Contents](#table-of-contents)
  - [Repository Purpose](#repository-purpose)
  - [Usage](#usage)
  - [Deployment](#deployment)
    - [Overview](#overview)
    - [Deploy All](#deploy-all)
    - [Deploy One or Many](#deploy-one-or-many)
    - [Common Patterns](#common-patterns)
      - [Deploy All common-subenv EFS](#deploy-all-common-subenv-efs)
      - [Deploy all common-subenv ELB](#deploy-all-common-subenv-elb)
      - [Deploy AMQ](#deploy-amq)
  - [Folder Structure](#folder-structure)
  - [Documentation](#documentation)
  - [AWS-DOCS](#aws-docs)
  - [Contributing](#contributing)
  - [License](#license)

## Repository Purpose

The primary purpose of this repository is to provide to use github workflows for deploying infrastructure using Terraform. It simplifies the process of setting up and managing various components of your infrastructure stack.

## Usage

To use this repository, follow these steps:

1. Clone the repository to your local machine.
2. Navigate to the specific component or resource you are interested in.
3. Follow the instructions provided in each subdirectory's README to understand how to use the code and deploy the infrastructure.

## Deployment

### Overview

Deployments are done through Workflow Dispatch in this repository due to:

- It's structure and required variables do not lend well to Continuous Delivery.
- The need to be able to change, commit, and stage code without risk of automatically deploying to an environment.

These Workflows accept different required parameters depending on the action you are trying to take and often chain through each other to generate and process required data on your behalf. All workflows end at the same point with the single workflow that actually does the terraform applies in the targeted account [Deploy Matrix](./.github/workflows/deploy-matrix.yaml)

### Deploy All

Trigger the Workflow [Deploy All in Sub-Environment](./.github/workflows/deploy-all.yaml). This Workflow can orchestrate deploying the entire stack to a subenvironment. You can include or exclude any specific part by toggling `true` or `false`.

`Example Payload:`
```yaml
SubEnvironment: "dev01" # Shortname for subenvironment to target
common: "true" # Whether to deploy all common to target subenvironment
applications: "true" # Whether to deploy all applications to target subenvironment
public_load_balancers: "false" # Whether to deploy all public_load_balancers to target subenvironment
```

### Deploy One or Many

`Example Payload: Single Application`
```yaml
matrix: [["jboss-standalone-a2go-notifications"]] # A JSON List of Lists defining which applications to deploy and in what order by tier
type: "applications" # What type of deployment this is ["applications","common","public_load_balancers"]
subEnvironment: "dev01" # Shortname for subenvironment to target (Only required for non common-tier deployments)
tier: "null" # The Scope that determine whether a deployment is to production or non-production (Only required for common-tier deployments)
currentLayer: "1" # What index of the JSON List of Lists to iterate over that is provided via the 'matrix' input, special logic is done here to convert the index's to be more human readable e.g index 0 =1 and index 1 = 2
auto-approve: "true" # Whether to pass the `auto-approve` argument to Terraform or not
update-sdlc: "true" # Whether to copy the latest version of `sdlc_deploy` code to the S3 Bucket for consumption
```

`Example Payload: Multiple Applications`
```yaml
matrix: [["jboss-standalone-a2go-notifications","springboot-aircraft"],["springboot-ota-order-sync"]] # A JSON List of Lists defining which applications to deploy and in what order by tier
type: "applications" # What type of deployment this is ["applications","common","public_load_balancers"]
subEnvironment: "dev01" # Shortname for subenvironment to target (Only required for non common-tier deployments)
tier: "null" # The Scope that determine whether a deployment is to production or non-production (Only required for common-tier deployments)
currentLayer: "1" # What index of the JSON List of Lists to iterate over that is provided via the 'matrix' input, special logic is done here to convert the index's to be more human readable e.g index 0 =1 and index 1 = 2
auto-approve: "true" # Whether to pass the `auto-approve` argument to Terraform or not
update-sdlc: "true" # Whether to copy the latest version of `sdlc_deploy` code to the S3 Bucket for consumption
```

`Example Payload: Single Load Balancer`
```yaml
matrix: [["alb-public-kayak"]] # A JSON List of Lists defining which applications to deploy and in what order by tier
type: "public_load_balancers" # What type of deployment this is ["applications","common","public_load_balancers"]
subEnvironment: "dev01" # Shortname for subenvironment to target (Only required for non common-tier deployments)
tier: "null" # The Scope that determine whether a deployment is to production or non-production (Only required for common-tier deployments)
currentLayer: "1" # What index of the JSON List of Lists to iterate over that is provided via the 'matrix' input, special logic is done here to convert the index's to be more human readable e.g index 0 =1 and index 1 = 2
auto-approve: "true" # Whether to pass the `auto-approve` argument to Terraform or not
update-sdlc: "false" # Whether to copy the latest version of `sdlc_deploy` code to the S3 Bucket for consumption
```

`Example Payload: Single Common for SubEnvironment`
```yaml
matrix: [["consul"]] # A JSON List of Lists defining which applications to deploy and in what order by tier
type: "common-subenv" # What type of deployment this is ["applications","common","public_load_balancers"]
subEnvironment: "dev01" # Shortname for subenvironment to target (Only required for non common-tier deployments)
tier: "null" # The Scope that determine whether a deployment is to production or non-production (Only required for common-tier deployments)
currentLayer: "1" # What index of the JSON List of Lists to iterate over that is provided via the 'matrix' input, special logic is done here to convert the index's to be more human readable e.g index 0 =1 and index 1 = 2
auto-approve: "true" # Whether to pass the `auto-approve` argument to Terraform or not
update-sdlc: "true" # Whether to copy the latest version of `sdlc_deploy` code to the S3 Bucket for consumption
```

`Example Payload: Single Common for Tier`
```yaml
matrix: [["emlrl"]] # A JSON List of Lists defining which applications to deploy and in what order by tier
type: "common-tier" # What type of deployment this is ["applications","common","public_load_balancers"]
subEnvironment: "null" # Shortname for subenvironment to target (Only required for non common-tier deployments)
tier: "non-prod" # The Scope that determine whether a deployment is to production or non-production (Only required for common-tier deployments)
currentLayer: "1" # What index of the JSON List of Lists to iterate over that is provided via the 'matrix' input, special logic is done here to convert the index's to be more human readable e.g index 0 =1 and index 1 = 2
auto-approve: "true" # Whether to pass the `auto-approve` argument to Terraform or not
update-sdlc: "true" # Whether to copy the latest version of `sdlc_deploy` code to the S3 Bucket for consumption
```

### Common Patterns

#### Deploy All common-subenv EFS
```json
[["airweb-efs","amqap-efs","jboss-efs","nodap-efs","springboot-efs","dam-efs","ais-efs","php53-mxweb-efs"]]
```
#### Deploy all common-subenv ELB
```json
[["jboss-standalone-jbshc1","springboot-hc-alb","jboss-alb-jbshc3","jboss-alb-jbshc2"]]
```
#### Deploy AMQ
```json
[["amqap11","amqap12"]]
```

## Destroying Resources workflow

### Overview

AWS resources which are built using Terraform code are being destroyed using the workflow which is mentioned below:

These Workflows accept different required parameters depending on the action you are trying to take and often chain through each other to generate and process required data on your behalf. Workflow that helps to destroy resources can be found in [Destroy resources Matrix](./.github/workflows/destroy-resources.yaml)

### Destroy Single or Multiple App

`Example Payload: Single Application destroy`
```yaml
matrix: [["php54-g4pop"]] # A JSON List of Lists defining which applications to destroy and in what order by tier
type: "applications" # What type of deployment this is belongs to ["applications","common","public_load_balancers"]
subEnvironment: "dev01" # Shortname for subenvironment to target
tier: "null" # The Scope that determine whether a deployment is to production or non-production
currentLayer: "1" # What index of the JSON List of Lists to iterate over that is provided via the 'matrix' input, special logic is done here to convert the index's to be more human readable e.g index 0 =1 and index 1 = 2
destroy: "true" # Whether to pass the `destroy` argument to Terraform destroy or not, If it sets to false it will show up resources that are going to be destroyed
```

`Example Payload: Multiple Applications destroy`
```yaml
matrix: [["php54-g4pop","springboot-fmm-tail-assigner"]] # A JSON List of Lists defining which applications to destroy and in what order by tier
type: "applications" # What type of deployment this is belongs to ["applications","common","public_load_balancers"]
subEnvironment: "dev01" # Shortname for subenvironment to target
tier: "null" # The Scope that determine whether a deployment is to production or non-production
currentLayer: "1" # What index of the JSON List of Lists to iterate over that is provided via the 'matrix' input, special logic is done here to convert the index's to be more human readable e.g index 0 =1 and index 1 = 2
destroy: "true" # Whether to pass the `destroy` argument to Terraform destroy or not, If it sets to false it will show up resources that are going to be destroyed
```


## Folder Structure

The repository is organized as follows:

- [applications](applications/README.md): Contains application-specific deployment configurations and templates.
- [common](common/README.md): Holds common modules and resources shared across different deployments.
- [docs](docs/README.md): Provides additional documentation about abstract processes or concepts that don't fit in the top-level README.
- [public_load_balancers](public_load_balancers/README.md): Includes Terraform configurations for setting up load balancers.
- [shim](shim/README.md): Contains generic Terraform templates that can be reused across various projects.

Each of these folders has its own README file that provides specific instructions for that area of the repository.

## Documentation

You can find detailed documentation for individual components and processes within their respective subdirectories. If you're new to this repository, we recommend starting with the top-level README and then exploring the subdirectories that help you the most.

## AWS-DOCS

For high-level architecture diagrams, process documentation, or any content that spans multiple repositories or doesn't belong to a specific directory, you can find such documentation in the [docs](docs) folder. These documents provide a broader understanding of how different components work together.

**** we might have to provide information and hyperlinks linking to each readme as well**

## Contributing

description about the contributors

## License

This repository is licensed under the *********description about the license*****
