# Universy AWS Infrastructure
[![serverless](http://public.serverless.com/badges/v3.svg)](http://www.serverless.com)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)


This is the project where we manage our `IaC`. For this we use [`terraform`](https://www.terraform.io/) 
and [`serverless`](https://serverless.com/)   

## Terraform Stack Deploy

With `terraform` we create the base structure: 

- Amazon API Gateway
- Cognito Userpool and clients
- S3 buckets
- IAM Roles

### Instalation 

In order to get the instalation of terraform you'll need to download the `terraform cli` from [here](https://www.terraform.io/downloads.html)

### AWS plugin

To get the aws plugin and the necesary configuration for terraform, `cd` to the folder `terraform` and run: 

`terraform init`

### Workspaces

To create and set a *workspace* (aka *stage*), you can perform: 

- `terraform workspace new <ws>`
- `terraform workspace select <ws>`

> Where `<ws>` is the desired workspace


### Deploy 

Simply run: 

`terraform apply` 

> You need to have `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`


## Serverless Stack Deploy

With `serverless` we create the logic and storage:

- AWS Lambda
- DynamoDB
- DynamoDB Streams

## Structure

The project and the version to deploy are in the file: 

`./serverless/deploy.properties`

## Deploy

In order to deploy all of the projects declared in `deploy.properties` first:

`cd serverless`

Then run: 

`./deployStack.sh`
