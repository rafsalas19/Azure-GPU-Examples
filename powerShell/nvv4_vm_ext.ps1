echo "subscription Id: "
Get-AzSubscription | Format-Wide -Property Id

$RESOURCE_GROUP="rafTestrg"
$LOCATION="centralus"
#Get-AzVMSize -Location "East US" | grep Standard_NV
$VMSIZE="Standard_NV4as_v4"
$VM_NAME="nvVM"
$pubname="MicrosoftWindowsDesktop"
$offer="windows-10-1809-vhd-client-prod-stage"
$sku="rs5-enterprise"

$RES =Get-AzResourceGroup -Name "rafTestrg" -Erroraction ignore
if($RES -ne $null){
  Write-Output "$RESOURCE_GROUP Exists"

}else{
  New-AzResourceGroup -Name rafTestrg -Location $LOCATION
}

$VM_EXIST= Get-AZVM -ResourceGroupName $RESOURCE_GROUP -Name $VM_NAME -Erroraction ignore
if($VM_EXIST -ne $null){
  Write-Output "$VM_NAME Exists"
}
else{
  Write-Output "Creating $VM_NAME"
  $CRED = Get-Credential -Message "Enter a username and password for the virtual machine."
  $vmParams = @{
    ResourceGroupName = $RESOURCE_GROUP
    Name = $VM_NAME
    Image="MicrosoftWindowsDesktop:Windows-10:rs5-enterprise:latest"
    PublicIpAddressName = 'nvPublicIp'
    Size=$VMSIZE
    VirtualNetworkName="nvVnet"
    SubnetName ="nvSubNet"
    SecurityGroupName ="nvNSG"
    Credential = $CRED
    OpenPorts = 3389  
  }
  $newVM1 = New-AzVM @vmParams

}

$AZEXT = Get-AzVMExtension -ResourceGroupName $RESOURCE_GROUP -VMName $VM_NAME -Name "AmdGpuDriverWindows" -Erroraction ignore

if($AZEXT -ne $null){
  Write-Output "AMD Extension Exists"
}
else
{
  Write-Output "Creating $AMD Extension"

  $extParams = @{
    ResourceGroupName=$RESOURCE_GROUP 
    VMName=$VM_NAME
    Location=$LOCATION
    Publisher="Microsoft.HpcCompute"
    ExtensionName="AmdGpuDriverWindows"
    ExtensionType="AmdGpuDriverWindows"
    TypeHandlerVersion="1.0"
    SettingString='{ }'
  }

  Set-AzVMExtension  @extParams
}
