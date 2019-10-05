using module AzTable
using namespace Microsoft.Azure.Cosmos.Table
@{
  RootModule = 'TableStorage.psm1'
  Author = 'Jan-Henrik Damaschke (@jandamaschke)'
  ModuleVersion = '0.1'
  # Use the New-Guid command to generate a GUID, and copy/paste into the next line
  GUID = 'f50a5cd1-be19-4628-b27a-731c4e1d1f48'
  Copyright = '2019 Jan-Henrik Damaschke'
  Description = 'Interacting with Table Storage'
  # Minimum PowerShell version supported by this module (optional, recommended)
  PowerShellVersion = '5'
  # Which PowerShell Editions does this module work with? (Core, Desktop)
  CompatiblePSEditions = @('Desktop', 'Core')
  # Which PowerShell functions are exported from your module? (eg. Get-CoolObject)
  FunctionsToExport = @('')
}

#Requires -Modules AzTable, Az.Storage

Enum TableModes {
  Delete
  Insert
  InsertOrMerge
  InsertOrReplace
  Merge
  Replace
  Retrieve
}

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

Class TableClient
{
  hidden $TableClient
  hidden $Table
  [TableModes]$TableMode

  TableClient($storageConnectionString, $tablename)
  {
    $this.tableName
    $connectionString = $storageConnectionString
    $storageAccount = [Microsoft.Azure.Cosmos.Table.CloudStorageAccount]::Parse($connectionString)
    $this.TableClient = [Microsoft.Azure.Cosmos.Table.CloudTableClient]::new($storageAccount.TableStorageUri, $storageAccount.Credentials)
    $this.Table = $this.TableClient.GetTableReference($tableName)
    $this.TableMode = [TableModes]::InsertOrMerge
    Write-Host "Connected to $($this.Table.uri.AbsoluteUri) with mode $($this.TableMode)`n"
  }

  SetTableMode([TableModes]$tableMode)
  {
    $this.TableMode = $tableMode
  }

  Execute([Microsoft.Azure.Cosmos.Table.TableEntity]$tableEntry)
  {
    $tableOperation = [Microsoft.Azure.Cosmos.Table.TableOperation]::"$($this.TableMode)"($tableEntry)
    $result = $this.table.Execute($tableOperation)
    Write-Host "$($result.Result.Name) : $([System.Net.HttpStatusCode].GetEnumName($result.HttpStatusCode)) ($(($result.HttpStatusCode)))"
  }
}
