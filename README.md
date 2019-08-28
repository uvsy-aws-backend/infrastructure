# Universy AWS Infrastructure

This is the project where we manage our `IaC`. For this we use [`terraform`](https://www.terraform.io/). 


### Instalation 

In order to get the instalation of terraform you'll need to run (on linux): 

`sudo snap install terraform`

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
