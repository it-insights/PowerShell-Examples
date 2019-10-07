using namespace System.Net

param($Request, $TriggerMetadata)

$t = get-Host

$ver = "$($t.Version.Major).$($t.Version.Minor)"

$return = @{
    'version' = $ver
    'edition' = "$($PSVersionTable.PSEdition)"
    'isWindows' = $IsWindows
}

Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = 200
    Body = (convertTo-Json -InputObject $return)
})
