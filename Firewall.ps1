# Function to configure firewall to block outbound connections to TCP port 80 (HTTP)
function blockHTTP {
    $ruleName = "BlockOutboundHTTP"
    
    # Create a new firewall rule to block outbound connections on TCP port 80
    New-NetFirewallRule -Name $ruleName -Direction Outbound -Protocol TCP -LocalPort 80 -Action Block
    Write-Output "Firewall rule to block outbound HTTP traffic created."
}

# Function to test if TCP port 80 (HTTP) traffic is blocked
function testHTTPBlock {
    $ruleName = "BlockOutboundHTTP"
    
    # Check if the firewall rule exists and is enabled
    $rule = Get-NetFirewallRule -Name $ruleName -ErrorAction SilentlyContinue
    if ($rule -and $rule.Enabled) {
        Write-Output "HTTP traffic is blocked."
    } else {
        Write-Output "HTTP traffic is not blocked."
    }
}

# Function to disable the firewall rule blocking HTTP traffic
function unblockHTTP {
    $ruleName = "BlockOutboundHTTP"
    
    # Check if the firewall rule exists
    $rule = Get-NetFirewallRule -Name $ruleName -ErrorAction SilentlyContinue
    
    if ($rule) {
        if ($rule.Enabled) {
            Set-NetFirewallRule -Name $ruleName -Enabled False
            Write-Output "Firewall rule blocking outbound HTTP traffic is now disabled."
        } else {
            Write-Output "Firewall rule blocking outbound HTTP traffic is already disabled."
        }
    } else {
        Write-Output "No firewall rule blocking outbound HTTP traffic found."
    }
}
