# Novaceris demo map: a small local web server, no installs needed (Windows PowerShell 5 or later).
# Serves this folder on http://localhost:8080 (or the next free port) and opens the browser.
# With -Network it also answers on this laptop's name (http://<computer name>:8080) for other machines;
# that needs a one-time "Network setup (admin).bat" first. Stop it by closing this window.
# Sign-in: fill casServerUrl in auth.config.json and visitors sign in through your CAS server (3DPassport) first.
param([int]$Port = 8080, [switch]$Network)
$root = $PSScriptRoot
$types = @{
  '.html'='text/html; charset=utf-8'; '.js'='text/javascript; charset=utf-8'; '.mjs'='text/javascript; charset=utf-8'
  '.css'='text/css; charset=utf-8'; '.json'='application/json'; '.glb'='model/gltf-binary'; '.hdr'='application/octet-stream'
  '.png'='image/png'; '.jpg'='image/jpeg'; '.jpeg'='image/jpeg'; '.svg'='image/svg+xml'; '.webp'='image/webp'
  '.woff2'='font/woff2'; '.woff'='font/woff'; '.ttf'='font/ttf'; '.otf'='font/otf'; '.mp4'='video/mp4'; '.webm'='video/webm'; '.txt'='text/plain; charset=utf-8'; '.md'='text/plain; charset=utf-8'
}
$hidden = @('.ps1', '.bat', '.cmd')                 # the server's own files are never served
$public = @('/login.html', '/favicon.ico')          # reachable before signing in, with everything under /fonts/

