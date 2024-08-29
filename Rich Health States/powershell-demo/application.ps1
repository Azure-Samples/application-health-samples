New-NetFirewallRule -DisplayName 'HTTP(S) Inbound' -Direction Inbound -Action Allow -Protocol TCP -LocalPort @('8000')
$Hso = New-Object Net.HttpListener
$Hso.Prefixes.Add('http://localhost:8000/')
$Hso.Start()

function GetZoneFromImds()
{
    $imdsObject = Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -Uri "http://169.254.169.254/metadata/instance?api-version=2021-02-01"
    $zone = $imdsObject.compute.zone
    return [int]($zone)
}

function GenerateResponseJson()
{
    $zone = GetZoneFromImds

    # During grace period, Health Signal ==> Initializing
    # After grace period if application still communicates "Invalid", Health Signal ==> "Unknown" ~ "Unhealthy"

    # In this demo: If VM is in zone 1 ==> "Healthy" status, zone 2 ==> "Unhealthy" status, other zones ==> "Unknown" status
    $appHealthState = if (1 -eq $zone) { "Healthy" } elseif (2 -eq $zone) { "Unhealthy" } else { "Invalid" } 

    $hashTable = @{
        'ApplicationHealthState' = $appHealthState
    } 
    return ($hashTable | ConvertTo-Json)
}


While($Hso.IsListening)
{
    $context = $Hso.GetContext()
    $response = $context.Response
    $response.StatusCode = 200
    $response.ContentType = 'application/json'
    $responseJson = GenerateResponseJson
    $responseBytes = [System.Text.Encoding]::UTF8.GetBytes($responseJson)
    $response.OutputStream.Write($responseBytes, 0, $responseBytes.Length)
    $response.Close()
}

$Hso.Stop()