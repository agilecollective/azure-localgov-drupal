# Azure DevOps pipelines

This folder includes pipelines to build and deploy the site using Azire DevOps.

Each file next to this file needs to be added as a pipeline in Azure DevOps and named appropriately.

## Service connections

These pipelines require the following [service connections](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops):

* Azure Resource Manager - connecting to the Azure resource group hosting the web app.
* Docker Registry - connecting to the Azure container registry.

The user creating these connections must be added to the Azure DevOps Administrator group in Entra ID or have admin privileges across the Azure resource group.

## Variable groups

For the pipelines to run the following [variable groups](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/variable-groups?view=azure-devops&tabs=azure-pipelines-ui%2Cyaml) must be defined.

### azure-resources

This variable group defines general settings for connecting to the different Azure resources and can set as open access so all pipelines can access it.

dockerRegistryServiceConnection
: Connection ID for Docker registry service connection
imageRepository
: Repository in Docker registry.
dockerfilePath
: Dockerfile to build.
deployEnvironment
: Environment to build; main, dev or uat.
environment
: Drupal environment; production, dev or uat.

### db

This variable group contains the username and password of a database user that needs to have read access to the production database and all privileges on the dev and uat databases.

It only needs to be accessible to the copy database pipelines.

AZURE_MYSQL_HOST
; MySQL host
AZURE_MYSQL_PASSWORD
; Password of user with permissions to read production database and overwrite dev and uat.
AZURE_MYSQL_PASSWORD
: User name of user with permissions to read production database and overwrite dev and uat.
