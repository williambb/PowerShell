"Getting VMware environment"
Add-PSSnapin VMware.VimAutomation.Core | Out-Null

# Connect-VIServer -Server "ACVC0101" -WarningAction 'SilentlyContinue' | Out-Null

Connect-VIServer -Server "ACVC0101"

$ProdVMware_VMs = VMware.VimAutomation.Core\Get-VM
$ProdVMware_Guests = $ProdVMware_VMs | VMware.VimAutomation.Core\Get-VMGuest
$ProdVMware_Views = VMware.VimAutomation.Core\Get-View -Viewtype virtualmachine
$ProdVMware_Hosts = VMware.VimAutomation.Core\Get-VMHost
$ProdVMware_Clusters = VMware.VimAutomation.Core\Get-Cluster
#find all VMs in the VDI cluster (or any cluster with VDI in the name)
$VDI_VMs = $null
foreach ($Cluster in $ProdVMware_Clusters)
{
	if ($Cluster.name -match '-VDI')
	{
		$VDI_VMs = $VDI_VMs + (VMware.VimAutomation.Core\Get-Cluster $Cluster | VMware.VimAutomation.Core\Get-VM)
	}
}
Disconnect-VIServer -Server "ACVC0101" -Force -Confirm:$False | Out-Null

Connect-VIServer -Server "AT01VC" -WarningAction 'SilentlyContinue' | Out-Null
$TestVMware_VMs = VMware.VimAutomation.Core\Get-VM
$TestVMware_Guests = $TestVMware_VMs | VMware.VimAutomation.Core\Get-VMGuest
$TestVMware_Views = VMware.VimAutomation.Core\Get-View -Viewtype virtualmachine
$TestVMware_Hosts = VMware.VimAutomation.Core\Get-VMHost
$TestVMware_Clusters = VMware.VimAutomation.Core\Get-Cluster
#find all VMs in the VDI cluster (or any cluster with VDI in the name)
foreach ($Cluster in $TestVMware_Clusters)
{
	if ($Cluster.name -match '-VDI')
	{
		$VDI_VMs = $VDI_VMs + (VMware.VimAutomation.Core\Get-Cluster $Cluster | VMware.VimAutomation.Core\Get-VM)
	}
}
Disconnect-VIServer -Server "AT01VC" -Force -Confirm:$False | Out-Null

$VMware_VMs = $ProdVMware_VMs + $TestVMware_VMs
$VMware_Guests = $ProdVMware_Guests + $TestVMware_Guests
