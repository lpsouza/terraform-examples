# GCP Terraform Examples

This directory contains various Terraform templates designed to demonstrate the deployment of infrastructure on Google Cloud Platform (GCP).

## Available Projects

- **Cloud Storage**: Create a GCS bucket with lifecycle rules and IAM bindings.
- **Dataproc**: Deploy a managed Spark/Hadoop cluster with custom networking and firewall rules.
- **Virtual Machine**: Provision a "Free Tier" eligible f1-micro instance with Ubuntu 22.04.

## How to Use

To use any of these examples, follow the steps below:

### 1. Authentication

Before running Terraform, you must authenticate with GCP and set up Application Default Credentials (ADC):

```bash
# Log in to your Google Account
gcloud auth login

# Set up application default credentials for Terraform to use
gcloud auth application-default login
```

### 2. Configuration

Each project has a `variables.tf` file that contains the necessary parameters for deployment.

1. Navigate to the specific project folder (e.g., `cd cloud/gcp/virtual-machine`).
2. Open the `variables.tf` file.
3. Update the `default` values for the following variables:
   - `PROJECT_ID`: Your GCP Project ID.
   - `REGION`: The target region (e.g., `us-central1`).
   - `SSH_KEY`: Your public SSH key for VM access.

### 3. Deployment

Once authenticated and configured, run the standard Terraform workflow:

```bash
# Initialize the working directory and download providers
terraform init

# Review the execution plan
terraform plan

# Create the infrastructure
terraform apply
```

### 4. Cleanup

To avoid unexpected costs on your GCP account, ensure you destroy the resources after you are finished:

```bash
terraform destroy
```
