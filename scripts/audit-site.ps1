param(
  [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path,
  [string]$BaseUrl = ''
)

$ErrorActionPreference = 'Stop'

$strictUtf8 = New-Object System.Text.UTF8Encoding($false, $true)
$plainUtf8 = New-Object System.Text.UTF8Encoding($false)

$script:problems = 0
$script:warnings = 0
$script:copyChecks = 0
$script:copyMissing = New-Object System.Collections.Generic.List[string]
$script:sourceChecks = 0
$script:sourceMissing = New-Object System.Collections.Generic.List[string]
$script:formWarnings = New-Object System.Collections.Generic.List[string]

function Write-Fail {
  param([string]$Message)
  Write-Host "FAIL  $Message" -ForegroundColor Red
  $script:problems++
}

function Write-Warn {
  param([string]$Message)
  Write-Host "WARN  $Message" -ForegroundColor Yellow
  $script:warnings++
}

function Write-Ok {
  param([string]$Message)
  Write-Host "OK    $Message" -ForegroundColor Green
}

function Read-Utf8Strict {
  param([string]$Path)
  try {
    return [System.IO.File]::ReadAllText($Path, $strictUtf8)
  } catch {
    return $null
  }
}

function Normalize-Text {
  param([string]$Text)
  if ($null -eq $Text) { return '' }
  $value = [System.Net.WebUtility]::HtmlDecode($Text)
  $value = [regex]::Replace($value, '<[^>]*>', ' ')
  $value = $value -replace '\s+', ' '
  return $value.Trim()
}

function Get-MainText {
  param([string]$Html)
  $match = [regex]::Match($Html, '(?s)<main\b[^>]*>(.*?)</main>')
  if ($match.Success) { return Normalize-Text $match.Groups[1].Value }
  return Normalize-Text $Html
}

function Get-IdSet {
  param([string]$Html)
  $set = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::Ordinal)
  foreach ($m in [regex]::Matches($Html, '\bid="([^"]+)"')) {
    [void]$set.Add($m.Groups[1].Value)
  }
  return $set
}

function Get-AnchorRefs {
  param([string]$Html)
  $refs = New-Object System.Collections.Generic.List[string]
  foreach ($m in [regex]::Matches($Html, '<a\b[^>]*\bhref="([^"]*)"')) {
    $refs.Add([System.Net.WebUtility]::HtmlDecode($m.Groups[1].Value))
  }
  return $refs.ToArray()
}

function Assert-SourceText {
  param(
    $Value,
    [string]$Path,
    [string]$SourceText,
    [string]$RelPage
  )

  if ($null -eq $Value) { return }

  if ($Value -is [string]) {
    $text = Normalize-Text $Value
    $text = $text.TrimEnd('.', ';', ':', ',')
    if ($text.Length -lt 20) { return }
    $script:sourceChecks++
    if ($SourceText.IndexOf($text, [System.StringComparison]::OrdinalIgnoreCase) -lt 0) {
      $script:sourceMissing.Add("$RelPage :: $Path :: $text")
    }
    return
  }

  if ($Value -is [System.Collections.IEnumerable]) {
    $index = 0
    foreach ($entry in $Value) {
      Assert-SourceText -Value $entry -Path "$Path[$index]" -SourceText $SourceText -RelPage $RelPage
      $index++
    }
  }
}

