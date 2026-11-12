param(
  [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path,
  [string]$BaseUrl = 'http://127.0.0.1:4173/'
)

$ErrorActionPreference = 'Stop'
$utf8 = New-Object System.Text.UTF8Encoding($false)

$rootFiles = Get-ChildItem -Path $Root -Filter '*.html' -File
$subFiles = @()
$subFiles += Get-ChildItem -Path (Join-Path $Root 'geotecnologias') -Filter '*.html' -File
$subFiles += Get-ChildItem -Path (Join-Path $Root 'solucoes') -Filter '*.html' -File
$files = @($rootFiles) + @($subFiles)

$problems = 0
foreach ($file in $files) {
  $text = [System.IO.File]::ReadAllText($file.FullName, $utf8)
  $rel = $file.FullName.Substring($Root.Length).TrimStart('\').Replace('\', '/')
  $details = ([regex]::Matches($text, [regex]::Escape('class="detail-item"'))).Count
  $oldTech = ([regex]::Matches($text, [regex]::Escape('>Tecnologias</a>'))).Count
  $oldSol = ([regex]::Matches($text, '>Solu[^<]*</a>')).Count
  $newTech = ([regex]::Matches($text, [regex]::Escape('>Geotecnologias</a>'))).Count
  $newSol = ([regex]::Matches($text, '>Aplica[^<]*</a>')).Count
  $moji = $text.Contains([char]0xFFFD)

  if ($oldTech -gt 0 -or $oldSol -gt 0) { Write-Host "MENU OLD: $rel"; $problems++ }
  if ($newTech -lt 1 -or $newSol -lt 1) { Write-Host "MENU COUNT: $rel tech=$newTech sol=$newSol"; $problems++ }
  if ($moji) { Write-Host "ENCODING: $rel"; $problems++ }

  $isSub = $rel.StartsWith('geotecnologias/') -or $rel.StartsWith('solucoes/')
  if ($isSub -and $details -eq 0) { Write-Host "NO DETAILS: $rel"; $problems++ }

  $url = $BaseUrl + $rel
  try {
    $resp = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 15
    if ($resp.StatusCode -ne 200) { Write-Host "HTTP $($resp.StatusCode): $rel"; $problems++ }
  } catch {
    Write-Host "HTTP FAIL: $rel"; $problems++
  }

  foreach ($m in [regex]::Matches($text, 'href="[^"]+\.html')) {
    $href = $m.Value.Substring(6)
    if ($href.StartsWith('http:') -or $href.StartsWith('https:') -or $href.StartsWith('mailto:') -or $href.StartsWith('tel:')) { continue }
    $target = Join-Path $file.DirectoryName $href
    if (-not (Test-Path $target)) { Write-Host "BROKEN LINK: $rel -> $href"; $problems++ }
  }

  Write-Host ("{0} details={1} menu=ok http=ok" -f $rel, $details)
}

Write-Host "TOTAL FILES: $($files.Count)"
if ($problems -gt 0) { Write-Host "PROBLEMS: $problems"; exit 1 }
Write-Host "ALL CHECKS PASSED"
