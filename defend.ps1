# Function to configure firewall to block outbound connections to TCP port 80 (HTTP)
function blockHTTP {
    $ruleName = "BlockOutboundHTTP"

    # Create a new firewall rule to block outbound connections on TCP port 80
    New-NetFirewallRule -DisplayName $ruleName -Direction Outbound -Protocol TCP -LocalPort 80 -Action Block
    Write-Output "Firewall rule to block outbound HTTP traffic created."
}

# Function to test if TCP port 80 (HTTP) traffic is blocked
function testHTTPBlock {
    $ruleName = "BlockOutboundHTTP"

    # Check if the firewall rule exists and is enabled
    $rule = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue
    if ($rule -and $rule.Enabled) {
        Write-Output "HTTP traffic is blocked."
    } else {
        Write-Output "HTTP traffic is not blocked."
    }
}

# Function to disable the firewall rule blocking HTTP traffic
function unblockHTTP {
    $ruleName = "BlockOutboundHTTP"

    # Disable and remove the firewall rule if it exists
    $rule = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue
    if ($rule) {
        Set-NetFirewallRule -Name $ruleName -Enabled False
        Remove-NetFirewallRule -Name $ruleName
        Write-Output "Firewall rule blocking outbound HTTP traffic removed."
    } else {
        Write-Output "No firewall rule blocking outbound HTTP traffic found."
    }
}

# Function to enable DNS over HTTPS (DoH)
function enableDoH {
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters"
    Set-ItemProperty -Path $regPath -Name "EnableAutoDoH" -Value 2
    Write-Output "DNS over HTTPS (DoH) enabled. Please reboot your computer."
}

# Function to reset DNS server back to 10.0.2.3
function resetDoH {
	$interfacename = "Ethernet 3"
	Set-DnsClientServerAddress -InterfaceAlias $interfaceName -ServerAddresses ("10.0.2.3")

	Write-Output "DNS server for $interfaceName reset to 10.0.2.3."
}

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

# Function to test DNS blocking and display current DNS
function testDNSBlock {
    # Get DNS server for the specified network interface (change "Ethernet 3" to your interface name)
    $interfaceName = "Ethernet 3"
    $originalDNS = (Get-DnsClientServerAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -eq $interfaceName}).ServerAddresses

    # Output original DNS server
    Write-Output "Original DNS server for $($interfaceName): $originalDNS"

    # Resolve IP address of malware domain
    $malwareDomain = "malware.testcategory.com"
    $malwareIP = [System.Net.Dns]::GetHostAddresses($malwareDomain)[0].IPAddressToString

    # Check if malware domain is blocked (IP should be 0.0.0.0)
    if ($malwareIP -eq "0.0.0.0") {
        Write-Output "Malware domain is blocked by DNS filtering."
    } else {
        Write-Output "Malware domain is not blocked by DNS filtering."
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
elseif ($firstArgument -eq "DoHsetupQuad") {
    setupQuadDoH
}
elseif ($firstArgument -eq "resetDoH") {
    resetDoH
}
elseif ($firstArgument -eq "blockHTTP") {
    blockHTTP
}
elseif ($firstArgument -eq "testHTTPBlock") {
    testHTTPBlock
}
elseif ($firstArgument -eq "unblockHTTP") {
    unblockHTTP
}
else {
    Write-Output "Error: Unknown command. Please use 'DoH-test', 'DoH-enable', 'DoHsetupQuad', 'resetDoH', 'blockHTTP', 'testHTTPBlock', or 'unblockHTTP' as the first argument."
}
