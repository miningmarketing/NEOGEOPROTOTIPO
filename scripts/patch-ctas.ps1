param(
  [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
)

$ErrorActionPreference = 'Stop'
$utf8 = New-Object System.Text.UTF8Encoding($false)
$old = '<a class="btn" href="contato.html">Quero falar sobre meu projeto</a>'

function Get-Button([string]$label, [string]$href) {
  return '<a class="btn" href="' + $href + '">' + $label + '</a>'
}

# Geotecnologias: occurrences 1 (hero) and 8 (final CTA) stay generic.
$geoReplacements = @(
  (Get-Button 'Quero conhecer os métodos elétricos e eletromagnéticos' 'geotecnologias/metodos-eletricos-e-eletromagneticos.html'),
  (Get-Button 'Quero conhecer os métodos sísmicos' 'geotecnologias/metodos-sismicos.html'),
  (Get-Button 'Quero conhecer os métodos potenciais' 'geotecnologias/metodos-potenciais.html'),
  (Get-Button 'Quero conhecer o radar e a investigação de alta resolução' 'geotecnologias/radar-e-investigacao-de-alta-resolucao.html'),
  (Get-Button 'Quero conhecer os levantamentos com drones' 'geotecnologias/levantamentos-aereos-com-drones.html'),
  (Get-Button 'Quero conhecer a perfilagem geofísica' 'geotecnologias/perfilagem-geofisica.html')
)

# Aplicações: occurrences 1 (hero) and 9 (final CTA) stay generic.
$solReplacements = @(
  (Get-Button 'Quero conhecer as aplicações para Geotecnia' 'solucoes/geotecnia.html'),
  (Get-Button 'Quero conhecer as aplicações para Exploração Mineral' 'solucoes/exploracao-mineral.html'),
  (Get-Button 'Quero conhecer as aplicações para Engenharia' 'solucoes/engenharia.html'),
  (Get-Button 'Quero conhecer as aplicações para Hidrogeologia' 'solucoes/hidrogeologia.html'),
  (Get-Button 'Quero conhecer as aplicações para Arqueologia' 'solucoes/arqueologia.html'),
  (Get-Button 'Quero conhecer as aplicações para Hidrossedimentologia' 'solucoes/hidrossedimentologia.html'),
  (Get-Button 'Quero conhecer as aplicações de Monitoramento' 'solucoes/monitoramento.html')
)

function Update-Hub([string]$fileName, [string[]]$replacements, [int]$first, [int]$last) {
  $path = Join-Path $Root $fileName
  $content = [System.IO.File]::ReadAllText($path, $utf8)
  $parts = [regex]::Split($content, [regex]::Escape($old))
  $count = $parts.Length - 1
  $sb = New-Object System.Text.StringBuilder
  for ($i = 0; $i -lt $parts.Length; $i++) {
    [void]$sb.Append($parts[$i])
    if ($i -lt $count) {
      $occurrence = $i + 1
      if ($occurrence -ge $first -and $occurrence -le $last) {
        [void]$sb.Append($replacements[$occurrence - $first])
      } else {
        [void]$sb.Append($old)
      }
    }
  }
  [System.IO.File]::WriteAllText($path, $sb.ToString(), $utf8)
  Write-Host "$fileName : $count CTAs encontrados; substituídos $first..$last"
}

Update-Hub 'geotecnologias.html' $geoReplacements 2 7
Update-Hub 'solucoes.html' $solReplacements 2 8
