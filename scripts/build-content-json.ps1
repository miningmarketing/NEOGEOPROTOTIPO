# =====================================================================
# NEOGEO - construtor da fonte de conteudo estruturada
# Le a extracao integral do Word (copy/Copys-extraido.txt) e gera
# content/geo-data.json e content/sol-data.json.
# Nenhum texto tecnico e reescrito: os paragrafos sao lidos por linha.
# =====================================================================
param(
  [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
)

$ErrorActionPreference = 'Stop'
$utf8 = New-Object System.Text.UTF8Encoding($false)
$copyPath = Join-Path $Root 'copy/Copys-extraido.txt'
$lines = [System.IO.File]::ReadAllLines($copyPath, $utf8)

function Get-Para {
  param([int[]]$Numbers)
  $result = New-Object System.Collections.Generic.List[string]
  foreach ($n in $Numbers) {
    $text = $lines[$n - 1].Trim()
    $text = [System.Net.WebUtility]::HtmlDecode($text)
    if ($text.Length -gt 0) { $result.Add($text) }
  }
  return $result.ToArray()
}

function Get-Line {
  param([int]$Number)
  $text = $lines[$Number - 1].Trim()
  return [System.Net.WebUtility]::HtmlDecode($text)
}
function Get-List {
  param([int]$Start, [int]$End)
  $result = New-Object System.Collections.Generic.List[string]
  for ($i = $Start; $i -le $End; $i++) {
    $text = $lines[$i - 1].Trim()
    $text = [System.Net.WebUtility]::HtmlDecode($text)
    $text = $text -replace '^-\s*', ''
    $text = $text -replace ';$', ''
    $text = $text.Trim()
    if ($text.Length -gt 0) { $result.Add($text) }
  }
  return $result.ToArray()
}

function Split-At {
  param([string]$Text, [string]$Marker)
  $index = $Text.IndexOf($Marker, [System.StringComparison]::Ordinal)
  if ($index -lt 0) { throw "Marcador nao encontrado: $Marker" }
  return @($Text.Substring(0, $index).Trim(), $Text.Substring($index).Trim())
}

function New-Detail {
  param(
    [string]$Title,
    [int[]]$Numbers,
    [string[]]$Paragraphs,
    [string]$Id
  )
  if (-not $Paragraphs) { $Paragraphs = Get-Para $Numbers }
  $id = if ($Id) { $Id } else {
    $slug = $Title.ToLowerInvariant()
    $slug = $slug -replace '[áàâãä]', 'a' -replace '[éèêë]', 'e' -replace '[íìîï]', 'i' -replace '[óòôõö]', 'o' -replace '[úùûü]', 'u' -replace 'ç', 'c'
    $slug = $slug -replace '[^a-z0-9]+', '-'
    $slug.Trim('-')
  }
  return [ordered]@{
    id         = $id
    title      = $Title
    paragraphs = @($Paragraphs)
  }
}

$radarText = (Get-Line 1128)
$radarApplication = (Get-Line 1130)
$radarSplit = Split-At $radarApplication 'O UltraGPR'
$hidrossedText = (Get-Line 1865)
$hidrossedSplit = Split-At $hidrossedText 'O Perfilador de Subfundo'

# ---------------------------------------------------------------------
# GEOTECNOLOGIAS
# ---------------------------------------------------------------------
$geoItems = @(
  [ordered]@{
    slug        = 'metodos-eletricos-e-eletromagneticos.html'
    title       = 'Métodos elétricos e eletromagnéticos'
    subtitle    = (Get-Line 862)
    headlineHtml = 'Investigar o subsolo a partir de suas <span>propriedades elétricas e eletromagnéticas.</span>'
    lead        = (Get-Line 396)
    intro       = @(Get-Para @(866, 868, 870))
    introTitle  = (Get-Line 862)
    listTitle   = 'Métodos disponíveis'
    list        = @(Get-List 874 884)
    listLinks   = @{ 'Radar de Penetração no Solo (GPR) e UltraGPR' = 'radar-e-investigacao-de-alta-resolucao.html' }
    cta         = 'Quero conhecer os métodos elétricos e eletromagnéticos'
    crosslink   = [ordered]@{
      title = 'Radar de Penetração no Solo (GPR) e UltraGPR'
      text  = 'O conteúdo técnico de Radar de Penetração no Solo (GPR) e UltraGPR é apresentado na página Radar e investigação de alta resolução.'
      label = 'Conhecer a página de Radar e investigação de alta resolução'
      href  = 'radar-e-investigacao-de-alta-resolucao.html'
    }
    details     = @(
      (New-Detail 'Eletrorresistividade (RES)' @(1090, 1092, 1094, 1096) -Id 'eletrorresistividade'),
      (New-Detail 'Polarização Induzida (IP)' @(1100, 1102, 1104) -Id 'polarizacao-induzida'),
      (New-Detail 'Potencial Espontâneo (SP)' @(1108, 1110) -Id 'potencial-espontaneo'),
      (New-Detail 'Eletromagnético no Domínio do Tempo (TDEM)' @(1114, 1116) -Id 'tdem'),
      (New-Detail 'Magnetotelúrico (MT) e Áudio Magnetotelúrico (AMT)' @(1120, 1122, 1124) -Id 'mt-amt')
    )
  },
  [ordered]@{
    slug        = 'metodos-sismicos.html'
    title       = 'Métodos sísmicos'
    subtitle    = (Get-Line 893)
    headlineHtml = 'Entender o comportamento do subsolo a partir da <span>propagação de ondas.</span>'
    lead        = 'Análise de ondas sísmicas para caracterizar materiais, investigar estruturas e acompanhar mudanças no subsolo.'
    intro       = @(Get-Para @(897, 899, 901))
    introTitle  = (Get-Line 893)
    listTitle   = 'Métodos disponíveis'
    list        = @(Get-List 905 915)
    listLinks   = @{}
    cta         = 'Quero conhecer os métodos sísmicos'
    details     = @(
      (New-Detail 'Sísmica de Refração' @(1141, 1143) -Id 'sismica-de-refracao'),
      (New-Detail 'Sísmica de Reflexão' @(1147, 1149) -Id 'sismica-de-reflexao'),
      (New-Detail 'MASW (Multichannel Analysis of Surface Waves) — Análise Multicanal de Ondas Superficiais' @(1153, 1155) -Id 'masw'),
      (New-Detail 'MAM (Microtremor Array Method) — Análise de Microtremores em Arranjo' @(1159, 1161) -Id 'mam'),
      (New-Detail 'HVSR (Horizontal-to-Vertical Spectral Ratio) — Razão Espectral Horizontal/Vertical' @(1165, 1167) -Id 'hvsr'),
      (New-Detail 'Análise do Ruído Ambiente (Interferometria e Microssísmica)' @(1171, 1176) -Id 'ruido-ambiente')
    )
  },
  [ordered]@{
    slug        = 'metodos-potenciais.html'
    title       = 'Métodos potenciais'
    subtitle    = (Get-Line 928)
    headlineHtml = 'Mapear variações naturais das <span>propriedades físicas do terreno.</span>'
    lead        = (Get-Line 408)
    intro       = @(Get-Para @(932, 934))
    introTitle  = (Get-Line 928)
    listTitle   = 'Métodos disponíveis'
    list        = @(Get-List 938 942)
    listLinks   = @{}
    cta         = 'Quero conhecer os métodos potenciais'
    details     = @(
      (New-Detail 'Magnetometria' @(1182, 1184) -Id 'magnetometria'),
      (New-Detail 'Gravimetria' @(1188, 1190) -Id 'gravimetria'),
      (New-Detail 'Gamaespectrometria' @(1194, 1199) -Id 'gamaespectrometria')
    )
  },
  [ordered]@{
    slug        = 'radar-e-investigacao-de-alta-resolucao.html'
    title       = 'Radar e investigação de alta resolução'
    subtitle    = 'Radar de Penetração no Solo (GPR) e UltraGPR'
    headlineHtml = 'Radar de Penetração no Solo (GPR) e <span>UltraGPR</span>'
    lead        = 'Geotecnologias de GPR para investigar estruturas, objetos e interferências no subsolo, com diferentes configurações de levantamento.'
    intro       = @($radarText, (Get-Line 1135))
    introTitle  = 'Radar de Penetração no Solo (GPR) e UltraGPR'
    listTitle   = 'Tecnologias disponíveis'
    list        = @('GPR terrestre', 'GPR 3D', 'GPR aerotransportado', 'UltraGPR')
    listLinks   = @{}
    cta         = 'Quero falar sobre meu projeto'
    details     = @(
      (New-Detail 'GPR (Radar de Penetração no Solo)' @() @($radarSplit[0]) -Id 'gpr'),
      (New-Detail 'UltraGPR' @() @($radarSplit[1]) -Id 'ultragpr')
    )
  },
  [ordered]@{
    slug        = 'levantamentos-aereos-com-drones.html'
    title       = 'Levantamentos aéreos com drones'
    subtitle    = (Get-Line 951)
    headlineHtml = 'Dados geofísicos e geoespaciais adquiridos de <span>uma nova perspectiva.</span>'
    lead        = (Get-Line 420)
    intro       = @(Get-Para @(955, 957))
    introTitle  = (Get-Line 951)
    listTitle   = 'Geotecnologias disponíveis'
    list        = @(Get-List 961 969)
    listLinks   = @{}
    cta         = 'Quero conhecer os levantamentos com drones'
    details     = @(
      (New-Detail 'Magnetometria com drone' @(1205, 1207) -Id 'magnetometria-com-drone'),
      (New-Detail 'Gamaespectrometria com drone' @(1211, 1213) -Id 'gamaespectrometria-com-drone'),
      (New-Detail 'GPR aerotransportado' @(1217, 1219) -Id 'gpr-aerotransportado'),
      (New-Detail 'LiDAR com Drone' @(1223, 1225) -Id 'lidar-com-drone'),
      (New-Detail 'Aerofotogrametria' @(1229, 1234) -Id 'aerofotogrametria')
    )
  },
  [ordered]@{
    slug        = 'perfilagem-geofisica.html'
    title       = 'Perfilagem geofísica'
    subtitle    = (Get-Line 982)
    headlineHtml = 'Investigar as propriedades das formações <span>ao longo da profundidade.</span>'
    lead        = 'Medições em poços e furos de sondagem para caracterizar as propriedades físicas das formações geológicas.'
    intro       = @(Get-Para 986)
    introTitle  = (Get-Line 982)
    listTitle   = 'Perfis disponíveis'
    list        = @(Get-List 990 1000)
    listLinks   = @{}
    cta         = 'Quero conhecer a perfilagem geofísica'
    details     = @(
      (New-Detail 'Perfilagem de Densidade (Gama-Gama)' @(1240, 1242) -Id 'densidade-gama-gama'),
      (New-Detail 'Perfilagem de Gama Natural' @(1246, 1248) -Id 'gama-natural'),
      (New-Detail 'Perfilagem de Suscetibilidade Magnética' @(1252, 1254) -Id 'suscetibilidade-magnetica'),
      (New-Detail 'Perfilagem de Resistividade Elétrica' @(1258, 1260) -Id 'resistividade-eletrica'),
      (New-Detail 'Perfilagem de Polarização Induzida (IP/cargabilidade)' @(1264, 1266) -Id 'polarizacao-induzida'),
      (New-Detail 'Perfilagem Sônica' @(1270, 1275) -Id 'sonica')
    )
  }
)

# ---------------------------------------------------------------------
# APLICACOES
# ---------------------------------------------------------------------
$solItems = @(
  [ordered]@{
    slug        = 'geotecnia.html'
    title       = 'Geotecnia'
    subtitle    = (Get-Line 1324)
    headlineHtml = 'Mais informação para compreender <span>estruturas geotécnicas e condições do terreno.</span>'
    lead        = (Get-Line 443)
    intro       = @(Get-Para @(1326, 1328))
    introTitle  = (Get-Line 1324)
    listTitle   = 'Aplicações em geotecnia'
    list        = @(Get-List 1332 1346)
    listLinks   = @{}
    cta         = 'Quero conhecer as aplicações para Geotecnia'
    details     = @(
      (New-Detail 'Pilhas de estéril e rejeito' @(1608, 1610, 1612) -Id 'pilhas-de-esteril-e-rejeito'),
      (New-Detail 'Barragens e Diques' @(1616, 1618, 1620) -Id 'barragens-e-diques'),
      (New-Detail 'Taludes e encostas' @(1624, 1626, 1628) -Id 'taludes-e-encostas'),
      (New-Detail 'Cavas e Minas Subterrâneas' @(1632, 1634, 1636) -Id 'cavas-e-minas-subterraneas'),
      (New-Detail 'Túneis' @(1640, 1642) -Id 'tuneis'),
      (New-Detail 'Áreas de Subsidência' @(1646, 1648, 1650) -Id 'areas-de-subsidencia'),
      (New-Detail 'Monitoramento geotécnico' @(1654, 1656, 1658) -Id 'monitoramento-geotecnico'),
      (New-Detail 'Caracterização Geológico-Geotécnica' @(1662, 1664, 1669) -Id 'caracterizacao-geologico-geotecnica')
    )
  },
  [ordered]@{
    slug        = 'exploracao-mineral.html'
    title       = 'Exploração Mineral'
    subtitle    = (Get-Line 1355)
    headlineHtml = 'Investigar melhor <span>antes de avançar.</span>'
    lead        = 'Investigação de alvos e estruturas geológicas para orientar campanhas de pesquisa e exploração de diferentes substâncias minerais.'
    intro       = @(Get-Para 1357)
    introTitle  = (Get-Line 1355)
    listTitle   = 'Aplicações em diferentes contextos minerais'
    list        = @(Get-List 1361 1387)
    listLinks   = @{}
    cta         = 'Quero conhecer as aplicações para Exploração Mineral'
    details     = @(
      (New-Detail 'Minério de ferro' @(1675, 1677) -Id 'minerio-de-ferro'),
      (New-Detail 'Ouro em veios' @(1681, 1683, 1685) -Id 'ouro-em-veios'),
      (New-Detail 'Ouro disseminado' @(1689, 1691) -Id 'ouro-disseminado'),
      (New-Detail 'Cobre' @(1695, 1697, 1699, 1701) -Id 'cobre'),
      (New-Detail 'Níquel' @(1705, 1707, 1709, 1711, 1713) -Id 'niquel'),
      (New-Detail 'Zinco e Chumbo' @(1717, 1719) -Id 'zinco-e-chumbo'),
      (New-Detail 'Lítio' @(1723, 1725, 1727) -Id 'litio'),
      (New-Detail 'Terras Raras' @(1731) -Id 'terras-raras'),
      (New-Detail 'Manganês' @(1735, 1737) -Id 'manganes'),
      (New-Detail 'Fosfato' @(1741) -Id 'fosfato'),
      (New-Detail 'Potássio' @() @() -Id 'potassio'),
      (New-Detail 'Bauxita' @(1747, 1749, 1751, 1753) -Id 'bauxita'),
      (New-Detail 'Grafita' @(1757) -Id 'grafita'),
      (New-Detail 'Urânio' @(1761, 1763) -Id 'uranio')
    )
  },
  [ordered]@{
    slug        = 'engenharia.html'
    title       = 'Engenharia'
    subtitle    = (Get-Line 1396)
    headlineHtml = 'Conhecer o subsolo antes de <span>construir, intervir ou avançar.</span>'
    lead        = (Get-Line 455)
    intro       = @(Get-Para @(1398, 1400))
    introTitle  = (Get-Line 1396)
    listTitle   = 'Aplicações em engenharia'
    list        = @(Get-List 1404 1410)
    listLinks   = @{}
    cta         = 'Quero conhecer as aplicações para Engenharia'
    details     = @(
      (New-Detail 'Investigação de fundações' @(1774, 1776, 1778) -Id 'investigacao-de-fundacoes'),
      (New-Detail 'Mapeamento de interferências subterrâneas' @(1782, 1784, 1786) -Id 'mapeamento-de-interferencias'),
      (New-Detail 'Identificação de vazios, cavidades e zonas de fraqueza' @(1790, 1792, 1794) -Id 'vazios-cavidades'),
      (New-Detail 'Determinação da espessura do solo e profundidade do embasamento' @(1798, 1803) -Id 'espessura-do-solo')
    )
  },
  [ordered]@{
    slug        = 'hidrogeologia.html'
    title       = 'Hidrogeologia'
    subtitle    = (Get-Line 1457)
    headlineHtml = 'Investigar a água subterrânea e <span>seu comportamento no subsolo.</span>'
    lead        = (Get-Line 461)
    intro       = @(Get-Para 1459)
    introTitle  = (Get-Line 1457)
    listTitle   = 'Aplicações em hidrogeologia'
    list        = @(Get-List 1463 1475)
    listLinks   = @{}
    cta         = 'Quero conhecer as aplicações para Hidrogeologia'
    details     = @(
      (New-Detail 'Prospecção de água subterrânea e locação de poços' @(1809, 1811) -Id 'prospeccao-de-agua'),
      (New-Detail 'Identificação de zonas de recarga e descarga' @(1815, 1817, 1819) -Id 'zonas-de-recarga-e-descarga'),
      (New-Detail 'Investigação de aquíferos fraturados e porosos' @(1823, 1825, 1827, 1829) -Id 'aquiferos-fraturados-e-porosos'),
      (New-Detail 'Mapeamento da interface entre água doce e água salina' @(1833, 1835, 1837) -Id 'interface-agua-doce-salgada'),
      (New-Detail 'Investigação de áreas contaminadas' @() -Id 'investigacao-de-areas-contaminadas'),
      (New-Detail 'Mapeamento de plumas de contaminação' @(1841, 1843, 1845) -Id 'plumas-de-contaminacao'),
      (New-Detail "Apoio ao rebaixamento do nível d’água e desaguamento de minas" @(1849, 1851, 1856) -Id 'rebaixamento-do-nivel-dagua')
    )
  },
  [ordered]@{
    slug        = 'arqueologia.html'
    title       = 'Arqueologia'
    subtitle    = (Get-Line 1484)
    headlineHtml = 'Investigar o subsolo <span>preservando o contexto da área.</span>'
    lead        = 'Investigação geofísica para apoiar a identificação de estruturas e objetos arqueológicos enterrados.'
    intro       = @(Get-Para 1486)
    introTitle  = (Get-Line 1484)
    listTitle   = 'Métodos aplicados'
    list        = @('GPR', 'Magnetometria', 'Eletrorresistividade')
    listLinks   = @{}
    cta         = 'Quero conhecer as aplicações para Arqueologia'
    details     = @(
      (New-Detail 'GPR, Magnetometria e Eletrorresistividade' @(1858) -Id 'metodos-geofisicos'),
      (New-Detail 'Integração dos métodos e preservação do sítio' @(1863) -Id 'integracao-e-preservacao')
    )
  },
  [ordered]@{
    slug        = 'hidrossedimentologia.html'
    title       = 'Hidrossedimentologia'
    subtitle    = (Get-Line 1495)
    headlineHtml = 'Investigar a dinâmica dos sedimentos e a evolução dos <span>ambientes aquáticos.</span>'
    lead        = (Get-Line 1495)
    intro       = @(Get-Para 1497)
    introTitle  = (Get-Line 1495)
    listTitle   = 'Métodos aplicados'
    list        = @('Batimetria', 'Perfilador de Subfundo (Sub-Bottom Profiler – SBP)', 'GPR')
    listLinks   = @{}
    cta         = 'Quero conhecer as aplicações para Hidrossedimentologia'
    details     = @(
      (New-Detail 'Batimetria' @() @($hidrossedSplit[0]) -Id 'batimetria'),
      (New-Detail 'Perfilador de Subfundo (Sub-Bottom Profiler – SBP)' @() @($hidrossedSplit[1]) -Id 'perfilador-de-subfundo'),
      (New-Detail 'GPR' @(1867) -Id 'gpr'),
      (New-Detail 'Integração de dados' @(1872) -Id 'integracao-de-dados')
    )
  },
  [ordered]@{
    slug        = 'monitoramento.html'
    title       = 'Monitoramento'
    subtitle    = (Get-Line 1504)
    headlineHtml = 'Acompanhar <span>mudanças ao longo do tempo.</span>'
    lead        = (Get-Line 473)
    intro       = @(Get-Para @(1506, 1508))
    introTitle  = (Get-Line 1504)
    listTitle   = 'Aplicações de monitoramento'
    list        = @(Get-List 1512 1516)
    listLinks   = @{}
    cta         = 'Quero conhecer as aplicações de Monitoramento'
    details     = @(
      (New-Detail 'Monitoramento de barragens, pilhas e taludes' @(1878, 1880, 1882, 1884, 1886) -Id 'barragens-pilhas-e-taludes'),
      (New-Detail 'Monitoramento de plumas de contaminação' @(1890, 1892, 1894) -Id 'plumas-de-contaminacao'),
      (New-Detail 'Monitoramento Microssísmico' @(1898, 1900, 1905) -Id 'monitoramento-microssismico')
    )
  }
)

$geo = [ordered]@{
  folder      = 'geotecnologias'
  hub         = '../geotecnologias.html'
  hubLabel    = 'Geotecnologias'
  otherLabel  = 'geotecnologias'
  kicker      = 'Geotecnologias'
  source      = 'copy/Copys-extraido.txt'
  hero        = [ordered]@{
    title      = (Get-Line 818)
    paragraphs = @(Get-Para @(822, 826))
  }
  introBlock  = [ordered]@{
    kicker     = (Get-Line 837)
    title      = (Get-Line 839)
    highlight  = (Get-Line 841)
    paragraphs = @(Get-Para @(845, 849, 853))
  }
  integration = [ordered]@{
    kicker     = (Get-Line 1011)
    title      = (Get-Line 1013)
    lead       = (Get-Line 1017)
    paragraphs = @(Get-Para @(1021, 1025))
  }
  processTitle = 'Como a tecnologia entra no projeto'
  process     = @(
    [ordered]@{ title = 'Entendimento do objetivo'; text = 'A investigação começa pelo que o projeto precisa compreender.' },
    [ordered]@{ title = 'Definição da estratégia'; text = 'Selecionamos os métodos e a configuração de aquisição mais adequados ao cenário.' },
    [ordered]@{ title = 'Aquisição em campo'; text = 'Os dados são coletados conforme o planejamento técnico e os controles definidos para o projeto.' },
    [ordered]@{ title = 'Processamento e interpretação'; text = 'As informações são processadas, analisadas e integradas ao contexto da investigação.' },
    [ordered]@{ title = 'Entrega dos resultados'; text = 'Os dados são transformados em produtos e informações técnicas para apoiar as próximas etapas do projeto.' }
  )
  cta         = [ordered]@{
    title      = 'Ainda não sabe qual tecnologia o seu projeto precisa?'
    paragraphs = @(
      'Você não precisa chegar com o método definido.',
      'Conte para nossa equipe o objetivo da investigação, as características da área e o que precisa ser compreendido. A partir dessas informações, podemos avaliar tecnicamente a demanda e orientar os próximos passos.'
    )
    label      = 'Quero falar sobre meu projeto'
  }
  items       = $geoItems
}

$sol = [ordered]@{
  folder      = 'solucoes'
  hub         = '../solucoes.html'
  hubLabel    = 'Aplicações'
  otherLabel  = 'aplicações'
  kicker      = 'Aplicações'
  source      = 'copy/Copys-extraido.txt'
  hero        = [ordered]@{
    title      = (Get-Line 1284)
    paragraphs = @(Get-Para @(1288, 1292))
  }
  introBlock  = [ordered]@{
    kicker     = (Get-Line 1305)
    title      = (Get-Line 1307)
    highlight  = ''
    paragraphs = @(Get-Para @(1311, 1315))
  }
  integration = [ordered]@{
    kicker     = 'Abordagem integrada'
    title      = (Get-Line 1529)
    lead       = (Get-Line 1531)
    paragraphs = @(Get-Para @(1535, 1539))
  }
  processTitle = 'Como desenvolvemos as aplicações'
  process     = @(
    [ordered]@{ title = 'Entendemos o problema'; text = 'Identificamos o objetivo da investigação, as condições da área e as informações necessárias.' },
    [ordered]@{ title = 'Avaliamos o contexto técnico'; text = 'Consideramos profundidade, dimensões do alvo, características geológicas, condições de acesso e dados disponíveis.' },
    [ordered]@{ title = 'Definimos a estratégia'; text = 'Selecionamos os métodos e a configuração de investigação mais adequados ao cenário.' },
    [ordered]@{ title = 'Executamos e interpretamos'; text = 'Realizamos a aquisição, o processamento e a integração dos dados.' },
    [ordered]@{ title = 'Entregamos informações para apoiar a decisão'; text = 'Os resultados são apresentados de acordo com os objetivos definidos para o projeto.' }
  )
  cta         = [ordered]@{
    title      = 'Qual é o desafio do seu projeto?'
    paragraphs = @(
      'Você não precisa saber antecipadamente qual tecnologia utilizar.',
      'Conte para nossa equipe o que precisa ser investigado, onde está a área e qual é o objetivo do estudo. A partir dessas informações, podemos entender a demanda e avaliar os próximos passos.'
    )
    label      = 'Quero falar sobre meu projeto'
  }
  items       = $solItems
}

$contentDir = Join-Path $Root 'content'
New-Item -ItemType Directory -Force -Path $contentDir | Out-Null
[System.IO.File]::WriteAllText((Join-Path $contentDir 'geo-data.json'), ($geo | ConvertTo-Json -Depth 12), $utf8)
[System.IO.File]::WriteAllText((Join-Path $contentDir 'sol-data.json'), ($sol | ConvertTo-Json -Depth 12), $utf8)

Write-Host "geo items: $($geoItems.Count)"
Write-Host "sol items: $($solItems.Count)"
Write-Host "geo sections: $(($geoItems | ForEach-Object { $_.details.Count } | Measure-Object -Sum).Sum)"
Write-Host "sol sections: $(($solItems | ForEach-Object { $_.details.Count } | Measure-Object -Sum).Sum)"