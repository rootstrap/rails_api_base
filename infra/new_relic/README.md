# Installation

Follow the [Terraform installation docs](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) to install Terraform CLI.

## Usage

There are only three commands that need to be run in order to apply this terraform template and fully setup your New Relic monitoring.

```bash
# Init
terraform init

# Plan
terraform plan

# Apply
terraform apply
```

# Docker usage

If you want to use Docker to avoid installing Terraform, we recommend to use one of the latest versions of the Dockerfile.

```bash
# Init
docker run -w /app -v .:/app --env-file .env -it hashicorp/terraform:latest init

# Plan
docker run -w /app -v .:/app --env-file .env -it hashicorp/terraform:latest plan

# Apply
docker run -w /app -v .:/app --env-file .env -it hashicorp/terraform:latest apply
```