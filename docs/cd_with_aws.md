# Continuous Deployment with AWS

This document explains how to set up Continuous Deployment (CD) with AWS using GitHub Actions.

## Prerequisites

Before you start, make sure you have the following:

1. **AWS Account**: You need an AWS account. Sign up [here](https://aws.amazon.com/).

2. **Amazon ECR (Elastic Container Registry) Setup**: 
   - Create a new repository in Amazon ECR.
   - Note down the repository URI, which will be used in the GitHub Actions workflow.

3. **AWS Credentials**: 
   - AWS Access Key ID
   - AWS Secret Access Key
   - These credentials should have permission to interact with ECR and ECS.

4. **Create Environments**:

   The GitHub Actions workflow will automatically deploy to the correct environment based on the branch being pushed to. The branch `main` will always be linked to the `production` environment, while other branches will use their own names as the environment. All environments added in GitHub must have the same name as the branches.

5. **GitHub Repository Setup**:
   - **Environment Secrets**: Add the following secrets to your GitHub environments (these are specific to each environment and not set at the repository level):
     - `AWS_ACCESS_KEY_ID`: Your AWS Access Key ID.
     - `AWS_SECRET_ACCESS_KEY`: Your AWS Secret Access Key.
   - **Environment Variables**: Add the following variables to your GitHub environments:
     - `AWS_REGION`: The region where your ECR and ECS are set up (e.g., `us-east-1`).
     - `ECR_REPOSITORY`: The name of your ECR repository.
     - `ECS_TASK_DEFINITION`: The ARN of your ECS task definition.
     - `ECS_TASK_DEFINITION_PATH`: The path to your ECS task definition file.
     - `CONTAINER_NAME`: The name of the container defined in your ECS task definition.
     - `ECS_SERVICE`: The name of your ECS service.
     - `ECS_CLUSTER`: The name of your ECS cluster.

6. **GitHub Actions Workflow**:
   To set up the GitHub Actions workflow for continuous deployment to AWS, you need to modify the existing cd.yml file in the .github/workflows directory of your GitHub repository.

   Uncomment the branches section under `on: push:` and add the necessary branches to enable automatic deployment. For example:

   ```yaml
   on:
     push:
       branches:
         - main
         - dev