# ---------- sign-in settings ----------
$auth = $null
$cfgPath = Join-Path $root 'auth.config.json'
if (Test-Path -LiteralPath $cfgPath) {
  try { $auth = Get-Content -LiteralPath $cfgPath -Raw | ConvertFrom-Json }
  catch { Write-Host "auth.config.json is not valid JSON, so the demo will not start: $($_.Exception.Message)"; Read-Host 'Press Enter to close'; exit 1 }
}
$authOn = [bool]($auth -and $auth.casServerUrl)
if ($authOn) {
  $cas = ([string]$auth.casServerUrl).TrimEnd('/')
  $validatePath = if ($auth.validatePath) { [string]$auth.validatePath } else { '/serviceValidate' }
  $sessionHours = if ($auth.sessionHours) { [double]$auth.sessionHours } else { 12 }
  $skipLocal = $auth.skipForLocalhost -ne $false
  $allowed = @($auth.allowedUsers | Where-Object { $_ })
  [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
}
$sessions = @{}

# ---------- start listening ----------
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

# The addresses this server answers on. CAS sends people back to the one they came in on; only these are ever used.
$name = $env:COMPUTERNAME.ToLower()
try { $fqdn = [System.Net.Dns]::GetHostEntry('').HostName.ToLower() } catch { $fqdn = $name }
$bases = @("http://localhost:$Port")
if ($Network) { $bases += "http://${name}:$Port"; if ($fqdn -ne $name) { $bases += "http://${fqdn}:$Port" } }
if ($authOn -and $auth.serviceUrls) { foreach ($u in $auth.serviceUrls) { if ($u) { $bases += ([string]$u).TrimEnd('/') } } }   # your own address, e.g. a DNS alias
function Get-Base($req) {
  $h = "http://$($req.Headers['Host'])".ToLower()
  foreach ($b in $bases) { if ($b.ToLower() -eq $h) { return $b } }
  return $bases[0]
}

$url = "http://localhost:$Port/"
Write-Host ""
Write-Host "  Novaceris demo running at $url"
if ($Network) {
  $ips = @(Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue | Where-Object { $_.IPAddress -notlike '127.*' -and $_.IPAddress -notlike '169.254.*' } | ForEach-Object { $_.IPAddress })
  Write-Host "  From other machines:  http://${name}:$Port/"
  if ($fqdn -ne $name) { Write-Host "                        http://${fqdn}:$Port/" }
  foreach ($ip in $ips) { Write-Host "                        http://${ip}:$Port/" }
}
if ($authOn) {
  Write-Host "  Sign-in: on, through $cas"
  Write-Host "    CAS must accept these return addresses (service URLs):"
  foreach ($b in $bases) { Write-Host "      $b/auth/callback" }
  if ($skipLocal) { Write-Host "    This laptop's own browser on localhost skips sign-in (skipForLocalhost in auth.config.json)." }
  if ($allowed.Count) { Write-Host "    Only these users get in: $($allowed -join ', ')" }
} else { Write-Host "  Sign-in: off (set casServerUrl in auth.config.json to turn it on)" }
Write-Host "  Step links work too, for example $($bases[-1])/#step=5"
Write-Host "  Close this window to stop the demo."
Write-Host ""
Start-Process $url

function Send-Redirect($res, $to) { $res.StatusCode = 302; $res.RedirectLocation = $to; $res.Close() }
function Send-Text($res, $code, $type, $text) {
  $b = [System.Text.Encoding]::UTF8.GetBytes($text)
  $res.StatusCode = $code; $res.ContentType = $type; $res.Headers.Add('Cache-Control', 'no-store')
  $res.ContentLength64 = $b.Length; $res.OutputStream.Write($b, 0, $b.Length); $res.Close()
}
function New-SessionId {
  $b = New-Object byte[] 32
  [System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($b)
  return [Convert]::ToBase64String($b).Replace('+', '-').Replace('/', '_').TrimEnd('=')
}
function Escape($s) { [System.Uri]::EscapeDataString($s) }

$rootFull = [System.IO.Path]::GetFullPath($root).TrimEnd('\') + '\'   # files outside this folder are never served
while ($listener.IsListening) {
  try {
    $ctx = $listener.GetContext()
    $req = $ctx.Request
    $res = $ctx.Response
    $path = $req.Url.AbsolutePath

    if ($authOn) {
      $base = Get-Base $req
      $service = "$base/auth/callback"
      $sid = $null; $c = $req.Cookies['nv_session']; if ($c) { $sid = $c.Value }
      $user = $null
      if ($sid -and $sessions.ContainsKey($sid)) {
        if ($sessions[$sid].exp -gt (Get-Date)) { $user = $sessions[$sid].user } else { $sessions.Remove($sid) }
      }
      if (-not $user -and $skipLocal -and [System.Net.IPAddress]::IsLoopback($req.RemoteEndPoint.Address) -and $base -eq $bases[0]) { $user = 'local' }

      if ($path -eq '/auth/login') {
        # CAS compares the service value byte for byte between login and validation, so both use the same string
        Send-Redirect $res "$cas/login?service=$(Escape $service)"; continue
      }
      if ($path -eq '/auth/callback') {
        $ticket = $req.QueryString['ticket']
        if (-not $ticket) { Send-Redirect $res "$base/login.html?error=noticket"; continue }
        $who = $null
        try {
          $r = Invoke-WebRequest -UseBasicParsing -TimeoutSec 15 -Uri "$cas$validatePath`?ticket=$(Escape $ticket)&service=$(Escape $service)"
          $m = [regex]::Match($r.Content, '<cas:user>\s*([^<]+?)\s*</cas:user>')
          if ($m.Success) { $who = $m.Groups[1].Value }
        } catch {
          # Never trust the ticket itself as an identity: if CAS cannot be reached, nobody gets in
          Write-Host "  CAS validation failed: $($_.Exception.Message)"
          Send-Redirect $res "$base/login.html?error=unreachable"; continue
        }
        if (-not $who) { Send-Redirect $res "$base/login.html?error=invalid"; continue }
        if ($allowed.Count -and -not ($allowed -contains $who)) {
          Write-Host "  Refused $who (not in allowedUsers)"
          Send-Redirect $res "$base/login.html?error=notallowed&user=$(Escape $who)"; continue
        }
        $new = New-SessionId
        $sessions[$new] = @{ user = $who; exp = (Get-Date).AddHours($sessionHours) }
        Write-Host "  $(Get-Date -Format 'HH:mm') signed in: $who"
        $res.AppendHeader('Set-Cookie', "nv_session=$new; Path=/; HttpOnly; SameSite=Lax")
        Send-Redirect $res "$base/"; continue
      }
      if ($path -eq '/auth/logout') {
        if ($sid) { $sessions.Remove($sid) }
        $res.AppendHeader('Set-Cookie', 'nv_session=; Path=/; HttpOnly; SameSite=Lax; Max-Age=0')
        Send-Redirect $res "$cas/logout?service=$(Escape "$base/login.html?signedout=1")"; continue
      }
      if ($path -eq '/auth/me') {
        if ($user) { Send-Text $res 200 'application/json' (@{ user = $user; local = ($user -eq 'local') } | ConvertTo-Json -Compress) }
        else { Send-Text $res 401 'application/json' '{"user":null}' }
        continue
      }
      if (-not $user -and -not ($public -contains $path) -and -not $path.StartsWith('/fonts/')) {
        if ($path -eq '/' -or $path.EndsWith('.html')) { Send-Redirect $res "$base/login.html" } else { Send-Text $res 401 'text/plain' 'Sign in first.' }
        continue
      }
    } elseif ($path.StartsWith('/auth/')) { Send-Text $res 404 'application/json' '{"auth":"off"}'; continue }

    $rel = [System.Uri]::UnescapeDataString($path).TrimStart('/')
    if ($rel -eq '') { $rel = 'index.html' }
    $file = [System.IO.Path]::GetFullPath((Join-Path $rootFull $rel))
    $ext = [System.IO.Path]::GetExtension($file).ToLower()
    if (-not $file.StartsWith($rootFull, [System.StringComparison]::OrdinalIgnoreCase) -or ($hidden -contains $ext) -or $rel -eq 'auth.config.json' -or -not (Test-Path -LiteralPath $file -PathType Leaf)) {
      $res.StatusCode = 404; $res.Close(); continue
    }
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
