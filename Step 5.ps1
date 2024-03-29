# Function to enable DNS over HTTPS (DoH)
function enableDoH {
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters"
    Set-ItemProperty -Path $regPath -Name "EnableAutoDoH" -Value 2
    Write-Output "DNS over HTTPS (DoH) enabled. Please reboot your computer."
}

# Function to test DNS blocking and display current DNS
function testDNSBlock {
    # Get DNS server for the specified network interface (change "Ethernet 3" to your interface name)
    $interfaceName = "Ethernet 3"
    $originalDNS = (Get-DnsClientServerAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -eq $interfaceName}).ServerAddresses

    # Output original DNS server
    Write-Output "Original DNS server for $($interfaceName): $originalDNS"

    # Resolve IP address of malware domain
    $malwareDomain = "malware.testcategory.com"
    try {
        $malwareIP = [System.Net.Dns]::GetHostAddresses($malwareDomain)[0].IPAddressToString
        if ($malwareIP -eq "0.0.0.0") {
            Write-Output "Malware domain is blocked by DNS filtering."
        } else {
            Write-Output "Malware domain is not blocked by DNS filtering."
        }
    } catch {
        Write-Output "DNS resolution for $malwareDomain failed. Error: $_"
    }
}

# Main script logic
$firstArgument = $args[0]

if ($firstArgument -eq "DoH-test") {
    testDNSBlock
}
elseif ($firstArgument -eq "DoH-enable") {
    enableDoH
}
else {
    Write-Output "Error: Unknown command. Please use 'DoH-test' or 'DoH-enable' as the first argument."
}
