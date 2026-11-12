param(
  [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
)

$ErrorActionPreference = 'Stop'
$utf8 = New-Object System.Text.UTF8Encoding($false)

$templatePath = Join-Path $Root 'scripts/subpage-template.html'
$template = [System.IO.File]::ReadAllText($templatePath, $utf8)

$groupFiles = @('scripts/geo-data.json', 'scripts/sol-data.json')

foreach ($groupFile in $groupFiles) {
  $jsonText = [System.IO.File]::ReadAllText((Join-Path $Root $groupFile), $utf8)
  $group = $jsonText | ConvertFrom-Json

  $dir = Join-Path $Root $group.folder
  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }

  foreach ($item in $group.items) {
    $paragraphs = ($item.paragraphs | ForEach-Object { "<p>$_</p>" }) -join "`n          "
    $listItems = ($item.list | ForEach-Object { "<li>$_</li>" }) -join "`n            "

    $details = ($item.details | ForEach-Object {
      $detailParagraphs = ($_.paragraphs | ForEach-Object { "<p>$_</p>" }) -join ""
      "<article class=`"detail-item`"><h3>$($_.title)</h3>$detailParagraphs</article>"
    }) -join "`n          "

    $related = $group.items | Where-Object { $_.slug -ne $item.slug } | Select-Object -First 3
    $relatedCards = ($related | ForEach-Object {
      "<article class=`"info-card`"><h3><a href=`"$($_.slug)`">$($_.title)</a></h3><p>$($_.lead)</p></article>"
    }) -join "`n          "

    $geoActive = ''
    $solActive = ''
    if ($group.folder -eq 'geotecnologias') { $geoActive = ' aria-current="page"' }
    if ($group.folder -eq 'solucoes') { $solActive = ' aria-current="page"' }

    $html = $template
    $html = $html.Replace('{{DESC}}', $item.desc)
    $html = $html.Replace('{{TITLE}}', $item.title)
    $html = $html.Replace('{{HUB}}', $group.hub)
    $html = $html.Replace('{{HUB_LABEL}}', $group.hubLabel)
    $html = $html.Replace('{{LEAD}}', $item.lead)
    $html = $html.Replace('{{PARAGRAPHS}}', $paragraphs)
    $html = $html.Replace('{{LIST_EYEBROW}}', $group.listEyebrow)
    $html = $html.Replace('{{LIST_TITLE}}', $item.listTitle)
    $html = $html.Replace('{{LIST_ITEMS}}', $listItems)
    $html = $html.Replace('{{DETAILS_TITLE}}', $item.detailsTitle)
    $html = $html.Replace('{{DETAILS}}', $details)
    $html = $html.Replace('{{OTHER_LABEL}}', $group.otherLabel)
    $html = $html.Replace('{{RELATED}}', $relatedCards)
    $html = $html.Replace('{{GEO_ACTIVE}}', $geoActive)
    $html = $html.Replace('{{SOL_ACTIVE}}', $solActive)

    $outPath = Join-Path $dir $item.slug
    [System.IO.File]::WriteAllText($outPath, $html, $utf8)
    Write-Host "wrote $($group.folder)/$($item.slug) ($($item.details.Count) detalhes)"
  }
}
