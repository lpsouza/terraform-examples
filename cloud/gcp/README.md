# GCP Terraform Examples

This directory contains various Terraform templates designed to demonstrate the deployment of infrastructure on Google Cloud Platform (GCP).

## Available Projects

- **Cloud Storage**: Create a GCS bucket with lifecycle rules and IAM bindings.
- **Dataproc**: Deploy a managed Spark/Hadoop cluster with custom networking and firewall rules.
- **Virtual Machine**: Provision a "Free Tier" eligible f1-micro instance with Ubuntu 22.04.

## How to Use

To use any of these examples, follow the steps below:

### 1. Authentication

Before running Terraform, you must authenticate with GCP, set up Application Default Credentials (ADC), and find your Project ID:

1. Install the [Google Cloud CLI](https://cloud.google.com/sdk/docs/install) if you haven't already.
2. Open your terminal and log in:
   ```bash
   # Log in to your Google Account
   gcloud auth login

   # Set up application default credentials for Terraform to use
   gcloud auth application-default login
   ```
3. To find your **Project ID**:
   - Go to the [GCP Console](https://console.cloud.google.com/).
   - Click the project selector dropdown at the top of the page.
   - The **ID** is listed next to your project name in the list.

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
