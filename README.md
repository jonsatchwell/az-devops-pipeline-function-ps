# Powershell Sample for Calling Azure DevOps Build

This repository is a is a simple Powershell Azure Function that can queue an existing build from a build definition ID.

## Basics
The sample uses a PAT token from Azure DevOps
PAT Token generation
https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=preview-page

The API docs for calling Azure DevOps Build Queue
https://docs.microsoft.com/en-us/rest/api/azure/devops/build/builds/queue?view=azure-devops-rest-5.1

## Installation

1. Clone this repository

2. In VS Code install the Azure Fucntions Extension

3. Install Powershell Core

4. Open the project in VS Code 

5. To debug locally make sure you create a file local.settings.json in the project root.
    {
        "IsEncrypted": false,
        "Values": {
        "AzureWebJobsStorage": "",
        "FUNCTIONS_WORKER_RUNTIME": "powershell",
        "PatToken" : "XXXXXXXX",
        "OrgUrl": "https://dev.azure.com/{ORG-NAME}/{PORJECT-NAME}",
        "DefId": "integer id e.g. 25"
        }
    }

6. After publishing to Azure macke sure you set the appsettings in the Function for the PAT toke, Org Url and build DefID. 



