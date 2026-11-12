param(
  [int]$Port = 4173,
  [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
)

$ErrorActionPreference = 'Stop'

$mime = @{
  '.html' = 'text/html; charset=utf-8'
  '.htm'  = 'text/html; charset=utf-8'
  '.css'  = 'text/css; charset=utf-8'
  '.js'   = 'application/javascript; charset=utf-8'
  '.json' = 'application/json; charset=utf-8'
  '.png'  = 'image/png'
  '.jpg'  = 'image/jpeg'
  '.jpeg' = 'image/jpeg'
  '.gif'  = 'image/gif'
  '.svg'  = 'image/svg+xml'
  '.webp' = 'image/webp'
  '.ico'  = 'image/x-icon'
  '.woff' = 'font/woff'
  '.woff2'= 'font/woff2'
}

$listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, $Port)
$listener.Start()
Write-Host "Neogeo preview: http://127.0.0.1:$Port/ (root: $Root)"

while ($true) {
  $client = $listener.AcceptTcpClient()
  try {
    $stream = $client.GetStream()
    $reader = New-Object System.IO.StreamReader($stream, [System.Text.Encoding]::ASCII, $false, 1024, $true)
    $requestLine = $reader.ReadLine()
    while ($true) {
      $line = $reader.ReadLine()
      if ([string]::IsNullOrEmpty($line)) { break }
    }

    $status = '200 OK'
    $body = [byte[]]@()
    $contentType = 'application/octet-stream'

    if ([string]::IsNullOrWhiteSpace($requestLine)) {
      $status = '400 Bad Request'
    } else {
      $parts = $requestLine -split ' '
      $method = $parts[0]
      $rawPath = if ($parts.Length -ge 2) { $parts[1] } else { '/' }
      $rawPath = $rawPath.Split('?')[0]
      $decoded = [System.Uri]::UnescapeDataString($rawPath)
      if ($decoded -eq '/') { $decoded = '/index.html' }

      $relative = $decoded.TrimStart('/').Replace('/', [System.IO.Path]::DirectorySeparatorChar)
      $fullPath = [System.IO.Path]::GetFullPath((Join-Path $Root $relative))
      $rootFull = [System.IO.Path]::GetFullPath($Root)

      if (-not $fullPath.StartsWith($rootFull, [System.StringComparison]::OrdinalIgnoreCase)) {
        $status = '403 Forbidden'
        $body = [System.Text.Encoding]::UTF8.GetBytes('403 Forbidden')
        $contentType = 'text/plain; charset=utf-8'
      } elseif ($method -ne 'GET' -and $method -ne 'HEAD') {
        $status = '405 Method Not Allowed'
        $body = [System.Text.Encoding]::UTF8.GetBytes('405 Method Not Allowed')
        $contentType = 'text/plain; charset=utf-8'
      } elseif (Test-Path -LiteralPath $fullPath -PathType Leaf) {
        $ext = [System.IO.Path]::GetExtension($fullPath).ToLowerInvariant()
        if ($mime.ContainsKey($ext)) { $contentType = $mime[$ext] }
        $body = [System.IO.File]::ReadAllBytes($fullPath)
      } else {
        $status = '404 Not Found'
        $body = [System.Text.Encoding]::UTF8.GetBytes('404 Not Found')
        $contentType = 'text/plain; charset=utf-8'
      }
    }

    $header = "HTTP/1.1 $status`r`nContent-Type: $contentType`r`nContent-Length: $($body.Length)`r`nCache-Control: no-store`r`nConnection: close`r`n`r`n"
    $headerBytes = [System.Text.Encoding]::ASCII.GetBytes($header)
    $stream.Write($headerBytes, 0, $headerBytes.Length)
    if ($body.Length -gt 0) { $stream.Write($body, 0, $body.Length) }
    $stream.Flush()
  } catch {
    # Keep serving next requests
  } finally {
    $client.Close()
  }
}
