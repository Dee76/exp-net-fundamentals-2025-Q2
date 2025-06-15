# :mailbox_with_mail: IP Address Management in Azure

## How to Deploy

### Install and Login to Azure CLI

```sh
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az version
az login --use-device-code
az account show
```

> You only have to install _Azure CLI_ if it is not already installed on your deployment system.

### Execute Deploy Script

```sh
cd projects/ip_address_management
chmod +x ./bin/deploy
cd templates/vm
../../bin/deploy
```

> You will be prompted for the _adminPassword_ for the Azure VM.

> The deploy script only has to have permissions changed via `chmod` once to make it executable.

## :book: Journal

To review how we deploying our _Azure VM_ to learn IP address management, and learn how to do it yourself, consult the [_Journal_](Journal.md).

:end: