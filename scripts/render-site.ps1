# =====================================================================
# NEOGEO - renderizador do site
# Gera as páginas hubs (/geotecnologias.html, /solucoes.html) e as 13
# páginas internas a partir de content/geo-data.json e content/sol-data.json.
# O texto técnico vem integralmente de copy/Copys-extraido.txt.
# =====================================================================
param(
  [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
)

$ErrorActionPreference = 'Stop'
$utf8 = New-Object System.Text.UTF8Encoding($false)

$geo = Get-Content (Join-Path $Root 'content/geo-data.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$sol = Get-Content (Join-Path $Root 'content/sol-data.json') -Raw -Encoding UTF8 | ConvertFrom-Json

# ---------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------
function E {
  param([string]$Text)
  if ($null -eq $Text) { return '' }
  return $Text.Replace('&', '&amp;').Replace('<', '&lt;').Replace('>', '&gt;')
}

function EA {
  param([string]$Text)
  return (E $Text).Replace('"', '&quot;')
}

function P {
  param([string]$Text)
  return '<p>' + (E $Text) + '</p>'
}

function ParaBlock {
  param($Paragraphs)
  if ($null -eq $Paragraphs) { return '' }
  $out = @()
  foreach ($p in $Paragraphs) { $out += (P $p) }
  return ($out -join "`n")
}

# Insere quebras de linha desktop sem alterar o texto da copy.
function BreakLines {
  param([string]$Text, [string[]]$After)
  foreach ($needle in $After) {
    $idx = $Text.IndexOf($needle, [System.StringComparison]::Ordinal)
    if ($idx -ge 0) {
      $end = $idx + $needle.Length
      $Text = $Text.Substring(0, $end) + '<br class="hero-line-break">' + $Text.Substring($end)
    }
  }
  return $Text
}

function Normalize {
  param([string]$Text)
  $s = $Text.ToLowerInvariant()
  $s = $s -replace '[áàâãä]', 'a' -replace '[éèêë]', 'e' -replace '[íìîï]', 'i' -replace '[óòôõö]', 'o' -replace '[úùûü]', 'u' -replace 'ç', 'c'
  $s = $s -replace '[^a-z0-9]+', '-'
  return $s.Trim('-')
}

function DetailIdFor {
  param([string]$ListItem, $Details, [string]$Slug)
  $n = Normalize $ListItem
  foreach ($d in $Details) {
    if ((Normalize $d.title) -eq $n) { return $d.id }
  }
  foreach ($d in $Details) {
    $dn = Normalize $d.title
    if ($dn.StartsWith($n) -or $n.StartsWith($dn)) { return $d.id }
  }
  if ($Slug -like 'radar-*') {
    if ($n -like 'gpr*') { return 'gpr' }
    if ($n -like 'ultra*') { return 'ultragpr' }
  }
  if ($Slug -eq 'arqueologia.html') { return 'metodos-geofisicos' }
  if ($Details.Count -gt 0) { return $Details[0].id }
  return (Normalize $ListItem)
}

# ---------------------------------------------------------------------
# Header / footer compartilhados
# ---------------------------------------------------------------------
$geoTechLinks = @(
  @{ slug = 'metodos-eletricos-e-eletromagneticos.html'; label = 'Métodos elétricos e eletromagnéticos' },
  @{ slug = 'metodos-sismicos.html'; label = 'Métodos sísmicos' },
  @{ slug = 'metodos-potenciais.html'; label = 'Métodos potenciais' },
  @{ slug = 'radar-e-investigacao-de-alta-resolucao.html'; label = 'Radar e investigação de alta resolução' },
  @{ slug = 'levantamentos-aereos-com-drones.html'; label = 'Levantamentos aéreos com drones' },
  @{ slug = 'perfilagem-geofisica.html'; label = 'Perfilagem geofísica' }
)

$solLinks = @(
  @{ slug = 'geotecnia.html'; label = 'Geotecnia' },
  @{ slug = 'exploracao-mineral.html'; label = 'Exploração Mineral' },
  @{ slug = 'engenharia.html'; label = 'Engenharia' },
  @{ slug = 'hidrogeologia.html'; label = 'Hidrogeologia' },
  @{ slug = 'arqueologia.html'; label = 'Arqueologia' },
  @{ slug = 'hidrossedimentologia.html'; label = 'Hidrossedimentologia' },
  @{ slug = 'monitoramento.html'; label = 'Monitoramento' }
)

function Get-Submenu {
  param(
    [string]$Id,
    [string]$Label,
    $Links,
    [string]$Folder,
    [string]$Prefix,
    [string]$SubPage
  )
  $out = @()
  $out += '<ul class="submenu" id="' + $Id + '" aria-label="' + (EA $Label) + '">'
  foreach ($l in $Links) {
    $current = ''
    if ($SubPage -eq $l.slug) { $current = ' aria-current="page"' }
    $out += '  <li><a href="' + $Prefix + $Folder + '/' + $l.slug + '"' + $current + '>' + (E $l.label) + '</a></li>'
  }
  $out += '</ul>'
  return ($out -join "`n")
}

function Get-Header {
  param(
    [string]$Prefix = '',
    [string]$Current = '',
    [string]$SubPage = ''
  )

  $geoCurrent = ''
  if ($Current -eq 'geo' -and $SubPage -eq '') { $geoCurrent = ' aria-current="page"' }
  elseif ($Current -eq 'geo') { $geoCurrent = ' aria-current="true"' }

  $solCurrent = ''
  if ($Current -eq 'sol' -and $SubPage -eq '') { $solCurrent = ' aria-current="page"' }
  elseif ($Current -eq 'sol') { $solCurrent = ' aria-current="true"' }

  $plain = @(
    @{ key = 'index'; label = 'Início'; href = 'index.html' },
    @{ key = 'empresa'; label = 'A Empresa'; href = 'a-empresa.html' }
  )

  $items = @()
  foreach ($p in $plain) {
    $c = ''
    if ($Current -eq $p.key) { $c = ' aria-current="page"' }
    $items += '  <li><a href="' + $Prefix + $p.href + '" data-label="' + (EA $p.label) + '"' + $c + '><span class="nav-label">' + (E $p.label) + '</span><span class="nav-bold" aria-hidden="true">' + (E $p.label) + '</span></a></li>'
  }

  $items += @'
  <li class="nav-item nav-item--has-sub">
    <a href="__GEO_HUB__" data-label="Geotecnologias"__GEO_CURRENT__><span class="nav-label">Geotecnologias</span><span class="nav-bold" aria-hidden="true">Geotecnologias</span></a>
    <button class="submenu-toggle" type="button" aria-expanded="false" aria-controls="submenu-geotecnologias" aria-label="Abrir submenu de Geotecnologias" data-label-open="Abrir submenu de Geotecnologias" data-label-close="Fechar submenu de Geotecnologias"><span class="submenu-caret" aria-hidden="true"></span></button>
    __GEO_SUBMENU__
  </li>
'@.Replace('__GEO_HUB__', $Prefix + 'geotecnologias.html').Replace('__GEO_CURRENT__', $geoCurrent).Replace('__GEO_SUBMENU__', (Get-Submenu -Id 'submenu-geotecnologias' -Label 'Geotecnologias' -Links $geoTechLinks -Folder 'geotecnologias' -Prefix $Prefix -SubPage $SubPage))

  $items += @'
  <li class="nav-item nav-item--has-sub">
    <a href="__SOL_HUB__" data-label="Aplicações"__SOL_CURRENT__><span class="nav-label">Aplicações</span><span class="nav-bold" aria-hidden="true">Aplicações</span></a>
    <button class="submenu-toggle" type="button" aria-expanded="false" aria-controls="submenu-aplicacoes" aria-label="Abrir submenu de Aplicações" data-label-open="Abrir submenu de Aplicações" data-label-close="Fechar submenu de Aplicações"><span class="submenu-caret" aria-hidden="true"></span></button>
    __SOL_SUBMENU__
  </li>
'@.Replace('__SOL_HUB__', $Prefix + 'solucoes.html').Replace('__SOL_CURRENT__', $solCurrent).Replace('__SOL_SUBMENU__', (Get-Submenu -Id 'submenu-aplicacoes' -Label 'Aplicações' -Links $solLinks -Folder 'solucoes' -Prefix $Prefix -SubPage $SubPage))

  $rest = @(
    @{ key = 'pd'; label = 'P&D'; href = 'pesquisa-desenvolvimento.html' },
    @{ key = 'sms'; label = 'SMS'; href = 'sms.html' },
    @{ key = 'parceiros'; label = 'Parceiros'; href = 'parceiros.html' },
    @{ key = 'blog'; label = 'Blog'; href = 'blog.html' },
    @{ key = 'contato'; label = 'Contato'; href = 'contato.html' }
  )
  foreach ($p in $rest) {
    $c = ''
    if ($Current -eq $p.key) { $c = ' aria-current="page"' }
    $items += '  <li><a href="' + $Prefix + $p.href + '" data-label="' + (EA $p.label) + '"' + $c + '><span class="nav-label">' + (E $p.label) + '</span><span class="nav-bold" aria-hidden="true">' + (E $p.label) + '</span></a></li>'
  }

  return @'
    <div class="container header-inner">
      <a class="brand" href="__HOME__" aria-label="Neogeo Geotecnologia - Início">
        <img src="__PREFIX__assets/images/Logotipo_Neogeo_Positivo.png" alt="Neogeo Geotecnologia">
      </a>
      <button class="menu-toggle" type="button" aria-expanded="false" aria-controls="site-nav" aria-label="Abrir menu">
        <span></span><span></span><span></span>
      </button>
      <nav class="site-nav" id="site-nav" aria-label="Navegação principal">
        <ul class="nav-list">
__ITEMS__
        </ul>
      </nav>
    </div>
'@.Replace('__HOME__', $Prefix + 'index.html').Replace('__PREFIX__', $Prefix).Replace('__ITEMS__', ($items -join "`n"))
}

function Get-Footer {
  param([string]$Prefix = '')
  return @'
  <footer class="site-footer">
    <div class="container footer-grid">
      <div class="footer-brand-card">
        <img src="__PREFIX__assets/images/Logotipo_Neogeo_Positivo.png" alt="Neogeo Geotecnologia">
      </div>
      <div class="footer-mid">
        <div class="footer-address">
          <p>Av. Prudente de Morais, 287, Salas 1601-1605</p>
          <p>Santo Antônio, Belo Horizonte - MG</p>
          <p>CEP: 30.350-093</p>
        </div>
        <div class="footer-actions">
          <a class="footer-btn" href="__PREFIX__contato.html">Fale conosco</a>
          <a class="footer-btn" href="__PREFIX__contato.html#ouvidoria">Ouvidoria</a>
        </div>
      </div>
      <div class="footer-contact">
        <div class="footer-line">
          <span class="footer-icon" aria-hidden="true"></span>
          <a href="tel:+553132962958">(31) 3296-2958</a>
        </div>
        <div class="footer-line">
          <span class="footer-icon" aria-hidden="true"></span>
          <a href="mailto:contato@ngg.com.br">contato@ngg.com.br</a>
        </div>
        <div class="footer-socials" aria-label="Redes sociais">
          <span></span><span></span><span></span><span></span>
        </div>
      </div>
    </div>
    <div class="container footer-bottom">
      <p>Copyright © 2026. Neogeo Geotecnologia LTDA. Serviços de Geofísica e Geologia. Todos os direitos reservados.<br>Desenvolvido por Mining Marketing.</p>
    </div>
  </footer>
'@.Replace('__PREFIX__', $Prefix)
}

function New-Page {
  param(
    [string]$Title,
    [string]$Description,
    [string]$BodyClass,
    [string]$Prefix,
    [string]$Current,
    [string]$SubPage,
    [string]$Content,
    [string]$ExtraCss = ''
  )
  $css = @"
<link rel="stylesheet" href="${Prefix}styles/global.css">
<link rel="stylesheet" href="${Prefix}styles/home.css">
<link rel="stylesheet" href="${Prefix}styles/pages.css">
<link rel="stylesheet" href="${Prefix}styles/subpages.css">
"@
  if ($ExtraCss) { $css += '<link rel="stylesheet" href="' + $Prefix + 'styles/' + $ExtraCss + '">' }

  return @'
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="__DESC__">
  <meta name="robots" content="index,follow">
  <meta name="theme-color" content="#13355E">
  <meta property="og:type" content="website">
  <meta property="og:locale" content="pt_BR">
  <meta property="og:title" content="__TITLE__">
  <meta property="og:description" content="__DESC__">
  <title>__TITLE__</title>
__CSS__
</head>
<body class="__BODY__">
  <header class="site-header" id="topo">
__HEADER__
  </header>

  <main>
__CONTENT__
  </main>

__FOOTER__
  <script src="__PREFIX__scripts/main.js"></script>
</body>
</html>
'@.Replace('__DESC__', (EA $Description)).Replace('__TITLE__', (EA $Title)).Replace('__CSS__', ($css -join "`n")).Replace('__BODY__', $BodyClass).Replace('__HEADER__', (Get-Header -Prefix $Prefix -Current $Current -SubPage $SubPage)).Replace('__CONTENT__', $Content).Replace('__FOOTER__', (Get-Footer -Prefix $Prefix)).Replace('__PREFIX__', $Prefix)
}

function Placeholder {
  param([string]$Class = '')
  return '<div class="media-placeholder ' + $Class + '" aria-hidden="true"><span></span><span></span><span></span></div>'
}

# ---------------------------------------------------------------------
# Hub de Geotecnologias
# ---------------------------------------------------------------------
function Render-GeoHub {
  $out = @()

  $heroParas = ParaBlock $geo.hero.paragraphs
  $geoHeroTitle = BreakLines (E $geo.hero.title) @('Diferentes métodos', 'para investigar', 'o que não está')
  $out += @'
    <section class="hub-hero hub-hero--bg" aria-labelledby="page-title">
      <div class="bg-visual" aria-hidden="true"><span></span><span></span><span></span></div>
      <div class="container hub-hero-grid">
        <div class="hub-hero-copy">
          <p class="hub-kicker">Geotecnologias</p>
          <h1 id="page-title">__TITLE__</h1>
__PARAS__
          <div class="hub-actions"><a class="btn" href="contato.html">Quero falar sobre meu projeto</a></div>
        </div>
      </div>
    </section>
'@.Replace('__TITLE__', $geoHeroTitle).Replace('__PARAS__', $heroParas)

  $highlight = ''
  if ($geo.introBlock.highlight) { $highlight = '<br><span>' + (E $geo.introBlock.highlight) + '</span>' }
  $out += @'
    <section class="hub-intro" aria-labelledby="intro-title">
      <div class="container hub-intro-grid">
        <div class="hub-intro-copy">
          <p class="hub-kicker">__KICKER__</p>
          <h2 id="intro-title">__TITLE____HIGHLIGHT__</h2>
__PARAS__
        </div>
        __MEDIA__
      </div>
    </section>
'@.Replace('__KICKER__', (E $geo.introBlock.kicker)).Replace('__TITLE__', (E $geo.introBlock.title)).Replace('__HIGHLIGHT__', $highlight).Replace('__PARAS__', (ParaBlock $geo.introBlock.paragraphs)).Replace('__MEDIA__', (Placeholder 'hub-intro-media'))

  $i = 0
  foreach ($item in $geo.items) {
    $i++
    $idx = '{0:D2}' -f $i
    $chips = @('<ul class="hub-chips">')
    foreach ($li in $item.list) {
      $href = $item.slug + '#' + (DetailIdFor -ListItem $li -Details $item.details -Slug $item.slug)
      if ($item.listLinks -and $item.listLinks.PSObject.Properties.Name -contains $li) {
        $href = [string]$item.listLinks.$li
      }
      $chips += '  <li><a href="geotecnologias/' + $href + '">' + (E $li) + '</a></li>'
    }
    $chips += '</ul>'
    $out += @'
    <section class="hub-block" aria-labelledby="block-__ID__">
      <div class="container hub-block-grid">
        <div class="hub-block-copy">
          <span class="hub-index">__INDEX__</span>
          <p class="hub-kicker">__KICKER__</p>
          <h2 id="block-__ID__">__HEADLINE__</h2>
__PARAS__
        </div>
        <div class="hub-block-side">
          <h3>__LISTTITLE__</h3>
__CHIPS__
          <div class="hub-actions"><a class="btn" href="geotecnologias/__SLUG__">__CTA__</a></div>
        </div>
      </div>
    </section>
'@.Replace('__ID__', $item.slug.Replace('.html', '')).Replace('__INDEX__', $idx).Replace('__KICKER__', (E $item.title)).Replace('__HEADLINE__', $item.headlineHtml).Replace('__PARAS__', (ParaBlock $item.intro)).Replace('__LISTTITLE__', (E $item.listTitle)).Replace('__CHIPS__', ($chips -join "`n")).Replace('__SLUG__', $item.slug).Replace('__CTA__', (E $item.cta))
  }

  $out += @'
    <section class="hub-integration" aria-labelledby="integration-title">
      <div class="container hub-integration-grid">
        <div class="hub-integration-copy">
          <p class="hub-kicker">__KICKER__</p>
          <h2 id="integration-title">__TITLE__</h2>
          <p class="hub-lead">__LEAD__</p>
__PARAS__
        </div>
        __MEDIA__
      </div>
    </section>
'@.Replace('__KICKER__', (E $geo.integration.kicker)).Replace('__TITLE__', (E $geo.integration.title)).Replace('__LEAD__', (E $geo.integration.lead)).Replace('__PARAS__', (ParaBlock $geo.integration.paragraphs)).Replace('__MEDIA__', (Placeholder 'hub-integration-media'))

  $steps = @('<div class="step-list step-list--five">')
  $n = 0
  foreach ($step in $geo.process) {
    $n++
    $steps += '  <div class="step-item"><span class="step-num">' + ('{0:D2}' -f $n) + '</span><div><h3>' + (E $step.title) + '</h3><p>' + (E $step.text) + '</p></div></div>'
  }
  $steps += '</div>'
  $out += @'
    <section class="hub-process" aria-labelledby="process-title">
      <div class="container">
        <div class="section-head">
          <p class="hub-kicker">Como conduzimos</p>
          <h2 class="section-title" id="process-title">__TITLE__</h2>
        </div>
__STEPS__
      </div>
    </section>
'@.Replace('__TITLE__', (E $geo.processTitle)).Replace('__STEPS__', ($steps -join "`n"))

  $out += @'
    <section class="hub-cta" aria-labelledby="cta-title">
      <div class="container hub-cta-grid">
        <div>
          <h2 id="cta-title">__TITLE__</h2>
__PARAS__
          <div class="hub-actions"><a class="btn" href="contato.html">__LABEL__</a></div>
        </div>
        __MEDIA__
      </div>
    </section>
'@.Replace('__TITLE__', (E $geo.cta.title)).Replace('__PARAS__', (ParaBlock $geo.cta.paragraphs)).Replace('__LABEL__', (E $geo.cta.label)).Replace('__MEDIA__', (Placeholder 'hub-cta-media'))

  $desc = ($geo.hero.paragraphs -join ' ')
  $page = New-Page -Title 'Geotecnologias | Neogeo Geotecnologia' -Description $desc -BodyClass 'hub-page geo-page' -Prefix '' -Current 'geo' -SubPage '' -Content ($out -join "`n")
  [System.IO.File]::WriteAllText((Join-Path $Root 'geotecnologias.html'), $page, $utf8)
}

# ---------------------------------------------------------------------
# Hub de Aplicações
# ---------------------------------------------------------------------
function Render-SolHub {
  $out = @()

  $solHeroTitle = BreakLines (E $sol.hero.title) @('Geofísica aplicada', 'aos desafios')
  $out += @'
    <section class="hub-hero hub-hero--bg" aria-labelledby="page-title">
      <div class="bg-visual" aria-hidden="true"><span></span><span></span><span></span></div>
      <div class="container hub-hero-grid">
        <div class="hub-hero-copy">
          <p class="hub-kicker">Aplicações</p>
          <h1 id="page-title">__TITLE__</h1>
__PARAS__
          <div class="hub-actions"><a class="btn" href="contato.html">Quero falar sobre meu projeto</a></div>
        </div>
      </div>
    </section>
'@.Replace('__TITLE__', $solHeroTitle).Replace('__PARAS__', (ParaBlock $sol.hero.paragraphs))

  $highlight = ''
  if ($sol.introBlock.highlight) { $highlight = '<br><span>' + (E $sol.introBlock.highlight) + '</span>' }
  $out += @'
    <section class="hub-intro" aria-labelledby="intro-title">
      <div class="container hub-intro-grid">
        <div class="hub-intro-copy">
          <p class="hub-kicker">__KICKER__</p>
          <h2 id="intro-title">__TITLE____HIGHLIGHT__</h2>
__PARAS__
        </div>
        __MEDIA__
      </div>
    </section>
'@.Replace('__KICKER__', (E $sol.introBlock.kicker)).Replace('__TITLE__', (E $sol.introBlock.title)).Replace('__HIGHLIGHT__', $highlight).Replace('__PARAS__', (ParaBlock $sol.introBlock.paragraphs)).Replace('__MEDIA__', (Placeholder 'hub-intro-media'))

  $i = 0
  foreach ($item in $sol.items) {
    $i++
    $idx = '{0:D2}' -f $i
    $chips = @('<ul class="hub-chips">')
    foreach ($li in $item.list) {
      $href = $item.slug + '#' + (DetailIdFor -ListItem $li -Details $item.details -Slug $item.slug)
      if ($item.listLinks -and $item.listLinks.PSObject.Properties.Name -contains $li) {
        $href = [string]$item.listLinks.$li
      }
      $chips += '  <li><a href="solucoes/' + $href + '">' + (E $li) + '</a></li>'
    }
    $chips += '</ul>'
    $out += @'
    <section class="hub-block" aria-labelledby="block-__ID__">
      <div class="container hub-block-grid">
        <div class="hub-block-copy">
          <span class="hub-index">__INDEX__</span>
          <p class="hub-kicker">__KICKER__</p>
          <h2 id="block-__ID__">__HEADLINE__</h2>
__PARAS__
        </div>
        <div class="hub-block-side">
          <h3>__LISTTITLE__</h3>
__CHIPS__
          <div class="hub-actions"><a class="btn" href="solucoes/__SLUG__">__CTA__</a></div>
        </div>
      </div>
    </section>
'@.Replace('__ID__', $item.slug.Replace('.html', '')).Replace('__INDEX__', $idx).Replace('__KICKER__', (E $item.title)).Replace('__HEADLINE__', $item.headlineHtml).Replace('__PARAS__', (ParaBlock $item.intro)).Replace('__LISTTITLE__', (E $item.listTitle)).Replace('__CHIPS__', ($chips -join "`n")).Replace('__SLUG__', $item.slug).Replace('__CTA__', (E $item.cta))
  }

  $out += @'
    <section class="hub-integration" aria-labelledby="integration-title">
      <div class="container hub-integration-grid">
        <div class="hub-integration-copy">
          <p class="hub-kicker">__KICKER__</p>
          <h2 id="integration-title">__TITLE__</h2>
          <p class="hub-lead">__LEAD__</p>
__PARAS__
        </div>
        __MEDIA__
      </div>
    </section>
'@.Replace('__KICKER__', (E $sol.integration.kicker)).Replace('__TITLE__', (E $sol.integration.title)).Replace('__LEAD__', (E $sol.integration.lead)).Replace('__PARAS__', (ParaBlock $sol.integration.paragraphs)).Replace('__MEDIA__', (Placeholder 'hub-integration-media'))

  $steps = @('<div class="step-list step-list--five">')
  $n = 0
  foreach ($step in $sol.process) {
    $n++
    $steps += '  <div class="step-item"><span class="step-num">' + ('{0:D2}' -f $n) + '</span><div><h3>' + (E $step.title) + '</h3><p>' + (E $step.text) + '</p></div></div>'
  }
  $steps += '</div>'
  $out += @'
    <section class="hub-process" aria-labelledby="process-title">
      <div class="container">
        <div class="section-head">
          <p class="hub-kicker">Como conduzimos</p>
          <h2 class="section-title" id="process-title">__TITLE__</h2>
        </div>
__STEPS__
      </div>
    </section>
'@.Replace('__TITLE__', (E $sol.processTitle)).Replace('__STEPS__', ($steps -join "`n"))

  $out += @'
    <section class="hub-cta" aria-labelledby="cta-title">
      <div class="container hub-cta-grid">
        <div>
          <h2 id="cta-title">__TITLE__</h2>
__PARAS__
          <div class="hub-actions"><a class="btn" href="contato.html">__LABEL__</a></div>
        </div>
        __MEDIA__
      </div>
    </section>
'@.Replace('__TITLE__', (E $sol.cta.title)).Replace('__PARAS__', (ParaBlock $sol.cta.paragraphs)).Replace('__LABEL__', (E $sol.cta.label)).Replace('__MEDIA__', (Placeholder 'hub-cta-media'))

  $desc = ($sol.hero.paragraphs -join ' ')
  $page = New-Page -Title 'Aplicações | Neogeo Geotecnologia' -Description $desc -BodyClass 'hub-page sol-page' -Prefix '' -Current 'sol' -SubPage '' -Content ($out -join "`n")
  [System.IO.File]::WriteAllText((Join-Path $Root 'solucoes.html'), $page, $utf8)
}

# ---------------------------------------------------------------------
# Páginas internas
# ---------------------------------------------------------------------
function Render-SubPage {
  param($Hub, $Item)

  $out = @()

  $scope = @()
  $scope += '<aside class="scope-panel" aria-labelledby="scope-title">'
  $scope += '  <h2 class="scope-title" id="scope-title">Nesta página</h2>'
  $scope += '  <ul class="anchor-list">'
  foreach ($d in $Item.details) {
    $scope += '    <li><a href="#' + $d.id + '">' + (E $d.title) + '</a></li>'
  }
  $scope += '  </ul>'
  $scope += '</aside>'

  $out += @'
    <section class="sub-hero" aria-labelledby="page-title">
      <div class="container sub-hero-grid">
        <div class="sub-hero-copy">
          <p class="hub-kicker">__KICKER__</p>
          <h1 id="page-title">__TITLE__</h1>
          <p class="sub-lead">__LEAD__</p>
          <div class="hub-actions"><a class="btn" href="__PREFIX__contato.html">Quero falar sobre meu projeto</a></div>
        </div>
        __MEDIA__
      </div>
    </section>

    <section class="sub-overview" aria-labelledby="overview-title">
      <div class="container sub-overview-grid">
        <div class="sub-overview-copy">
          <p class="hub-kicker">Visão geral</p>
          <h2 id="overview-title">__INTROTITLE__</h2>
__PARAS__
        </div>
__SCOPE__
      </div>
    </section>
'@.Replace('__HUB__', $Hub.hub).Replace('__HUBLABEL__', (E $Hub.hubLabel)).Replace('__TITLE__', (E $Item.title)).Replace('__KICKER__', (E $Hub.kicker)).Replace('__LEAD__', (E $Item.lead)).Replace('__PREFIX__', '../').Replace('__MEDIA__', (Placeholder 'sub-hero-media')).Replace('__INTROTITLE__', (E $Item.introTitle)).Replace('__PARAS__', (ParaBlock $Item.intro)).Replace('__SCOPE__', ($scope -join "`n"))

  $details = @()
  $n = 0
  foreach ($d in $Item.details) {
    $n++
    $body = ParaBlock $d.paragraphs
    if (-not $body) {
      $body = '<p class="detail-note">Descrição técnica em elaboração.</p>'
    }
    $media = ''
    $itemClass = 'detail-item'
    $bodyLength = (@($d.paragraphs) -join ' ').Length
    if ($n -eq 1 -or (($n % 2 -eq 1) -and $bodyLength -ge 600)) {
      $itemClass = 'detail-item detail-item--media'
      $media = (Placeholder 'detail-media')
    }
    $details += @'
      <article class="__CLASS__" id="__ID__">
        <span class="detail-index">__INDEX__</span>
        <div class="detail-body">
          <h3>__TITLE__</h3>
__BODY__
        </div>__MEDIA__
      </article>
'@.Replace('__CLASS__', $itemClass).Replace('__ID__', $d.id).Replace('__INDEX__', ('{0:D2}' -f $n)).Replace('__TITLE__', (E $d.title)).Replace('__BODY__', $body).Replace('__MEDIA__', $(if ($media) { "`n        " + $media } else { '' }))
  }

  $out += @'
    <section class="sub-details" aria-labelledby="details-title">
      <div class="container">
        <div class="sub-details-head">
          <p class="hub-kicker">Detalhamento técnico</p>
          <h2 class="section-title" id="details-title">__LISTTITLE__</h2>
        </div>
        <div class="detail-list detail-list--editorial">
__DETAILS__
        </div>
      </div>
    </section>
'@.Replace('__LISTTITLE__', (E $Item.listTitle)).Replace('__DETAILS__', ($details -join "`n"))

  if ($Item.crosslink) {
    $out += @'
    <section class="sub-crosslink" aria-labelledby="crosslink-title">
      <div class="container">
        <div class="crosslink-card">
          <p class="hub-kicker">Conteúdo relacionado</p>
          <h2 id="crosslink-title">__TITLE__</h2>
          <p>__TEXT__</p>
          <div class="hub-actions"><a class="btn btn--light" href="__HREF__">__LABEL__</a></div>
        </div>
      </div>
    </section>
'@.Replace('__TITLE__', (E $Item.crosslink.title)).Replace('__TEXT__', (E $Item.crosslink.text)).Replace('__HREF__', $Item.crosslink.href).Replace('__LABEL__', (E $Item.crosslink.label))
  }

  $steps = @('<div class="step-list step-list--five">')
  $n = 0
  foreach ($step in $Hub.process) {
    $n++
    $steps += '  <div class="step-item"><span class="step-num">' + ('{0:D2}' -f $n) + '</span><div><h3>' + (E $step.title) + '</h3><p>' + (E $step.text) + '</p></div></div>'
  }
  $steps += '</div>'
  $out += @'
    <section class="sub-process" aria-labelledby="process-title">
      <div class="container">
        <div class="section-head">
          <p class="hub-kicker">Como conduzimos</p>
          <h2 class="section-title" id="process-title">__TITLE__</h2>
        </div>
__STEPS__
      </div>
    </section>
'@.Replace('__TITLE__', (E $Hub.processTitle)).Replace('__STEPS__', ($steps -join "`n"))

  $related = @()
  foreach ($other in $Hub.items) {
    if ($other.slug -eq $Item.slug) { continue }
    $related += '  <article class="info-card"><h3><a href="' + $other.slug + '">' + (E $other.title) + '</a></h3><p>' + (E $other.lead) + '</p></article>'
  }
  $relatedLabel = 'Outras geotecnologias'
  if ($Hub.folder -eq 'solucoes') { $relatedLabel = 'Outras aplicações' }
  $out += @'
    <section class="sub-related" aria-labelledby="related-title">
      <div class="container">
        <div class="section-head">
          <p class="hub-kicker">Continue explorando</p>
          <h2 class="section-title" id="related-title">__LABEL__</h2>
        </div>
        <div class="cards cards--3">
__CARDS__
        </div>
      </div>
    </section>
'@.Replace('__LABEL__', $relatedLabel).Replace('__CARDS__', ($related -join "`n"))

  $out += @'
    <section class="sub-cta" aria-labelledby="cta-title">
      <div class="container sub-cta-grid">
        <div>
          <h2 id="cta-title">__TITLE__</h2>
__PARAS__
          <div class="hub-actions"><a class="btn" href="../contato.html">__LABEL__</a></div>
        </div>
        __MEDIA__
      </div>
    </section>
'@.Replace('__TITLE__', (E $Hub.cta.title)).Replace('__PARAS__', (ParaBlock $Hub.cta.paragraphs)).Replace('__LABEL__', (E $Hub.cta.label)).Replace('__MEDIA__', (Placeholder 'sub-cta-media'))

  $title = $Item.title + ' | ' + $Hub.hubLabel + ' | Neogeo Geotecnologia'
  $page = New-Page -Title $title -Description $Item.lead -BodyClass 'subpage' -Prefix '../' -Current $(if ($Hub.folder -eq 'geotecnologias') { 'geo' } else { 'sol' }) -SubPage $Item.slug -Content ($out -join "`n")
  $path = Join-Path (Join-Path $Root $Hub.folder) $Item.slug
  [System.IO.File]::WriteAllText($path, $page, $utf8)
}

# ---------------------------------------------------------------------
# Render + patch do header nas páginas já aprovadas
# ---------------------------------------------------------------------
Render-GeoHub
Render-SolHub

foreach ($item in $geo.items) { Render-SubPage -Hub $geo -Item $item }
foreach ($item in $sol.items) { Render-SubPage -Hub $sol -Item $item }

$rootPages = @(
  @{ file = 'index.html'; current = 'index' },
  @{ file = 'a-empresa.html'; current = 'empresa' },
  @{ file = 'pesquisa-desenvolvimento.html'; current = 'pd' },
  @{ file = 'sms.html'; current = 'sms' },
  @{ file = 'parceiros.html'; current = 'parceiros' },
  @{ file = 'blog.html'; current = 'blog' },
  @{ file = 'contato.html'; current = 'contato' }
)

foreach ($p in $rootPages) {
  $path = Join-Path $Root $p.file
  if (-not (Test-Path $path)) { continue }
  $text = [System.IO.File]::ReadAllText($path, $utf8)
  $header = Get-Header -Prefix '' -Current $p.current
  $pattern = '(?s)<div class="container header-inner">.*?</div>\s*</header>'
  $replacement = $header + "`n  </header>"
  $updated = [System.Text.RegularExpressions.Regex]::Replace($text, $pattern, $replacement, 1)
  if ($updated -eq $text) { Write-Warning "Header não atualizado: $($p.file)" }
  [System.IO.File]::WriteAllText($path, $updated, $utf8)
}

Write-Host "Hubs: geotecnologias.html, solucoes.html"
Write-Host "Páginas internas: $($geo.items.Count + $sol.items.Count)"
Write-Host "Headers atualizados em $($rootPages.Count) páginas raiz"
