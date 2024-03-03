<#
  .SYNOPSIS
  Captures URLs and IPs from the Microsoft Network Endpoints Webservice and creates Reusable Firewall Settings in Microsoft Intune.

  .DESCRIPTION
  The Invoke-MgReusableFirewall.ps1 script using Graph PowerShell tooling to capture the network endpoints for both URLs and IPs, from the
  Microsoft Endpoint Web Service (https://learn.microsoft.com/en-us/microsoft-365/enterprise/microsoft-365-ip-web-service?view=o365-worldwide)
  and grouping them by port or service to create new Reusable Firewall settings in Microsoft Intune.

  .PARAMETER tenantId
  Provide the Id of the tenant to connecto to.

  .PARAMETER serviceAreas
  An array of service areas pulled from the web service.
  Approved options: MEM, Common, Exchange, SharePoint, Skype, Store.

  .PARAMETER groupBy
  Option to group the configured Reusable Firewall settings by either ports, or by service.

  .PARAMETER Scopes
  The scopes used to connect to the Graph API using PowerShell.
  Default scopes configured are:
  'DeviceManagementConfiguration.Read.All,DeviceManagementManagedDevices.ReadWrite.All,DeviceManagementConfiguration.ReadWrite.All'

  .INPUTS
  None. You can't pipe objects to Invoke-MgReusableFirewall.ps1

  .OUTPUTS
  None. Invoke-MgReusableFirewall.ps1 doesn't generate any output.

  .EXAMPLE
  PS> .\Invoke-MgReusableFirewall.ps1 -tenantId 36019fe7-a342-4d98-9126-1b6f94904ac7 -serviceAreas 'Common, MEM' -groupBy 'service'

#>
[CmdletBinding()]

param(

    [Parameter(Mandatory = $true)]
    [String]$tenantId,

    [Parameter(Mandatory = $false)]
    [String[]]$serviceAreas = @('Common', 'MEM', 'Skype', 'Exchange', 'SharePoint', 'Store'),

    [Parameter(Mandatory = $true)]
    [ValidateSet('ports', 'service')]
    [String]$groupBy,

    [Parameter(Mandatory = $false)]
    [String[]]$scopes = 'DeviceManagementConfiguration.Read.All,DeviceManagementManagedDevices.ReadWrite.All,DeviceManagementConfiguration.ReadWrite.All'

)

#region Functions
Function Test-JSON() {

    param (
        $JSON
    )

    try {
        $TestJSON = ConvertFrom-Json $JSON -ErrorAction Stop
        $TestJSON | Out-Null
        $validJson = $true
    }
    catch {
        $validJson = $false
        $_.Exception
    }
    if (!$validJson) {
        Write-Host "Provided JSON isn't in valid JSON format" -f Red
        break
    }

}
Function New-DeviceReusableSetting() {

    [cmdletbinding()]

    param
    (
        [parameter(Mandatory = $true)]
        $JSON
    )

    $graphApiVersion = 'Beta'
    $Resource = 'deviceManagement/reusablePolicySettings'

    try {
        Test-Json -Json $JSON
        $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
        Invoke-MgGraphRequest -Uri $uri -Method Post -Body $JSON -ContentType 'application/json'
    }
    catch {
        $exs = $Error.ErrorDetails
        $ex = $exs[0]
        Write-Host "Response content:`n$ex" -f Red
        Write-Host
        Write-Error "Request to $Uri failed with HTTP Status $($ex.Message)"
        Write-Host
        break
    }
}
Function Get-DeviceReusableSetting() {

    [cmdletbinding()]

    param
    (
    )

    $graphApiVersion = 'Beta'
    $Resource = 'deviceManagement/reusablePolicySettings'

    try {
        $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
        Invoke-MgGraphRequest -Uri $uri -Method Get
    }
    catch {
        $exs = $Error.ErrorDetails
        $ex = $exs[0]
        Write-Host "Response content:`n$ex" -f Red
        Write-Host
        Write-Error "Request to $Uri failed with HTTP Status $($ex.Message)"
        Write-Host
        break
    }
}
#endregion Functions

#region authentication

if (Get-MgContext) {
    Write-Host 'Disconnecting from existing Graph session.' -ForegroundColor Cyan
    Disconnect-MgGraph
}
$moduleName = 'Microsoft.Graph'
$Module = Get-InstalledModule -Name $moduleName
if ($Module.count -eq 0) {
    Write-Host "$moduleName module is not available" -ForegroundColor yellow
    $Confirm = Read-Host Are you sure you want to install module? [Y] Yes [N] No
    if ($Confirm -match '[yY]') {
        Install-Module -Name $moduleName -AllowClobber -Scope AllUsers -Force
    }
    else {
        Write-Host "$moduleName module is required. Please install module using 'Install-Module $moduleName -Scope AllUsers -Force' cmdlet." -ForegroundColor Yellow
        break
    }
}
else {
    If ($IsMacOS) {
        Connect-MgGraph -Scopes $scopes -UseDeviceAuthentication -TenantId $tenantId
    }
    ElseIf ($IsWindows) {
        Connect-MgGraph -Scopes $scopes -UseDeviceCode -TenantId $tenantId
    }
    Else {
        Connect-MgGraph -Scopes $scopes -TenantId $tenantId
    }

    $graphDetails = Get-MgContext
    if ($null -eq $graphDetails) {
        Write-Host "Not connected to Graph, please review any errors and try to run the script again' cmdlet." -ForegroundColor Red
        break
    }
}
#endregion authentication

#region script

$tenantId = '91fbf4fe-2638-41c6-9978-28d59cc5d551'
$groupBy = 'service'
$serviceAreas = 'MEM'


Write-host"█▀▄▀█ █ █▀▀ █▀█ █▀█ █▀ █▀█ █▀▀ ▀█▀   █▀█ █▄░█ █░░ █ █▄░█ █▀▀   █▀█ █▀▀ █░█ █▀ ▄▀█ █▄▄ █░░ █▀▀" -ForegroundColor Red
Write-host"█░▀░█ █ █▄▄ █▀▄ █▄█ ▄█ █▄█ █▀░ ░█░   █▄█ █░▀█ █▄▄ █ █░▀█ ██▄   █▀▄ ██▄ █▄█ ▄█ █▀█ █▄█ █▄▄ ██▄" -ForegroundColor Red
Write-Host
Write-host"█▀▀ █ █▀█ █▀▀ █░█░█ ▄▀█ █░░ █░░   █▀ █▀▀ ▀█▀ ▀█▀ █ █▄░█ █▀▀   █▀▀ █▀█ █▀▀ ▄▀█ ▀█▀ █▀█ █▀█" -ForegroundColor Red
Write-host"█▀░ █ █▀▄ ██▄ ▀▄▀▄▀ █▀█ █▄▄ █▄▄   ▄█ ██▄ ░█░ ░█░ █ █░▀█ █▄█   █▄▄ █▀▄ ██▄ █▀█ ░█░ █▄█ █▀▄" -ForegroundColor Red
Write-Host

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$reusableSettings = @()

foreach ($serviceArea in $serviceAreas) {
    Write-Host "Getting Network Endpoints for $serviceArea Service" -ForegroundColor Cyan
    # No endpoint URL for Microsoft Store
    if ($serviceArea -eq 'Store') {
        $reusableSettings += [pscustomobject]@{displayName = 'Microsoft Store URLs'; description = 'Network Endpoints for Microsoft Store on TCP Ports(s) 80,443'; urls = @('displaycatalog.md.mp.microsoft.com', 'purchase.md.mp.microsoft.com', 'licensing.mp.microsoft.com', 'storeedgefd.dsx.mp.microsoft.com'); ips = ''; ipsName = '' }
    }
    else {
        try {
            $endpoints = (Invoke-RestMethod -Uri ("https://endpoints.office.com/endpoints/WorldWide?ServiceAreas=$serviceArea`&`clientrequestid=" + ([GUID]::NewGuid()).Guid)) | Where-Object { $_.ServiceArea -eq $serviceArea }
            Write-Host "Found $($endpoints.Count) Network Endpoints for $serviceArea Service" -ForegroundColor Green

        }
        catch {
            Write-Host "Unable to get Network Endpoints for $serviceArea" -ForegroundColor Red
            Write-Error $_.ErrorDetails
            break
        }

        if ($groupBy -eq 'ports') {
            Write-Host "Grouping Reusable Firewall Rules by Ports for $serviceArea Service" -ForegroundColor Cyan
            $tcpGroups = $endpoints | Where-Object { $null -ne $_.tcpPorts } | Group-Object -Property { $_.tcpPorts }

            foreach ($tcpGroup in $tcpGroups) {

                Clear-Variable -Name ('displayName', 'description', 'urls', 'ips', 'ipsName', 'tcpPorts') -ErrorAction Ignore

                $urls = $tcpGroup.Group.urls | Sort-Object | Get-Unique
                $ips = $tcpGroup.Group.ips | Sort-Object | Get-Unique
                $tcpPorts = $tcpGroup.Name
                $name = $tcpGroup.Group.serviceAreaDisplayName | Sort-Object | Get-Unique
                $displayName = $name + ' TCP ' + $tcpPorts
                $description = "Network Endpoints for $name on TCP Port(s) $($tcpGroup.Name)"
                $ipsName = "IP Addresses for $name"
                $reusableSettings += [pscustomobject]@{displayName = $displayName; description = $description; urls = $urls; ips = $ips; ipsName = $ipsName }

            }

            $udpGroups = $endpoints | Where-Object { $null -ne $_.udpPorts } | Group-Object -Property { $_.udpPorts }
            foreach ($udpGroup in $udpGroups) {

                Clear-Variable -Name ('displayName', 'description', 'urls', 'ips', 'ipsName', 'udpPorts') -ErrorAction Ignore

                $urls = $udpGroup.Group.urls | Sort-Object | Get-Unique
                $ips = $udpGroup.Group.ips | Sort-Object | Get-Unique
                $udpPorts = $udpGroup.Name
                $name = $udpGroup.Group.serviceAreaDisplayName | Sort-Object | Get-Unique
                $displayName = $name + ' UDP ' + $udpPorts
                $description = "Network Endpoints for $name on UDP Port(s) $($udpGroup.Name)"
                $ipsName = "IP Addresses for $name"

                $reusableSettings += [pscustomobject]@{displayName = $displayName; description = $description; urls = $urls; ips = $ips; ipsName = $ipsName }
            }
        }
        elseif ($groupBy -eq 'service') {
            $serviceGroups = $endpoints | Where-Object { $null -ne $_.tcpPorts } | Group-Object -Property { $_.serviceArea }

            Clear-Variable -Name ('displayName', 'description', 'urls', 'ips', 'ipsName') -ErrorAction Ignore

            $urls = $serviceGroups.Group.urls | Sort-Object | Get-Unique
            $ips = $serviceGroups.Group.ips | Sort-Object | Get-Unique
            $name = $serviceGroups.Group.serviceAreaDisplayName | Sort-Object | Get-Unique
            $displayName = $name + ' URLs and IPs'
            $description = "All URL and IP Network Endpoints for $name"
            $ipsName = "IP Addresses for $name"

            # Plus one as IPs only count as a single setting
            if (($urls.Count + 1) -le 100) {
                $reusableSettings += [pscustomobject]@{displayName = $displayName; description = $description; urls = $urls; ips = $ips; ipsName = $ipsName }
            }
            else {
                $displayName = $name + ' IPs'
                $description = "IP Network Endpoints for $name"
                $reusableSettings += [pscustomobject]@{displayName = $displayName; description = $description; urls = ''; ips = $ips; ipsName = $ipsName }

                $counter = [pscustomobject] @{ Value = 0 }
                $groupSize = 100
                $urlSubSets = $urls | Group-Object -Property { [math]::Floor($counter.Value++ / $groupSize) }

                foreach ($urlSubSet in $urlSubSets) {
                    $displayName = $name + ' URLs ' + $urlSubSet.Name
                    $description = "URL Network Endpoints for $name"
                    $reusableSettings += [pscustomobject]@{displayName = $displayName; description = $description; urls = $urlSubSet.Group; ips = ''; ipsName = '' }
                }
            }
        }
    }
}

Write-Host 'Please review the Microsoft Intune Reusable Firewall Settings' -ForegroundColor Yellow
Write-Host
Write-Host 'Reusable Firewall Setting Names:' -ForegroundColor Cyan
Write-Host "$($reusableSettings.displayName)" -ForegroundColor Magenta
Write-Host
Write-Host 'Reusable Firewall Setting URls:' -ForegroundColor Cyan
Write-Host "$($reusableSettings.urls)" -ForegroundColor Magenta
Write-Host
Write-Host 'Reusable Firewall Setting IP:' -ForegroundColor Cyan
Write-Host "$($reusableSettings.ips)" -ForegroundColor Magenta
Write-Host
Write-Warning 'Please review the above and confirm you are happy to continue.' -WarningAction Inquire
Write-Host

foreach ($reusableSetting in $reusableSettings) {

    Write-Host "Building JSON for $($reusableSetting.displayName) with $($reusableSetting.urls.Count) URLs and $($reusableSetting.ips.Count) IPs." -ForegroundColor Cyan

    Clear-Variable *JSON

    $startJSON = @"
    {
        "displayName": "$($reusableSetting.displayName)",
        "description": "$($reusableSetting.$description)",
        "settingDefinitionId": "vendor_msft_firewall_mdmstore_dynamickeywords_addresses_{id}",
        "settingInstance": {
            "@odata.type": "#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance",
            "settingDefinitionId": "vendor_msft_firewall_mdmstore_dynamickeywords_addresses_{id}",
            "groupSettingCollectionValue": [

"@

    if (-not ([string]::IsNullOrEmpty($($reusableSetting.urls)))) {
        $urlsJSON = @()
        foreach ($url in $($reusableSetting.urls)) {
            if ($null -eq $ips) {
                if ($url -eq $($reusableSetting.urls)[0] -and $($reusableSetting.urls).Count -eq 1) {
                    # no comma
                    $urlJSON = @"
                {
                    "children": [
                        {
                            "@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
                            "settingDefinitionId": "vendor_msft_firewall_mdmstore_dynamickeywords_addresses_{id}_autoresolve",
                            "choiceSettingValue": {
                                "@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
                                "value": "vendor_msft_firewall_mdmstore_dynamickeywords_addresses_{id}_autoresolve_true",
                                "children": []
                            }
                        },
                        {
                            "@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
                            "settingDefinitionId": "vendor_msft_firewall_mdmstore_dynamickeywords_addresses_{id}_keyword",
                            "simpleSettingValue": {
                                "@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue",
                                "value": "$url"
                            }
                        }
                    ]
                }

"@
                }
                elseif ($url -eq $($reusableSetting.urls)[-1]) {
                    # no comma
                    $urlJSON = @"
                {
                    "children": [
                        {
                            "@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
                            "settingDefinitionId": "vendor_msft_firewall_mdmstore_dynamickeywords_addresses_{id}_autoresolve",
                            "choiceSettingValue": {
                                "@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
                                "value": "vendor_msft_firewall_mdmstore_dynamickeywords_addresses_{id}_autoresolve_true",
                                "children": []
                            }
                        },
                        {
                            "@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
                            "settingDefinitionId": "vendor_msft_firewall_mdmstore_dynamickeywords_addresses_{id}_keyword",
                            "simpleSettingValue": {
                                "@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue",
                                "value": "$url"
                            }
                        }
                    ]
                }

"@
                }
                else {
                    # comma
                    $urlJSON = @"
                {
                    "children": [
                        {
                            "@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
                            "settingDefinitionId": "vendor_msft_firewall_mdmstore_dynamickeywords_addresses_{id}_autoresolve",
                            "choiceSettingValue": {
                                "@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
                                "value": "vendor_msft_firewall_mdmstore_dynamickeywords_addresses_{id}_autoresolve_true",
                                "children": []
                            }
                        },
                        {
                            "@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
                            "settingDefinitionId": "vendor_msft_firewall_mdmstore_dynamickeywords_addresses_{id}_keyword",
                            "simpleSettingValue": {
                                "@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue",
                                "value": "$url"
                            }
                        }
                    ]
                },

"@
                }
            }
            else {
                $urlJSON = @"
                {
                    "children": [
                        {
                            "@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
                            "settingDefinitionId": "vendor_msft_firewall_mdmstore_dynamickeywords_addresses_{id}_autoresolve",
                            "choiceSettingValue": {
                                "@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
                                "value": "vendor_msft_firewall_mdmstore_dynamickeywords_addresses_{id}_autoresolve_true",
                                "children": []
                            }
                        },
                        {
                            "@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
                            "settingDefinitionId": "vendor_msft_firewall_mdmstore_dynamickeywords_addresses_{id}_keyword",
                            "simpleSettingValue": {
                                "@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue",
                                "value": "$url"
                            }
                        }
                    ]
                },

"@
            }
            $urlsJSON += $urlJSON
        }
    }

    if (-not ([string]::IsNullOrEmpty($($reusableSetting.ips)))) {

        $ipStartJSON = @'
                {
                    "children": [
                        {
                            "@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance",
                            "settingDefinitionId": "vendor_msft_firewall_mdmstore_dynamickeywords_addresses_{id}_autoresolve",
                            "choiceSettingValue": {
                                "@odata.type": "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue",
                                "value": "vendor_msft_firewall_mdmstore_dynamickeywords_addresses_{id}_autoresolve_false",
                                "children": [
                                    {
                                        "@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance",
                                        "settingDefinitionId": "vendor_msft_firewall_mdmstore_dynamickeywords_addresses_{id}_addresses",
                                        "simpleSettingCollectionValue": [

'@
        $ipsJSON = @()
        foreach ($ip in $($reusableSetting.ips)) {
            if ($ip -eq $($reusableSetting.ips)[0] -and $($reusableSetting.ips).Count -eq 1) {
                $ipJSON = @"
                                            {
                                                "value": "$ip",
                                                "@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue"
                                            }

"@
            }
            elseif ($ip -eq $($reusableSetting.ips)[-1]) {
                $ipJSON = @"
                                            {
                                                "value": "$ip",
                                                "@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue"
                                            }

"@
            }
            else {
                $ipJSON = @"
                                            {
                                                "value": "$ip",
                                                "@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue"
                                            },

"@
            }
            $ipsJSON += $ipJSON
        }

        $ipEndJSON = @"
                                                ]
                                        }
                                    ]
                                }
                            },
                            {
                                "@odata.type": "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance",
                                "settingDefinitionId": "vendor_msft_firewall_mdmstore_dynamickeywords_addresses_{id}_keyword",
                                "simpleSettingValue": {
                                    "@odata.type": "#microsoft.graph.deviceManagementConfigurationStringSettingValue",
                                    "value": "$($reusableSetting.ipsName)"
                                }
                            }
                        ]
                    }

"@

        $ipFullJSON = $ipStartJSON + $ipsJSON + $ipEndJSON
    }

    $endJSON = @'
                ]
        },
        "@odata.type": "#microsoft.graph.deviceManagementReusablePolicySetting",
        "id": "73d46494-6e54-4fbc-9707-e69bfef7d538"
    }
'@

    $JSON = $startJSON + $urlsJSON + $ipFullJSON + $endJSON
    #$outfile = $($reusableSetting.displayName) + '.json'
    #$JSON | Out-File $outfile
    Try {
        Write-Host "Creating Reusable Firewall Setting for $($reusableSetting.displayName) in Microsoft Intune" -ForegroundColor Cyan
        New-DeviceReusableSetting -JSON $JSON
        Write-Host "Successfully created Reusable Firewall Setting for $($reusableSetting.displayName) in Microsoft Intune" -ForegroundColor Green
    }
    Catch {
        Write-Host ''
    }



}
#endregion script