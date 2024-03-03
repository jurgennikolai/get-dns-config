
$rootPath = 'C:\Users\Administrator.AD01\Documents\GetDNS'
$listSRVs = Get-Content -Path "$rootPath\servers.txt";
$pathCSV = "$rootPath\output.csv";

New-Item -Path $pathCSV -ItemType File -Force -Value "Hostname,DNS,Comment`n";

foreach($srv in $listSRVs)
{
    Write-Output "* Host >>> $srv";
    try
    {
        $listAllDNS = Invoke-Command -ComputerName $srv -ScriptBlock {
            (Get-DnsClientServerAddress -AddressFamily IPv4).ServerAddresses
        } -ErrorAction Stop
        $strAllDNS = $listAllDNS -join ";"
        Add-Content -Path $pathCSV -Value "$srv,$strAllDNS,Ok";
    }
    catch
    {
        $errTypeName = $_.Exception.GetType().Name ;
        Add-Content -Path $pathCSV -Value "$srv,,$errTypeName";
    }
   
}
