using module .\TableStorage.psm1

$tableName = 'vms'
$client = [TableClient]::new('', $tableName)
# $vmList = Get-AzVm

foreach ($vm in $vmList) {
  ($vm.OSProfile.WindowsConfiguration) ? $($ostype = 'Windows') : $($ostype = 'Linux')
  $vmEntity = [VmEntity]::new($vm.location, $vm.id, $vm.name, $vm.hardwareprofile.vmsize, $ostype)
  $client.Execute($vmEntity)
}