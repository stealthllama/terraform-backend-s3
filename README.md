# terraform-backend-s3
A Terraform plan for creating a state locking backend in AWS using S3 and DynamoDB.

## Background
By default, Terraform stores [state](https://www.terraform.io/docs/state/index.html) information about the infrastructure it manages in a local file named `terraform.tfstate`.  Any modifications to infrastructure definitions will reference this state information and update it once the required changes have been implemented.  However, local state management is not suitable for team collaboration.  Each team member would need a current copy of the state file.  Even then, they would need to ensure that only one team member at a time can make changes to the infrastructure in order to avoid conflicting changes.

Fortunately, Terraform supports [remote state](https://www.terraform.io/docs/state/remote.html) management using a number of different [backend](https://www.terraform.io/docs/backends) solutions in which to centrally store state information.  Many of these backends also support [state locking](https://www.terraform.io/docs/state/locking.html) to ensure that only one team member at a time can make changes to the infrastructure.

## Implementation
The Terraform plan contained in this repository will create a backend in AWS utilizing S3 for state file storage and a DynamoDB table for locking operations.  This backend can be creating using the following steps:

1. Clone the repository to your local machine.

```bash
$ git clone https://github.com/stealthllama/terraform-backend-s3.git
```

2. Change into the repository directory.

```bash
$ cd terraform-backend-s3
```

3. Create a `terraform.tfvars` file containing the variables defined in `variables.tf` and their values.

```bash
aws_access_key_id = "MY_AWS_ACCESS_KEY"
aws_secret_access_key = "MY_AWS_SECRET_KEY"
aws_region = "us-east-1"
```
4. Initialize the Terraform provider.

```bash
$ terraform init
```

5. Validate the Terraform plan.

```bash
$ terraform plan
```

6. Implement the Terraform plan.

```bash
$ terraform apply
```

The Terraform plan will output the name of the S3 bucket and DynamoDB tables used for state storage and locking.  These values will be referenced in other Terraform plans that utilize this backend.

```bash
Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

bucket-name = terraform-state-bucket-aba0308f6c13f841
table-name = terraform-state-lock-aba0308f6c13f841
```

## Usage
Once the backend has been created it can be used by another Terraform plan.  However, it is recommended that you create a separate backend for each Terraform project in order to ensure state files in the backend are not overwritten.

To use this backend in a Terraform plan you will define a `backend` configuration such as the following either in an existing Terraform plan file or in a separate `backend.tf` file within the project directory:

```hcl
terraform {
  backend "s3" {
    encrypt             = true
    bucket              = "terraform-state-bucket-aba0308f6c13f841"
    dynamodb_table      = "terraform-state-lock-aba0308f6c13f841"
    key                 = "myapp/terraform.tfstate"
    region              = "us-east-1"
  }
}
```

Once included in a Terraform plan the backend will need to be initialized with the remainder of the plan.  The output of the `terraform init` command should include the following output:

```
Initializing the backend...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.
```

From this point forward any Terraform commands issued within the project directory will reference the state information contained in the backend storage.  All commands will also acquire a state lock in order to ensure the requestor has exclusive access to the state information.  The lock will then be released once the command actions have completed.

Happy Terraforming!