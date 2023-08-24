# Function to reset DNS server back to 10.0.2.3
function resetDoH {
	$interfacename = "Ethernet 3"
	Set-DnsClientServerAddress -InterfaceAlias $interfaceName -ServerAddresses ("10.0.2.3")
	
	Write-Output "DNS server for $interfaceName reset to 10.0.2.3."
}
