# Function to test DNS blocking
function testDNSBlock {
    # Get DNS server for the specified network interface (change "Ethernet 3" to your interface name)
    $interfaceName = "Ethernet 3"
    $originalDNS = (Get-DnsClientServerAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -eq $interfaceName}).ServerAddresses

    # Output original DNS server
    Write-Host "Original DNS server for " + $interfaceName + ": " + $originalDNS

    # Resolve IP address of malware domain
    $malwareDomain = "malware.testcategory.com"
    $malwareIP = [System.Net.Dns]::GetHostAddresses($malwareDomain)[0].IPAddressToString

    # Check if malware domain is blocked (IP should be 0.0.0.0)
    if ($malwareIP -eq "0.0.0.0") {
        Write-Host "Malware domain is blocked by DNS filtering."
    } else {
        Write-Host "Malware domain is not blocked by DNS filtering."
    }
}

# Run the testDNSBlock function
testDNSBlock