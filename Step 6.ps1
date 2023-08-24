# Function to setup Quad9 DNS over HTTPS (DoH)
function setupQuadDoH {
    # Change DNS server of Ethernet 3 to 1.1.1.2
    $interfaceName = "Ethernet 3"
    Set-DnsClientServerAddress -InterfaceAlias $interfaceName -ServerAddresses ("1.1.1.2")

    # Register the DoH template for Cloudflare
    Add-DnsClientDohServerAddress "1.1.1.2" "https://security.cloudflare-dns.com/dns-query" -AutoUpgrade $True

    # Enable DoH on Ethernet 3 using the registry
    $guid = (Get-NetAdapter -Name $interfaceName).InterfaceGuid
    $regPath = "HKLM:\System\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters\$guid\DohInterfaceSettings\Doh\1.1.1.2"

    New-Item -Path $regPath -Force | Out-Null
    Set-ItemProperty -Path $regPath -Name "DohFlags" -Value 1

    Write-Output "Quad9 DNS over HTTPS (DoH) setup completed for $interfaceName."
}