function Assert-Copy {
  param(
    $Value,
    [string]$Path,
    [string]$PageText,
    [string]$RelPage
  )

  if ($null -eq $Value) { return }

  if ($Value -is [string]) {
    $text = Normalize-Text $Value
    $text = $text.TrimEnd('.', ';', ':', ',')
    if ($text.Length -lt 3) { return }
    $script:copyChecks++
    if ($PageText.IndexOf($text, [System.StringComparison]::OrdinalIgnoreCase) -lt 0) {
      $script:copyMissing.Add("$RelPage :: $Path :: $text")
    }
    return
  }

  if ($Value -is [System.Collections.IDictionary]) {
    foreach ($key in $Value.Keys) {
      if (@('id', 'slug', 'href', 'source', 'folder', 'hub', 'listLinks') -contains [string]$key) { continue }
      Assert-Copy -Value $Value[$key] -Path "$Path.$key" -PageText $PageText -RelPage $RelPage
    }
    return
  }

  if ($Value -is [System.Collections.IEnumerable]) {
    $index = 0
    foreach ($entry in $Value) {
      Assert-Copy -Value $entry -Path "$Path[$index]" -PageText $PageText -RelPage $RelPage
      $index++
    }
    return
  }

  if ($Value -is [System.Management.Automation.PSCustomObject]) {
    foreach ($property in $Value.PSObject.Properties) {
      if (@('id', 'slug', 'href', 'source', 'folder', 'hub', 'listLinks') -contains $property.Name) { continue }
      Assert-Copy -Value $property.Value -Path "$Path.$($property.Name)" -PageText $PageText -RelPage $RelPage
    }
  }
}

$rootFiles = @(Get-ChildItem -Path $Root -Filter '*.html' -File | Sort-Object Name)
$geoFiles = @(Get-ChildItem -Path (Join-Path $Root 'geotecnologias') -Filter '*.html' -File | Sort-Object Name)
$solFiles = @(Get-ChildItem -Path (Join-Path $Root 'solucoes') -Filter '*.html' -File | Sort-Object Name)
$files = @($rootFiles) + @($geoFiles) + @($solFiles)

$htmlCache = @{}
foreach ($file in $files) {
  $htmlCache[$file.FullName] = $null
}

Write-Host ''
Write-Host '=== ESTRUTURA, LINKS E ACESSIBILIDADE ===' -ForegroundColor Cyan

