# storeDataExtract

## Description

BKK Image Recognization tool

## Pre-request
### Install Node js
https://nodejs.org/en/download/

### Install Terraform
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

### AWS Account
How to sign-up and setup AWS Cli Locally
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-prereqs.html

### Overview
  
  *   #### Java Node.js Lambda


### Building
  
 *   #### NPM
      To install:
```
npm install
npm run-script build
```

### Deploying
pushd pipeline/terraform
  terraform plan -out=tf.plan
  terraform apply -input=false tf.plan
  *   #### Terraform
      
        **Requires Terraform version 0.10.7**

        https://www.terraform.io/downloads.html

        To run deploy, simply run the included deploy.sh script:
```bash
  ./deploy.sh
```

  




  


