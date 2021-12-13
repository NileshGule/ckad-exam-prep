Param(
    [parameter(Mandatory = $false)]
    [string]$subscriptionName = "Microsoft Azure Sponsorship",
    [parameter(Mandatory = $false)]
    [string]$resourceGroupName = "demo-kubeadm-ckad",
    [parameter(Mandatory = $false)]
    [string]$resourceGroupLocaltion = "South East Asia"
)

# Set Azure subscription name
Write-Host "Setting Azure subscription to $subscriptionName"  -ForegroundColor Yellow
az account set --subscription=$subscriptionName

$aksRgExists = az group exists --name $resourceGroupName

Write-Host "$resourceGroupName exists : $aksRgExists"

if ($aksRgExists -eq $false) {

    # Create resource group name
    Write-Host "Creating resource group $resourceGroupName in region $resourceGroupLocaltion" -ForegroundColor Yellow
    az group create `
        --name=$resourceGroupName `
        --location=$resourceGroupLocaltion `
        --output=jsonc
}

Write-Host "Creating Virtual Network"
az network vnet create `
    --resource-group $resourceGroupName `
    --name kubeVnet `
    --address-prefixes 172.0.0.0/16 `
    --subnet-name MySubnet `
    --subnet-prefix 172.0.0.0/24 `
    --output=jsonc

# Create Master Node - This will have a public IP
Write-Host "Creating Kube master Virtual machine"
az vm create `
    --name kube-master `
    --resource-group $resourceGroupName `
    --image ubuntults `
    --size Standard_DS2_v2 `
    --data-disk-sizes-gb 10 `
    --admin-username azuser `
    --ssh-key-value ~/.ssh/id_rsa.pub `
    --public-ip-address-dns-name kubeadm-ckad-master

# Create the two worker nodes
Write-Host "Creating worker node 1 Virtual machine"

az vm create `
    --name kube-worker-1 `
    --resource-group $resourceGroupName `
    --image ubuntults `
    --size Standard_DS2_v2 `
    --data-disk-sizes-gb 10 `
    --admin-username azuser `
    --ssh-key-value ~/.ssh/id_rsa.pub `
    --public-ip-address-dns-name kubeadm-ckad-worker-1

Write-Host "Creating worker node 2 Virtual machine"

az vm create `
    --name kube-worker-2 `
    --resource-group $resourceGroupName `
    --image ubuntults `
    --size Standard_DS2_v2 `
    --data-disk-sizes-gb 10 `
    --admin-username azuser `
    --ssh-key-value ~/.ssh/id_rsa.pub `
    --public-ip-address-dns-name kubeadm-ckad-worker-2

