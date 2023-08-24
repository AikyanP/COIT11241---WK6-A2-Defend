# Function to enable DNS over HTTPS (DoH)
function enableDoH {
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters"
    Set-ItemProperty -Path $regPath -Name "EnableAutoDoH" -Value 2
    Write-Output "DNS over HTTPS (DoH) enabled. Please reboot your computer."
}

# Function to test DNS blocking
function testDNSBlock {
    # ... (unchanged)

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
else {
    Write-Output "Error: Unknown command. Please use 'DoH-test' or 'DoH-enable' as the first argument."
}