foreach ($file in $files) {
  $rel = $file.FullName.Substring($Root.Length).TrimStart('\').Replace('\', '/')
  $html = Read-Utf8Strict $file.FullName

  if ($null -eq $html) {
    Write-Fail "$rel nao esta em UTF-8 valido"
    continue
  }
  $htmlCache[$file.FullName] = $html

  if ($html.Contains([char]0xFFFD)) { Write-Fail "$rel contem caractere de substituicao U+FFFD" }
  if (-not $html.StartsWith('<!DOCTYPE html>')) { Write-Fail "$rel sem doctype HTML5" }
  if ($html -notmatch '<html\s+lang="pt-BR"') { Write-Fail "$rel sem lang=pt-BR" }
  if ($html -notmatch '<meta\s+charset="UTF-8"') { Write-Fail "$rel sem meta charset UTF-8" }
  if ($html -notmatch '<meta\s+name="viewport"') { Write-Fail "$rel sem meta viewport" }

  $titleMatch = [regex]::Match($html, '(?s)<title>(.*?)</title>')
  if (-not $titleMatch.Success -or (Normalize-Text $titleMatch.Groups[1].Value).Length -lt 8) {
    Write-Fail "$rel sem title descritivo"
  }

  $descMatch = [regex]::Match($html, '<meta\s+name="description"\s+content="([^"]+)"')
  if (-not $descMatch.Success -or $descMatch.Groups[1].Value.Trim().Length -lt 40) {
    Write-Fail "$rel sem meta description adequada"
  }

  $h1Count = ([regex]::Matches($html, '<h1\b')).Count
  if ($h1Count -ne 1) { Write-Fail "$rel possui $h1Count elementos H1 (esperado 1)" }

  $ids = Get-IdSet $html
  $duplicateIds = New-Object System.Collections.Generic.List[string]
  $seenIds = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::Ordinal)
  foreach ($m in [regex]::Matches($html, '\bid="([^"]+)"')) {
    $id = $m.Groups[1].Value
    if (-not $seenIds.Add($id)) { $duplicateIds.Add($id) }
  }
  foreach ($duplicate in $duplicateIds) { Write-Fail "$rel id duplicado: $duplicate" }

  if ($html -match 'href="#"') { Write-Fail "$rel contem href=`"#`" como destino final" }
  if ($html -match '\[BLOCO') { Write-Fail "$rel contem marcador editorial [BLOCO]" }

  $hrefs = Get-AnchorRefs $html
  foreach ($href in $hrefs) {
    if ([string]::IsNullOrWhiteSpace($href)) { Write-Fail "$rel link com href vazio"; continue }
    if ($href -eq '#') { Write-Fail "$rel link href=`"#`""; continue }
    if ($href -match '^(https?://|mailto:|tel:)') { continue }
    if ($href -match '^(javascript:|data:)') { Write-Fail "$rel destino proibido: $href"; continue }

    $hash = ''
    $pathPart = $href
    $hashIndex = $href.IndexOf('#')
    if ($hashIndex -ge 0) {
      $pathPart = $href.Substring(0, $hashIndex)
      $hash = $href.Substring($hashIndex + 1)
    }

    if ($pathPart.Length -eq 0) {
      if ($hash.Length -gt 0 -and -not $ids.Contains($hash)) {
        Write-Fail "$rel ancora inexistente: #$hash"
      }
      continue
    }

    $targetPath = $pathPart
    if ($targetPath.StartsWith('/')) {
      $targetPath = $targetPath.TrimStart('/').Replace('/', [System.IO.Path]::DirectorySeparatorChar)
      $resolved = Join-Path $Root $targetPath
    } else {
      $targetPath = $targetPath.Replace('/', [System.IO.Path]::DirectorySeparatorChar)
      $resolved = Join-Path $file.DirectoryName $targetPath
    }

    if (-not (Test-Path -LiteralPath $resolved -PathType Leaf)) {
      Write-Fail "$rel link quebrado: $href"
      continue
    }

    if ($hash.Length -gt 0) {
      $targetHtml = if ($htmlCache.ContainsKey($resolved)) { $htmlCache[$resolved] } else { $null }
      if ($null -eq $targetHtml) {
        $targetHtml = Read-Utf8Strict $resolved
        $htmlCache[$resolved] = $targetHtml
      }
      if ($null -eq $targetHtml) {
        Write-Fail "$rel nao foi possivel ler destino de ancora: $href"
      } else {
        $targetIds = Get-IdSet $targetHtml
        if (-not $targetIds.Contains($hash)) { Write-Fail "$rel ancora inexistente em $pathPart : #$hash" }
      }
    }
  }

  foreach ($m in [regex]::Matches($html, '<link\b[^>]*\bhref="([^"]+)"')) {
    $href = [System.Net.WebUtility]::HtmlDecode($m.Groups[1].Value)
    if ($href -match '^(https?://|data:)') { continue }
    $asset = Join-Path $file.DirectoryName $href.Replace('/', [System.IO.Path]::DirectorySeparatorChar)
    if (-not (Test-Path -LiteralPath $asset -PathType Leaf)) { Write-Fail "$rel asset CSS ausente: $href" }
  }
  foreach ($m in [regex]::Matches($html, '<script\b[^>]*\bsrc="([^"]+)"')) {
    $src = [System.Net.WebUtility]::HtmlDecode($m.Groups[1].Value)
    if ($src -match '^(https?://|data:)') { continue }
    $asset = Join-Path $file.DirectoryName $src.Replace('/', [System.IO.Path]::DirectorySeparatorChar)
    if (-not (Test-Path -LiteralPath $asset -PathType Leaf)) { Write-Fail "$rel asset JS ausente: $src" }
  }
  foreach ($m in [regex]::Matches($html, '<img\b[^>]*\bsrc="([^"]+)"')) {
    $src = [System.Net.WebUtility]::HtmlDecode($m.Groups[1].Value)
    if ($src -match '^(https?://|data:)') { continue }
    $asset = Join-Path $file.DirectoryName $src.Replace('/', [System.IO.Path]::DirectorySeparatorChar)
    if (-not (Test-Path -LiteralPath $asset -PathType Leaf)) { Write-Fail "$rel imagem ausente: $src" }
  }

  $submenuToggles = ([regex]::Matches($html, 'class="submenu-toggle"')).Count
  if ($submenuToggles -ne 2) { Write-Fail "$rel esperava 2 submenu-toggle, encontrou $submenuToggles" }
  if ($html -notmatch 'aria-controls="submenu-geotecnologias"') { Write-Fail "$rel sem controle do submenu Geotecnologias" }
  if ($html -notmatch 'aria-controls="submenu-aplicacoes"') { Write-Fail "$rel sem controle do submenu Aplicacoes" }
  if ($html -notmatch '>Geotecnologias<') { Write-Fail "$rel sem item Geotecnologias" }
  if ($html -notmatch '>Aplicações<') { Write-Fail "$rel sem item Aplicações" }
  if ($html -notmatch '>Hidrossedimentologia</a>') { Write-Fail "$rel sem Hidrossedimentologia na navegacao" }
  if ($html -match '>Tecnologias</a>' -or $html -match '>Soluções</a>') { Write-Fail "$rel mantem rotulos antigos de menu" }

  if ($html -notmatch '<a\b[^>]*href="(\.\./)?solucoes\.html"[^>]*>(<span class="nav-label">)?Aplicações<') {
    Write-Fail "$rel menu Aplicações nao aponta para solucoes.html"
  }

  $geoHrefs = ([regex]::Matches($html, 'href="(\.\./)?geotecnologias/[a-z0-9\-]+\.html')).Count
  $solHrefs = ([regex]::Matches($html, 'href="(\.\./)?solucoes/[a-z0-9\-]+\.html')).Count
  if ($geoHrefs -lt 6) { Write-Fail "$rel submenu Geotecnologias com $geoHrefs links (esperado 6)" }
  if ($solHrefs -lt 7) { Write-Fail "$rel submenu Aplicacoes com $solHrefs links (esperado 7)" }

  foreach ($m in [regex]::Matches($html, '<form\b[^>]*\baction="#"')) {
    $script:formWarnings.Add($rel)
    $script:warnings++
  }

  $isSub = $rel.StartsWith('geotecnologias/') -or $rel.StartsWith('solucoes/')
  if ($isSub) {
    $detailCount = ([regex]::Matches($html, '<article class="detail-item')).Count
    if ($detailCount -eq 0) { Write-Fail "$rel sem secoes de detalhamento (detail-item)" }
    if ($html -match 'class="breadcrumb"') { Write-Fail "$rel ainda contem breadcrumb acima do titulo" }
    if ($html -notmatch 'detail-item--media') { Write-Fail "$rel sem apoio visual nas secoes tecnicas" }
    if ($html -notmatch 'class="anchor-list"') { Write-Fail "$rel sem painel de ancoras" }
    if ($html -notmatch 'styles/subpages\.css|\.\./styles/subpages\.css') { Write-Fail "$rel sem subpages.css" }
  }

  if ($rel -eq 'geotecnologias.html' -or $rel -eq 'solucoes.html') {
    if ($html -notmatch 'hub-hero--bg') { Write-Fail "$rel sem hero com fundo visual" }
    if ($html -notmatch 'class="bg-visual') { Write-Fail "$rel sem camada de fundo visual" }
  }

  $bgHeroPages = @('pesquisa-desenvolvimento.html', 'sms.html', 'parceiros.html', 'blog.html', 'contato.html')
  if ($bgHeroPages -contains $rel) {
    if ($html -notmatch 'page-hero--bg') { Write-Fail "$rel sem hero com fundo visual" }
    if ($html -notmatch 'class="bg-visual') { Write-Fail "$rel sem camada de fundo visual" }
  }

  if ($rel -eq 'index.html') {
    if ($html -notmatch 'class="home-hero"') { Write-Fail 'index.html sem hero de abertura fullscreen' }
    if ($html -notmatch 'class="home-hero-media"') { Write-Fail 'index.html sem area visual de fundo do hero' }
    if ($html -notmatch 'class="home-hero-cue"') { Write-Fail 'index.html sem controle CONHECA MAIS' }
    if (([regex]::Matches($html, 'class="home-hero-arrow"')).Count -ne 2) { Write-Fail 'index.html sem duas setas no controle CONHECA MAIS' }
    if ($html -notmatch 'href="#homepage-content"') { Write-Fail 'index.html sem ancora do CONHECA MAIS para o Bloco 2' }
    if ($html -notmatch 'class="home-block2" id="homepage-content"') { Write-Fail 'index.html sem Bloco 2 identificado' }
    if ($html -notmatch 'class="hero-media') { Write-Fail 'index.html sem placeholder preto do Bloco 2' }
    if ($html -notmatch 'class="hero-box"') { Write-Fail 'index.html sem caixa azul do Bloco 2' }
    if ($html -match 'class="hero-scroll"|class="scroll-cue"|class="hero-stage"') { Write-Fail 'index.html ainda usa a estrutura antiga de hero unico' }
    $heroPos = $html.IndexOf('class="home-hero"')
    $block2Pos = $html.IndexOf('id="homepage-content"')
    if ($heroPos -lt 0 -or $block2Pos -lt 0 -or $heroPos -gt $block2Pos) { Write-Fail 'index.html fora da ordem hero -> Bloco 2' }
  }

  $currentCount = ([regex]::Matches($html, 'aria-current="page"')).Count
  if ($currentCount -ne 1) { Write-Fail "$rel com $currentCount marcacoes aria-current=page (esperado 1)" }
  $navLabelCount = ([regex]::Matches($html, 'class="nav-label"')).Count
  if ($navLabelCount -ne 9) { Write-Fail "$rel com $navLabelCount rotulos nav-label (esperado 9)" }
  $navBoldCount = ([regex]::Matches($html, 'class="nav-bold"')).Count
  if ($navBoldCount -ne 9) { Write-Fail "$rel com $navBoldCount reservas nav-bold (esperado 9)" }
  $navDataCount = ([regex]::Matches($html, 'data-label="')).Count
  if ($navDataCount -lt 9) { Write-Fail "$rel sem data-label nos links principais" }

  if ($rel -eq 'geotecnologias.html') {
    if (([regex]::Matches($html, 'hero-line-break')).Count -lt 3) { Write-Fail 'geotecnologias.html sem quebras editoriais no titulo do hero' }
  }
  if ($rel -eq 'solucoes.html') {
    if (([regex]::Matches($html, 'hero-line-break')).Count -lt 2) { Write-Fail 'solucoes.html sem quebras editoriais no titulo do hero' }
  }
  if ($rel -eq 'parceiros.html') {
    if ($html -notmatch 'hero-line-break') { Write-Fail 'parceiros.html sem quebras editoriais no bloco Groundradar' }
  }
}

Write-Host ''
Write-Host '=== FONTE DE CONTEUDO E COBERTURA DA COPY ===' -ForegroundColor Cyan

$copyNorm = ''
$copyPath = Join-Path $Root 'copy/Copys-extraido.txt'
if (-not (Test-Path -LiteralPath $copyPath -PathType Leaf)) {
  Write-Fail 'copy/Copys-extraido.txt ausente'
} else {
  $copyText = Read-Utf8Strict $copyPath
  if ($null -eq $copyText) { Write-Fail 'copy/Copys-extraido.txt nao esta em UTF-8 valido' }
  elseif ($copyText.Contains([char]0xFFFD)) { Write-Fail 'copy/Copys-extraido.txt contem U+FFFD' }
  else {
    $paragraphs = @($copyText -split "`r?`n" | Where-Object { $_.Trim().Length -gt 0 })
    $copyNorm = Normalize-Text $copyText
    Write-Ok "Copy de origem: $($paragraphs.Count) paragrafos nao vazios"
  }
}

$datasets = @(
  @{ Name = 'Geotecnologias'; Json = 'content/geo-data.json'; Hub = 'geotecnologias.html'; Folder = 'geotecnologias' },
  @{ Name = 'Aplicações'; Json = 'content/sol-data.json'; Hub = 'solucoes.html'; Folder = 'solucoes' }
)

foreach ($dataset in $datasets) {
  $jsonPath = Join-Path $Root $dataset.Json
  if (-not (Test-Path -LiteralPath $jsonPath -PathType Leaf)) {
    Write-Fail "JSON ausente: $($dataset.Json)"
    continue
  }

  $raw = Read-Utf8Strict $jsonPath
  if ($null -eq $raw) { Write-Fail "$($dataset.Json) nao esta em UTF-8 valido"; continue }
  $data = $raw | ConvertFrom-Json

  $hubPath = Join-Path $Root $dataset.Hub
  $hubHtml = Read-Utf8Strict $hubPath
  if ($null -eq $hubHtml) { Write-Fail "Hub ausente ou invalido: $($dataset.Hub)"; continue }
  $hubText = Get-MainText $hubHtml

  $hubCopy = [ordered]@{
    hero         = $data.hero
    introBlock   = $data.introBlock
    integration  = $data.integration
    processTitle = $data.processTitle
    process      = $data.process
    cta          = $data.cta
  }
  $hubItems = @()
  foreach ($item in $data.items) {
    $hubItems += [ordered]@{
      title        = $item.title
      headlineHtml = $item.headlineHtml
      intro        = $item.intro
      listTitle    = $item.listTitle
      cta          = $item.cta
    }
  }
  $hubCopy.items = $hubItems
  Assert-Copy -Value $hubCopy -Path "hub:$($dataset.Hub)" -PageText $hubText -RelPage $dataset.Hub

  if ($copyNorm.Length -gt 0) {
    $hubSourceStrings = @()
    $hubSourceStrings += @($data.hero.title) + @($data.hero.paragraphs)
    $hubSourceStrings += @($data.introBlock.title) + @($data.introBlock.highlight) + @($data.introBlock.paragraphs)
    $hubSourceStrings += @($data.integration.title) + @($data.integration.lead) + @($data.integration.paragraphs)
    $hubSourceStrings += @($data.cta.title) + @($data.cta.paragraphs)
    foreach ($step in $data.process) { $hubSourceStrings += @($step.text) }
    Assert-SourceText -Value $hubSourceStrings -Path "source-hub:$($dataset.Hub)" -SourceText $copyNorm -RelPage $dataset.Hub
  }

  foreach ($item in $data.items) {
    $pageRel = "$($dataset.Folder)/$($item.slug)"
    $pagePath = Join-Path $Root $pageRel.Replace('/', [System.IO.Path]::DirectorySeparatorChar)
    if (-not (Test-Path -LiteralPath $pagePath -PathType Leaf)) {
      Write-Fail "Pagina interna ausente: $pageRel"
      continue
    }
    $pageHtml = Read-Utf8Strict $pagePath
    if ($null -eq $pageHtml) { Write-Fail "$pageRel nao esta em UTF-8 valido"; continue }
    $pageText = Get-MainText $pageHtml

    $detailCount = @($item.details).Count
    if ($detailCount -eq 0) { Write-Fail "$pageRel sem detalhamentos no JSON" }

    $pageCopy = [ordered]@{
      title        = $item.title
      lead         = $item.lead
      headlineHtml = $item.headlineHtml
      intro        = $item.intro
      listTitle    = $item.listTitle
      list         = $item.list
      crosslink    = $item.crosslink
      details      = $item.details
      processTitle = $data.processTitle
      process      = $data.process
    }
    Assert-Copy -Value $pageCopy -Path "page:$pageRel" -PageText $pageText -RelPage $pageRel

    if ($copyNorm.Length -gt 0) {
      $pageSourceStrings = @()
      $pageSourceStrings += @($item.lead) + @($item.headlineHtml) + @($item.intro) + @($item.list)
      foreach ($detail in $item.details) { $pageSourceStrings += @($detail.paragraphs) }
      Assert-SourceText -Value $pageSourceStrings -Path "source-page:$pageRel" -SourceText $copyNorm -RelPage $pageRel
    }

    $emptyDetailPlaceholder = $false
    foreach ($detail in $item.details) {
      if (@($detail.paragraphs).Count -eq 0) { $emptyDetailPlaceholder = $true }
    }
    if ($emptyDetailPlaceholder -and $pageText -notmatch 'Descrição técnica em elaboração') {
      Write-Fail "$pageRel possui detalhe sem copy e sem o aviso 'Descrição técnica em elaboração.'"
    }
  }

  Write-Ok "$($dataset.Name): $($data.items.Count) paginas internas auditadas"
}

foreach ($missing in $script:copyMissing) {
  Write-Fail "COPY AUSENTE $missing"
}

foreach ($missing in $script:sourceMissing) {
  Write-Fail "TEXTO FORA DA FONTE $missing"
}

Write-Host ''
Write-Host "Strings de copy verificadas nas paginas: $($script:copyChecks)"
if ($script:copyMissing.Count -eq 0) {
  Write-Ok 'Toda a copy estruturada foi encontrada nas paginas geradas'
}

Write-Host "Trechos tecnicos conferidos contra Copys.docx: $($script:sourceChecks)"
if ($script:sourceMissing.Count -eq 0) {
  Write-Ok 'Todo o texto tecnico auditado existe na fonte original'
}

if ($script:formWarnings.Count -gt 0) {
  $uniqueForms = $script:formWarnings | Sort-Object -Unique
  Write-Warn "Formularios sem backend (action=`"#`") em: $($uniqueForms -join ', ')"
}

$homeCss = Join-Path $Root 'styles/home.css'
if (Test-Path -LiteralPath $homeCss -PathType Leaf) {
  $css = Read-Utf8Strict $homeCss
  if ($css -notmatch '\.home-hero\b') { Write-Fail 'styles/home.css sem hero de abertura' }
  if ($css -notmatch '100svh') { Write-Fail 'styles/home.css sem altura de viewport para o hero' }
  if ($css -notmatch '\.home-block2\b') { Write-Fail 'styles/home.css sem Bloco 2' }
  if ($css -notmatch '#homepage-content') { Write-Fail 'styles/home.css sem offset de ancora do Bloco 2' }
  if ($css -notmatch 'background-size:\s*cover') { Write-Fail 'styles/home.css sem preparacao para midia cover' }
  if ($css -notmatch '\.home-hero-arrow') { Write-Fail 'styles/home.css sem setas do controle CONHECA MAIS' }
  if ($css -match '\.hero-stage\b') { Write-Fail 'styles/home.css ainda estiliza o hero unico antigo' }
  if ($css -notmatch '--nav-active') { Write-Fail 'styles/home.css sem cor de destaque da navegacao' }
  if ($css -notmatch '\.nav-label') { Write-Fail 'styles/home.css sem reserva de largura do menu' }
  if ($css -notmatch 'aria-current') { Write-Fail 'styles/home.css sem estado ativo da navegacao' }
  if ($css -notmatch 'font-weight:\s*400') { Write-Fail 'styles/home.css sem peso regular nos links inativos' }
  Write-Ok 'CSS da home com hero fullscreen independente e Bloco 2 preservado'
}

$subpagesCss = Join-Path $Root 'styles/subpages.css'
if (Test-Path -LiteralPath $subpagesCss -PathType Leaf) {
  $css = Read-Utf8Strict $subpagesCss
  if ($css -notmatch 'scroll-margin-top') { Write-Fail 'styles/subpages.css sem scroll-margin-top' }
  if ($css -match 'line-clamp') { Write-Fail 'styles/subpages.css usa line-clamp (copy pode ser ocultada)' }
  if ($css -notmatch '\.hub-hero--bg') { Write-Fail 'styles/subpages.css sem hero de hub com fundo' }
  if ($css -notmatch 'max-width:\s*620px') { Write-Fail 'styles/subpages.css sem coluna editorial compacta no hero de hub' }
  if ($css -notmatch '\.detail-item--media') { Write-Fail 'styles/subpages.css sem apoio visual nos detalhamentos' }
  if ($css -match '\.breadcrumb') { Write-Fail 'styles/subpages.css ainda estiliza breadcrumb removido' }
  Write-Ok 'CSS de subpaginas com ancoras, fundo de hub e apoio visual'
}

$pagesCss = Join-Path $Root 'styles/pages.css'
if (Test-Path -LiteralPath $pagesCss -PathType Leaf) {
  $css = Read-Utf8Strict $pagesCss
  if ($css -notmatch 'scroll-margin-top') { Write-Fail 'styles/pages.css sem scroll-margin-top para ancoras' }
  if ($css -match 'line-clamp') { Write-Fail 'styles/pages.css usa line-clamp (copy pode ser ocultada)' }
  if ($css -notmatch '\.bg-visual') { Write-Fail 'styles/pages.css sem fundo visual reutilizavel' }
  if ($css -notmatch '\.page-hero--bg') { Write-Fail 'styles/pages.css sem hero com fundo reutilizavel' }
  if ($css -notmatch 'max-width:\s*620px') { Write-Fail 'styles/pages.css sem coluna editorial compacta nos heroes' }
  if ($css -notmatch '\.feature-band--left') { Write-Fail 'styles/pages.css sem coluna compacta para blocos com fundo' }
  if ($css -notmatch '\.hero-line-break') { Write-Fail 'styles/pages.css sem controle de quebras desktop' }
  Write-Ok 'CSS de paginas internas com offset, fundo visual e hero sobreposto'
}

$mainJs = Join-Path $Root 'scripts/main.js'
if (Test-Path -LiteralPath $mainJs -PathType Leaf) {
  $js = Read-Utf8Strict $mainJs
  foreach ($needle in @('submenu-toggle', 'Escape', 'aria-expanded', 'focusout')) {
    if ($js -notmatch [regex]::Escape($needle)) { Write-Fail "scripts/main.js sem comportamento: $needle" }
  }
  Write-Ok 'JS de submenu com teclado, Escape e foco'
}

if ($BaseUrl) {
  Write-Host ''
  Write-Host '=== TESTE HTTP ===' -ForegroundColor Cyan
  $base = $BaseUrl.TrimEnd('/') + '/'
  foreach ($file in $files) {
    $rel = $file.FullName.Substring($Root.Length).TrimStart('\').Replace('\', '/')
    try {
      $response = Invoke-WebRequest -Uri ($base + $rel) -UseBasicParsing -TimeoutSec 15
      if ($response.StatusCode -ne 200) { Write-Fail "HTTP $($response.StatusCode): $rel" }
    } catch {
      Write-Fail "HTTP falhou: $rel"
    }
  }
  Write-Ok "HTTP testado para $($files.Count) paginas"
}

Write-Host ''
Write-Host "TOTAL DE PAGINAS: $($files.Count)"
Write-Host "PROBLEMAS: $($script:problems)"
Write-Host "AVISOS: $($script:warnings)"

if ($script:problems -gt 0) { exit 1 }
Write-Host 'AUDITORIA CONCLUIDA SEM PROBLEMAS' -ForegroundColor Green
