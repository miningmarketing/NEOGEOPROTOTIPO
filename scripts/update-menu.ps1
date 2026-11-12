param(
  [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
)

$ErrorActionPreference = 'Stop'
$utf8 = New-Object System.Text.UTF8Encoding($false)

$solData = [System.IO.File]::ReadAllText((Join-Path $Root 'scripts/sol-data.json'), $utf8) | ConvertFrom-Json
$solLabel = $solData.hubLabel

$files = @()
$files += Get-ChildItem -Path $Root -Filter '*.html' -File
$files += Get-ChildItem -Path (Join-Path $Root 'geotecnologias') -Filter '*.html' -File
$files += Get-ChildItem -Path (Join-Path $Root 'solucoes') -Filter '*.html' -File

foreach ($file in $files) {
  $text = [System.IO.File]::ReadAllText($file.FullName, $utf8)
  $original = $text

  $text = $text.Replace('>Tecnologias</a>', '>Geotecnologias</a>')
  $text = [regex]::Replace($text, '(<a href="(?:\.\./)?solucoes\.html"[^>]*>)Solu[^<]*(</a>)', '$1Aplica&ccedil;&otilde;es$2')
  $text = $text.Replace('Aplica&ccedil;&otilde;es', $solLabel)

  if ($text -ne $original) {
    [System.IO.File]::WriteAllText($file.FullName, $text, $utf8)
    Write-Host "menu updated: $($file.Name)"
  }
}
