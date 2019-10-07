using namespace System.Net

param($inputDocuments, $TriggerMetadata)

$name = $inputDocuments.r5d4fa2dc4a4c40c6b20af7715ed46769
$monday = $inputDocuments.rc23d751aa7c24c52a918e18e3bbd084c
$tuesday = $inputDocuments.rb94f4af9c3ac477980ae75f190aac4bb
$wednesday = $inputDocuments.rd4c6175772d449d6adff579270d978c1

Write-Output "$name ordered: $monday(monday) $tuesday(tuesday) $wednesday(wednesday)"
