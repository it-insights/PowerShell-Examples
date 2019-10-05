using module AzTable
using namespace Microsoft.Azure.Cosmos.Table

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
