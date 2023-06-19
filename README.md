# Azure Kubernetes Service (AKS) Cluster Deployment
This repository contains the code to deploy an Azure Kubernetes Service (AKS) cluster on Azure.

## Prerequisites
1. You need an Azure subscription. If you don't have one, you can create a [free account](https://azure.microsoft.com/en-us/free/).
2. Ensure that you have the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed on your system.
3. Log in to your Azure account using the Azure CLI. You can do this by running the following command:
az login

Follow the instructions to authenticate using your Azure account credentials.

## Configuration
Before proceeding with the deployment, you need to update the `object_id` variable with the proper UUID from your Azure Active Directory (AD).
1. Find the UUID of an Azure AD user or group that you would like to grant access to the AKS cluster. You can obtain the UUID using Azure Portal, Azure CLI, or Azure PowerShell (refer to the previous response on how to obtain the UUID).
2. Open the configuration file where the `object_id` variable is defined (e.g., `variables.tf` or `main.tf`, depending on your setup).
3. Replace the placeholder value `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx` with the actual UUID you obtained in the previous step:
object_id = "<your_valid_UUID>"


4. Save and close the configuration file.

## Deployment
Once you have completed the configuration step, you can deploy the AKS cluster:
1. Initialize your Terraform environment by running:
terraform init


2. Verify the configuration and preview the actions to be taken by running:
terraform plan


3. Apply the changes to create the AKS cluster by running:
terraform apply


When prompted, type `yes` and hit `Enter` to confirm the deployment.

After the deployment is complete, you will have a functional AKS cluster running on Azure.