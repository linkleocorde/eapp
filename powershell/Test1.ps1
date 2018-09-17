# Test1
Write-Host Starting
$starttime = get-date

#V1 API Headers
$reqHeaders = @{}
$reqHeaders.Add("ServerHost", "www10.v1host.com")
$reqHeaders.Add("Authorization", "Bearer 1.FunS5vVyUg1pF0KfuiAuTg1CQ7Y=")
$PostUri = 'https://www10.v1host.com/NIKE01a/query.v1'

#Send to file
$report = 'C:\Users\lleoco\Documents\My Tableau Repository\Datasources\Test1.csv'

$dt = New-Object System.Data.DataTable "Test1"

#Define columns and add to tables
[void]$dt.Columns.Add("ID",[string])
[void]$dt.Columns.Add("Number",[string])
[void]$dt.Columns.Add("Name",[string])
[void]$dt.Columns.Add("AssetType",[string])
[void]$dt.Columns.Add("Category",[string])
[void]$dt.Columns.Add("Status",[string])
[void]$dt.Columns.Add("State",[string])
[void]$dt.Columns.Add("Scope",[string])
[void]$dt.Columns.Add("Child",[string])

$query = @"
{
  "from": "Epic",
  "select": [
    "Number",
    "Name",
    "AssetType",
    "Category.Name",
    "Status.Name",
    "Status.RollupState",
    "Scope.Name",
    "Subs[AssetState!='Dead'].Number"
  ],
  "where": {
    "Number": "E-12685"
  }
}
"@

$result = Invoke-RestMethod -Uri $PostUri -Body $query -Headers $reqHeaders -Method POST -ContentType 'application/json'

# $result | Format-List

foreach($rw in $result[0]){
    foreach($ch in $rw."Subs[AssetState!='Dead'].Number"){
        $nr = $dt.NewRow()

        $nr.ID = $rw."_oid"
        $nr.Number = $rw."Number"
        $nr.Name = $rw."Name"
        $nr.AssetType = $rw."AssetType"
        $nr.Category = $rw."Category.Name"
        $nr.Status = $rw."Status.Name"
        $nr.State = $rw."Status.RollupState"
        $nr.Scope = $rw."Scope.Name"    
        $nr.Child = $ch
        
        $dt.Rows.Add($nr)
    }
}

# $dt | Format-Table

Write-Host Exporting $report
$dt | Export-Csv -Path $report -NoTypeInformation

$endtime = get-date
$runtime = $endtime - $starttime
Write-Host Runtime: $runtime