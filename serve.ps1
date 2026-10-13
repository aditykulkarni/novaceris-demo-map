# Novaceris demo map: a small local web server, no installs needed (Windows PowerShell 5 or later).
# Serves this folder on http://localhost:8080 (or the next free port) and opens the browser.
# With -Network it also answers on this laptop's name (http://<computer name>:8080) for other machines;
# that needs a one-time "Network setup (admin).bat" first. Stop it by closing this window.
param([int]$Port = 8080, [switch]$Network)
$root = $PSScriptRoot
$types = @{
  '.html'='text/html; charset=utf-8'; '.js'='text/javascript; charset=utf-8'; '.mjs'='text/javascript; charset=utf-8'
  '.css'='text/css; charset=utf-8'; '.json'='application/json'; '.glb'='model/gltf-binary'; '.hdr'='application/octet-stream'
  '.png'='image/png'; '.jpg'='image/jpeg'; '.jpeg'='image/jpeg'; '.svg'='image/svg+xml'; '.webp'='image/webp'
  '.woff2'='font/woff2'; '.woff'='font/woff'; '.ttf'='font/ttf'; '.otf'='font/otf'; '.mp4'='video/mp4'; '.webm'='video/webm'; '.txt'='text/plain; charset=utf-8'; '.md'='text/plain; charset=utf-8'
}
$listener = $null
if ($Network) {
  # Any host name on this port: the computer name, its full domain name or its IP address. Fixed port, as set up by the admin script.
  $l = New-Object System.Net.HttpListener
  $l.Prefixes.Add("http://+:$Port/")
  try { $l.Start(); $listener = $l }
  catch {
    $l.Close()
    if ($_.Exception.InnerException -and $_.Exception.InnerException.ErrorCode -eq 5 -or "$_" -match 'denied') {
      Write-Host "Windows has not allowed this laptop to serve port $Port to the network yet."
      Write-Host "Run 'Network setup (admin).bat' once (it asks for administrator rights), then start again."
    } else { Write-Host "Port $Port is busy or blocked: $($_.Exception.Message)" }
    Read-Host 'Press Enter to close'; exit 1
  }
} else {
  for ($p = $Port; $p -lt $Port + 20; $p++) {
    $l = New-Object System.Net.HttpListener
    $l.Prefixes.Add("http://localhost:$p/")
    try { $l.Start(); $listener = $l; $Port = $p; break } catch { $l.Close() }
  }
  if (-not $listener) { Write-Host "No free port between $Port and $($Port + 19). Close other servers and try again."; Read-Host 'Press Enter to close'; exit 1 }
}
$url = "http://localhost:$Port/"
Write-Host ""
Write-Host "  Novaceris demo running at $url"
if ($Network) {
  $name = $env:COMPUTERNAME.ToLower()
  try { $fqdn = [System.Net.Dns]::GetHostEntry('').HostName.ToLower() } catch { $fqdn = $name }
  $ips = @(Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue | Where-Object { $_.IPAddress -notlike '127.*' -and $_.IPAddress -notlike '169.254.*' } | ForEach-Object { $_.IPAddress })
  Write-Host "  From other machines:  http://${name}:$Port/"
  if ($fqdn -ne $name) { Write-Host "                        http://${fqdn}:$Port/" }
  foreach ($ip in $ips) { Write-Host "                        http://${ip}:$Port/" }
  $share = "http://${name}:$Port/"
}
Write-Host "  Step links work too, for example $(if ($Network) { $share } else { $url })#step=5"
Write-Host "  Close this window to stop the demo."
Write-Host ""
Start-Process $url
$rootFull = [System.IO.Path]::GetFullPath($root).TrimEnd('\') + '\'   # files outside this folder are never served
while ($listener.IsListening) {
  try {
    $ctx = $listener.GetContext()
    $res = $ctx.Response
    $rel = [System.Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath).TrimStart('/')
    if ($rel -eq '') { $rel = 'index.html' }
    $file = [System.IO.Path]::GetFullPath((Join-Path $rootFull $rel))
    if (-not $file.StartsWith($rootFull, [System.StringComparison]::OrdinalIgnoreCase) -or -not (Test-Path -LiteralPath $file -PathType Leaf)) {
      $res.StatusCode = 404; $res.Close(); continue
    }
    $ext = [System.IO.Path]::GetExtension($file).ToLower()
    $res.ContentType = if ($types.ContainsKey($ext)) { $types[$ext] } else { 'application/octet-stream' }
    $res.Headers.Add('Cache-Control', 'no-cache')
    $bytes = [System.IO.File]::ReadAllBytes($file)
    $res.ContentLength64 = $bytes.Length
    $res.OutputStream.Write($bytes, 0, $bytes.Length)
    $res.Close()
  } catch {
    try { $res.Abort() } catch {}
  }
}
