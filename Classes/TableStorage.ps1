
# Interacting with Table Storage

#Requires -Modules AzTable, Az.Storage, Az.Resources

using module AzTable
using namespace Microsoft.Azure.Cosmos.Table

Class VmEntity : Microsoft.Azure.Cosmos.Table.TableEntity {
  [string]$Name
  [string]$Id
  [string]$VmSize
  [string]$OsType
    
  VmEntity($region, $resourceId, $name, $vmSize, $osType) {
    $this.PartitionKey = $region
    $this.RowKey = $resourceId.replace('/','')
    $this.Name = $name
    $this.Id = $resourceId
    $this.VmSize = $vmSize
    $this.OsType = $osType
  }
}

$tableName = 'vms'

$storageConnectionString = 'DefaultEndpointsProtocol=https;AccountName='
$storageAccount = [Microsoft.Azure.Cosmos.Table.CloudStorageAccount]::Parse($storageConnectionString)
$tableClient = [Microsoft.Azure.Cosmos.Table.CloudTableClient]::new($storageAccount.TableStorageUri, $storageAccount.Credentials)
$table = $tableClient.GetTableReference($tableName)

$vmList = Get-AzVm
foreach ($vm in $vmList) {
  ($vm.OSProfile.WindowsConfiguration) ? $($ostype = 'Windows') : $($ostype = 'Linux')
  $vmEntity = [VmEntity]::new($vm.location, $vm.id, $vm.name, $vm.hardwareprofile.vmsize, $ostype)
  $tableOperation = [Microsoft.Azure.Cosmos.Table.TableOperation]::InsertOrMerge($vmEntity)
  $result = $table.Execute($tableOperation)
  Write-Output "Name: $($vmEntity.RowKey); ReturnStatusCode: $($result.HttpStatusCode)"
}
