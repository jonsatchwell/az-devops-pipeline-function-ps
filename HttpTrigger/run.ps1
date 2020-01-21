using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
$name = $Request.Query.BuildName
if (-not $name) {
    $name = $Request.Body.BuildName
}

if ($name) {
    $personalToken = $env:PatToken
    $token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($personalToken)"))
    $header = @{authorization = "Basic $token"}

    Write-Host "Queue a build"
    $hash = [ordered]@{
        definition = [ordered]@{
            id=$env:DefId;
        }
    }

    $json = $hash | ConvertTo-Json
    $orgUrl = $env:OrgUrl
    $queBuildUrl = "$orgUrl/_apis/build/builds?api-version=5.1"
    $result = Invoke-RestMethod -Uri $queBuildUrl -Method Post -ContentType "application/json" -Headers $header -Body $json

    $buildNumber = $result.buildNumber
    if ($buildNumber) {
        $status = [HttpStatusCode]::OK
        $body = "Queued pipeline $name, $buildNumber" 
    }
    else
    {
        $status = [HttpStatusCode]::BadRequest
        $body = "Pipeline could not be called. details: $result"
    }
}
else {
    $status = [HttpStatusCode]::BadRequest
    $body = "Please pass a name on the query string or in the request body."
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $status
    Body = $body
})
