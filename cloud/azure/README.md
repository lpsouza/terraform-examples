# Azure Terraform Examples

This directory contains various Terraform templates designed to demonstrate the deployment of infrastructure on Microsoft Azure.

## Available Projects

- **Blob Storage**: Provision an Azure Storage Account and Container with lifecycle management policies (tiering).
- **HDInsight**: Deploy managed Hadoop and Spark clusters for big data analytics.
- **Synapse Analytics**: Set up a data warehouse environment including a Synapse Workspace and SQL Pool.
- **Virtual Machine**: Create a Linux VM with a Virtual Network, Security Group, and Public IP.

## How to Use

To use any of these examples, follow the steps below:

### 1. Authentication

Before configuring Terraform, you must authenticate with your Azure account and find your Subscription ID:

1. Install the [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) if you haven't already.
2. Open your terminal and run `az login`. A browser window will open for you to sign in.
3. Once logged in, go to the [Azure Portal](https://portal.azure.com/).
4. Search for **Subscriptions** in the top search bar.
5. In the list, find the subscription you want to use and copy its **Subscription ID**.

### 2. Configuration

Each project has a `variables.tf` file that contains the necessary parameters for deployment.

1. Navigate to the specific project folder (e.g., `cd cloud/azure/virtual-machine`).
2. Open the `variables.tf` file.
3. Update the `default` values for the following variables:
   - `SUBSCRIPTION_ID`: Your Azure Subscription ID.
   - `LOCATION`: The target Azure region (e.g., `eastus`).
   - `USERNAME` / `PASSWORD` / `PUBLIC_KEY`: Credentials for the resources being created.

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

To avoid unexpected costs on your Azure account, ensure you destroy the resources after you are finished:

```bash
terraform destroy
```
