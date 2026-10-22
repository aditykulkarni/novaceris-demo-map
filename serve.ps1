# Novaceris demo map: a small local web server, no installs needed (Windows PowerShell 5 or later).
# Serves this folder on http://localhost:8080 (or the next free port) and opens the browser.
# With -Network it also answers on this laptop's name (http://<computer name>:8080) for other machines;
# that needs a one-time "Network setup (admin).bat" first. Stop it by closing this window.
# Everything it does is written to server.log next to this file, so a failed start can be looked up afterwards.
param([int]$Port = 8080, [switch]$Network)
$root = $PSScriptRoot
$logFile = Join-Path $root 'server.log'
function Log([string]$m) { try { Add-Content -LiteralPath $logFile -Value ("{0:HH:mm:ss} {1}" -f (Get-Date), $m) } catch {} }
function Fail([string]$m) { Write-Host ""; Write-Host "  $m"; Log "STOPPED: $m"; Write-Host ""; Read-Host '  Press Enter to close'; exit 1 }
try { Set-Content -LiteralPath $logFile -Value ("{0:yyyy-MM-dd HH:mm:ss} start, PowerShell {1}, {2} mode, folder {3}, network {4}" -f (Get-Date), $PSVersionTable.PSVersion, $ExecutionContext.SessionState.LanguageMode, $root, [bool]$Network) } catch {}

# Company policy can run scripts in "constrained" mode, which forbids the web server object used below.
if ($ExecutionContext.SessionState.LanguageMode -ne 'FullLanguage') {
  Fail "This laptop's security policy runs PowerShell scripts in $($ExecutionContext.SessionState.LanguageMode) mode, which blocks the demo's web server. Ask IT for an exception, or start any other local web server in this folder."
}

# Clicking inside a console window selects text and freezes the program until Enter or Esc ("QuickEdit").
# The server would stop answering and the page would hang half loaded, so QuickEdit is switched off for this window.
try {
  Add-Type -Namespace Novaceris -Name Console -MemberDefinition @'
[DllImport("kernel32.dll")] public static extern IntPtr GetStdHandle(int n);
[DllImport("kernel32.dll")] public static extern bool GetConsoleMode(IntPtr h, out uint m);
[DllImport("kernel32.dll")] public static extern bool SetConsoleMode(IntPtr h, uint m);
'@
  $h = [Novaceris.Console]::GetStdHandle(-10); [uint32]$mode = 0
  if ([Novaceris.Console]::GetConsoleMode($h, [ref]$mode)) {
    $new = $mode -bor 0x80; if ($new -band 0x40) { $new = $new - 0x40 }
    [void][Novaceris.Console]::SetConsoleMode($h, [uint32]$new)
  }
} catch { Log "QuickEdit not switched off: $($_.Exception.Message)" }

$types = @{
  '.html'='text/html; charset=utf-8'; '.js'='text/javascript; charset=utf-8'; '.mjs'='text/javascript; charset=utf-8'
  '.css'='text/css; charset=utf-8'; '.json'='application/json'; '.glb'='model/gltf-binary'; '.hdr'='application/octet-stream'
  '.png'='image/png'; '.jpg'='image/jpeg'; '.jpeg'='image/jpeg'; '.svg'='image/svg+xml'; '.webp'='image/webp'
  '.woff2'='font/woff2'; '.woff'='font/woff'; '.ttf'='font/ttf'; '.otf'='font/otf'; '.mp4'='video/mp4'; '.webm'='video/webm'; '.txt'='text/plain; charset=utf-8'; '.md'='text/plain; charset=utf-8'
}
foreach ($need in 'index.html', 'factory.glb', 'vendor\three\build\three.module.js') {
  if (-not (Test-Path -LiteralPath (Join-Path $root $need) -PathType Leaf)) { Fail "$need is missing from $root. Copy the whole demo folder again." }
}
$listener = $null
if ($Network) {
  # Any host name on this port: the computer name, its full domain name or its IP address. Fixed port, as set up by the admin script.
  $l = New-Object System.Net.HttpListener
  $l.Prefixes.Add("http://+:$Port/")
  try { $l.Start(); $listener = $l }
  catch {
    $l.Close()
    Log "port $Port (network): $($_.Exception.Message)"
    if ($_.Exception.InnerException -and $_.Exception.InnerException.ErrorCode -eq 5 -or "$_" -match 'denied') {
      Fail "Windows has not allowed this laptop to serve port $Port to the network yet. Run 'Network setup (admin).bat' once (it asks for administrator rights), then start again."
    } else { Fail "Port $Port is busy or blocked: $($_.Exception.Message)" }
  }
} else {
  for ($p = $Port; $p -lt $Port + 20; $p++) {
    $l = New-Object System.Net.HttpListener
    $l.Prefixes.Add("http://localhost:$p/")
    try { $l.Start(); $listener = $l; $Port = $p; break } catch { Log "port ${p}: $($_.Exception.Message)"; $l.Close() }
  }
  if (-not $listener) { Fail "No free port between $Port and $($Port + 19). Close other servers and try again." }
}
$url = "http://localhost:$Port/"
Log "serving $url"
Write-Host ""
Write-Host "  Novaceris demo running at $url"
if ($Port -ne 8080 -and -not $Network) { Write-Host "  (Port 8080 is taken by another program on this laptop, so use the address above, not :8080.)" }
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
Write-Host "  Keep this window open while presenting; closing it stops the demo."
Write-Host ""
try { Start-Process $url } catch { Write-Host "  Open $url in your browser."; Log "could not open the browser: $($_.Exception.Message)" }
$rootFull = [System.IO.Path]::GetFullPath($root).TrimEnd('\') + '\'   # files outside this folder are never served
$served = 0
while ($listener.IsListening) {
  $res = $null; $rel = ''
  try {
    $ctx = $listener.GetContext()
    $res = $ctx.Response
    $rel = [System.Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath).TrimStart('/')
    if ($rel -eq '') { $rel = 'index.html' }
    if ($rel -notmatch '\.[A-Za-z0-9]+$' -and (Test-Path -LiteralPath (Join-Path $rootFull ($rel.TrimEnd('/') + '.html')) -PathType Leaf)) { $rel = $rel.TrimEnd('/') + '.html' }   # /admin opens admin.html
    $file = [System.IO.Path]::GetFullPath((Join-Path $rootFull $rel))
    if (-not $file.StartsWith($rootFull, [System.StringComparison]::OrdinalIgnoreCase) -or -not (Test-Path -LiteralPath $file -PathType Leaf)) {
      if ($rel -ne 'favicon.ico') { Log "404 $rel" }
      $res.StatusCode = 404; $res.Close(); continue
    }
    $ext = [System.IO.Path]::GetExtension($file).ToLower()
    $res.ContentType = if ($types.ContainsKey($ext)) { $types[$ext] } else { 'application/octet-stream' }
    $res.Headers.Add('Cache-Control', 'no-cache')
    $bytes = [System.IO.File]::ReadAllBytes($file)
    $res.ContentLength64 = $bytes.Length
    $res.OutputStream.Write($bytes, 0, $bytes.Length)
    $res.Close()
    $served++
    if ($rel -eq 'index.html' -or $rel -eq 'factory.glb') { Log "sent $rel ($($bytes.Length) bytes, $served files so far)" }
  } catch {
    Log "error on '$rel': $($_.Exception.Message)"
    if ($res) { try { $res.Abort() } catch {} }
  }
}
