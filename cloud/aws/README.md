# AWS Terraform Examples

This directory contains various Terraform templates designed to demonstrate the deployment of infrastructure on Amazon Web Services (AWS).

## Available Projects

- **EC2**: Deploy a Virtual Machine with its associated VPC, Subnet, Internet Gateway, and Security Groups.
- **EKS**: Set up a managed Kubernetes cluster (Elastic Kubernetes Service) with a managed node group.
- **EMR**: Provision an Elastic MapReduce cluster for Big Data processing (Spark/Hadoop) with S3 logging.
- **Redshift**: Deploy a managed Data Warehouse cluster with VPC networking.
- **S3**: Create an S3 bucket with predefined lifecycle rules for storage optimization.

## How to Use

To use any of these examples, follow the steps below:

### 1. Authentication

Before configuring Terraform, you need your AWS credentials. If you don't have them:

1. Sign in to the [AWS Management Console](https://console.aws.amazon.com/).
2. Search for **IAM** in the top search bar and click on it.
3. In the left sidebar, click on **Users**.
4. Click on your username (or create a new user with `AdministratorAccess`).
5. Click on the **Security credentials** tab.
6. Scroll down to **Access keys** and click **Create access key**.
7. Select **Command Line Interface (CLI)**, check the confirmation box, and click **Next**.
8. (Optional) Give it a description and click **Create access key**.
9. **Important:** Copy your **Access Key ID** and **Secret Access Key**. You won't be able to see the secret key again!

### 2. Configuration

Each project has a `variables.tf` file that contains the necessary parameters for deployment.

1. Navigate to the specific project folder (e.g., `cd cloud/aws/ec2`).
2. Open the `variables.tf` file.
3. Update the `default` values for the following variables:
   - `AWS_ACCESS_KEY`: Your AWS access key ID.
   - `AWS_SECRET_KEY`: Your AWS secret access key.
   - `AWS_REGION`: The target AWS region (e.g., `us-east-1`).
   - `AWS_KEY_PAIR`: Your public SSH key (for EC2/EKS/EMR).

### 3. Deployment

Once the variables are configured, run the standard Terraform workflow:

```bash
# Initialize the working directory and download providers
terraform init

# Review the execution plan
terraform plan

# Create the infrastructure
terraform apply
```

### 4. Cleanup

To avoid unexpected costs on your AWS account, ensure you destroy the resources after you are finished:

```bash
terraform destroy
```
