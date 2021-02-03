az account set --subscription "Visual Studio Enterprise Subscription"

# You can check what sizes are available on based on subscription and location
#az vm list-sizes --location southcentralus --subscription "Visual Studio Enterprise Subscription" | grep -i name | grep -i NV

SIZE=Standard_NV6_Promo
RESOURCEGROUP=nvResourceGroup
LOCATION=southcentralus
VM_NAME=NVVM
#find images with offering Windows-10 or change to another
# az vm image list --offer Windows-10 --all --output table

IMAGE="MicrosoftWindowsDesktop:Windows-10:20h2-ent:latest"
USERNAME=rafsalas
az group create --name $RESOURCEGROUP  --location $LOCATION

az vm create --name $VM_NAME \
             --resource-group $RESOURCEGROUP \
             --size $SIZE\
             --image $IMAGE\
             --admin-username $USERNAME 
            #  --admin-password \
            
az vm extension set \
  --resource-group $RESOURCEGROUP \
  --vm-name $VM_NAME \
  --name NvidiaGpuDriverWindows \
  --publisher Microsoft.HpcCompute \
  --version 1.3 