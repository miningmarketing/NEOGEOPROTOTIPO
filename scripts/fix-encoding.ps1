param(
  [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
)

$ErrorActionPreference = 'Stop'
$utf8 = New-Object System.Text.UTF8Encoding($false)
$cp1252 = [System.Text.Encoding]::GetEncoding(1252)

# 1) Reverse the ANSI misread of generated subpages.
$subpages = @()
$subpages += Get-ChildItem -Path (Join-Path $Root 'geotecnologias') -Filter '*.html'
$subpages += Get-ChildItem -Path (Join-Path $Root 'solucoes') -Filter '*.html'

foreach ($file in $subpages) {
  $text = [System.IO.File]::ReadAllText($file.FullName, $utf8)
  $bytes = $cp1252.GetBytes($text)
  [System.IO.File]::WriteAllBytes($file.FullName, $bytes)
  Write-Host "repaired $($file.Name)"
}

# 2) Restore hub CTA labels from UTF-8 JSON.
$jsonText = [System.IO.File]::ReadAllText((Join-Path $Root 'scripts\cta-fix.json'), $utf8)
$map = $jsonText | ConvertFrom-Json

foreach ($hub in @('geotecnologias.html', 'solucoes.html')) {
  $path = Join-Path $Root $hub
  $text = [System.IO.File]::ReadAllText($path, $utf8)
  foreach ($prop in $map.PSObject.Properties) {
    $href = $prop.Name
    $label = $prop.Value
    $pattern = '(<a class="btn" href="' + [regex]::Escape($href) + '">)[^<]*(</a>)'
    $text = [regex]::Replace($text, $pattern, {
      param($m)
      return $m.Groups[1].Value + $label + $m.Groups[2].Value
    })
  }
  [System.IO.File]::WriteAllText($path, $text, $utf8)
  Write-Host "CTAs restored: $hub"
}
