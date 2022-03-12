param ($username)

if ( ($username -eq $null) ){
        Write-Host "Missing Args"
        Write-Host "./script.ps1 -username USER"
        exit 1
}

$config = Get-IniContent "config.ini"
$vcsa_url = $config["VCSA"]["vcsa_url"]
$vcsa_admin_username = $config["VCSA"]["vcsa_admin_username"]
$vcsa_admin_password = $config["VCSA"]["vcsa_admin_password"]

$pos = $username.IndexOf("@")
$folder = $username.Substring(0, $pos)

Set-PowerCLIConfiguration -InvalidCertificateAction ignore -Confirm:$false | out-null
Connect-VIServer -Server $vcsa_url -User $vcsa_admin_username -Password $vcsa_admin_password | out-null

New-Folder -Name $folder -Location $(Get-Folder "Clients") | out-null

Get-Folder $folder | New-VIPermission -Role 'Domain_Users' -Principal "CLOUDIS\$($username)" | out-null