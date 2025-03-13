# Azure DevOps pipelines

This folder includes pipelines to build and deploy the site using Azire DevOps.

Each file next to this file needs to be added as a pipeline in Azure DevOps and named appropriately. The templates directory includes job definitions that are reused by the main pipelines.

## Types of pipelines

### Build deploy

These pipelines build the main, dev and uat branches and deploy to the preprod, dev and uat slots. They run automatically whenever changes are pushed to the main dev or uat branches.

### Deploy

These pipelines just deploy a previously built main, dev, or uat image to the preprod, dev or uat slots and are mainly used to debug the deploy process.

### Finalise main deploy

The main branch deploys automatically to the preprod slot. This pipeline is used to finalise the deploy by switching the preprod slot into the production slot.

### Replace database

These pipelines wipe the dev or uat databases and replace it with a copy of the production database.

## Service connections

These pipelines require the following [service connections](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops):

* Azure Resource Manager - connecting to the Azure resource group hosting the web app.
* Docker Registry - connecting to the Azure container registry.

The user creating these connections must belong to the Azure DevOps Administrator group in Entra ID or have admin privileges across the Azure resource group.

## Variable groups

For the pipelines to run the following [variable groups](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/variable-groups?view=azure-devops&tabs=azure-pipelines-ui%2Cyaml) must be defined.

### azure-resources

This variable group defines general settings for connecting to the different Azure resources and can set as open access so all pipelines can access it.

* containerRegistry => Container registry name.
* dockerRegistryServiceConnection => Connection UUID for Docker registry service connection
* imageRepository => Repository in Docker registry.
* resourceGroupName => Name of Azure resource groupn the web app lives in.
* resourceManagerServiceConnection => Resource manager connection UUID.
* webAppName => Name of Azure web app.

### db

This variable group contains the username and password of a database user that needs to have read access to the production database and all privileges on the dev and uat databases.

It only needs to be accessible to the replace database pipelines.

* mysqlHost => MySQL database host.
* mysqlUser => MySQL user with read permissions on source and write permissions on destination.
* mysqlPassword => Password for mysqlUser.
* productionDatabase => The name of the production database.
* devDatabase => The name of the dev database.
* uatDatabase => The name of the uat database.
