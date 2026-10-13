# One-time setup so 'Start demo (network).bat' can serve the demo to other machines on port 8080.
# Run through 'Network setup (admin).bat', which asks for administrator rights.
# Undo:  netsh http delete urlacl url=http://+:8080/   and   Remove-NetFirewallRule -DisplayName 'Novaceris demo (TCP 8080)'
param([int]$Port = 8080)
$rule = "Novaceris demo (TCP $Port)"
Write-Host "Allowing this laptop to serve the Novaceris demo on port $Port ..."
netsh http delete urlacl url=http://+:$Port/ 2>&1 | Out-Null
netsh http add urlacl url=http://+:$Port/ 'sddl=D:(A;;GX;;;WD)'
Remove-NetFirewallRule -DisplayName $rule -ErrorAction SilentlyContinue
# Office and private networks only, never public Wi-Fi
New-NetFirewallRule -DisplayName $rule -Direction Inbound -Protocol TCP -LocalPort $Port -Action Allow -Profile Domain,Private | Out-Null
Write-Host ""
Write-Host "Done. Start the demo with 'Start demo (network).bat'."
Write-Host "Other machines can then open http://$($env:COMPUTERNAME.ToLower()):$Port/"
Read-Host 'Press Enter to close'
