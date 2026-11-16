# Relatório final — site Neogeo

Data: 12/11/2026

## Escopo entregue

### Hubs reconstruídos
- `geotecnologias.html` — hub de Geotecnologias.
- `solucoes.html` — hub de Aplicações, mantendo o rótulo de menu **Aplicações** e a rota `/solucoes/`.

### Geotecnologias — 6 páginas internas
- `geotecnologias/metodos-eletricos-e-eletromagneticos.html`
- `geotecnologias/metodos-sismicos.html`
- `geotecnologias/metodos-potenciais.html`
- `geotecnologias/radar-e-investigacao-de-alta-resolucao.html`
- `geotecnologias/levantamentos-aereos-com-drones.html`
- `geotecnologias/perfilagem-geofisica.html`

### Aplicações — 7 páginas internas
- `solucoes/geotecnia.html`
- `solucoes/exploracao-mineral.html`
- `solucoes/engenharia.html`
- `solucoes/hidrogeologia.html`
- `solucoes/arqueologia.html`
- `solucoes/hidrossedimentologia.html`
- `solucoes/monitoramento.html`

### Páginas preservadas
- `index.html`
- `a-empresa.html`
- `pesquisa-desenvolvimento.html`
- `sms.html`
- `parceiros.html`
- `blog.html`
- `contato.html`

O header global foi atualizado nas 7 páginas raiz, sem alteração da identidade visual, do logo, dos botões ou dos tokens existentes.

## Refinamento de design e layout

Rodada de direção de arte aplicada sobre a estrutura existente, sem reescrever a copy oficial nem alterar rotas, header ou footer.

- **Padrão global de subtítulos**: eyebrows e kickers (`eyebrow`, `hub-kicker`, `section-kicker`, `empresa-eyebrow`) unificados em caixa alta, 0,72 rem, peso 600, tracking de 0,16 em, azul da marca (azul-claro sobre fundos escuros) e espaçamento inferior consistente.
- **Home**: Bloco 1 com hero fullscreen independente (placeholder cinza preparado para imagem/vídeo, `background-size: cover`) e controle centralizado “↓ CONHEÇA MAIS ↓” com duas setas SVG e âncora para o Bloco 2; Bloco 2 preservado no fluxo normal com placeholder preto, texto institucional e caixa azul-marinho; faixas editoriais cinzas mais largas; grade de introdução com pesos equilibrados, imagem maior e gap reduzido.
- **A Empresa**: cards brancos menores e centralizados na seção azul; placeholder direito mais alto; título de atuação maior e mais leve; texto de presença alinhado ao topo.
- **Hubs Geotecnologias e Aplicações**: abertura em fundo visual com texto sobreposto à esquerda; blocos uniformes, sem alternância de cor ou de lado; explicação antes de métodos/exemplos.
- **Páginas internas**: breadcrumb acima do título removido; placeholders laterais coerentes nas seções técnicas longas, preservando integralmente a copy.
- **SMS**: “Uma responsabilidade compartilhada.” em faixa escura com texto centralizado e fundo mais rico; colunas invertidas em “Sustentabilidade”; “Política de Álcool e Drogas” centralizada e sóbria, sem imagem de fundo.
- **Parceiros**: abertura em fundo Groundradar com texto à esquerda; “Mais possibilidades…” centralizada com os três cards alinhados ao centro.
- **Blog**: “Do campo para o conteúdo.” em faixa de fundo com texto à esquerda.
- **Heróis com fundo**: P&D, SMS, Parceiros, Blog e Contato usam o mesmo padrão de fundo visual com texto sobreposto e contraste preservado.

Componentes CSS reutilizáveis introduzidos: `.has-bg`/`.bg-visual`, `.page-hero--bg`, `.page-hero-duo`, `.feature-band`/`.feature-band--center`/`.feature-band--left`, `.centered-block`, `.centered-note`, `.cards--centered`, `.split--invert`, `.hub-hero--bg` e `.detail-item--media`/`.detail-media`.

## Refinamento tipográfico e navegação

Rodada de refinamento sobre os componentes existentes, sem alterar copy, rotas, CTAs, placeholders, header/footer ou o layout das subpáginas técnicas.

### Heroes com texto sobre imagem de fundo

- Coluna editorial compacta e alinhada à esquerda: `max-width: 620px` para categoria, H1, parágrafos e CTA (≈35–42% da largura útil em desktop).
- H1 dos heroes: `clamp(2.2rem, 3.9vw, 3.55rem)`, peso 700, `line-height` 1.05, `letter-spacing` −0.028em e `text-wrap: balance`.
- Parágrafos com a mesma largura visual do título, `line-height` 1.72 e espaçamento uniforme.
- CTA verde mantido alinhado à esquerda.
- Fundo permanece full-width (`.bg-visual`), liberando o lado direito da composição.
- Páginas ajustadas: Geotecnologias, Aplicações, P&D, SMS, Parceiros, Blog e Contato.
- Contato: `.page-hero-duo` passou a uma coluna única empilhada em todas as larguras, eliminando a segunda coluna de texto à direita.
- Blocos internos com o mesmo padrão: faixa Groundradar (Parceiros) e “Do campo para o conteúdo.” (Blog) com `max-width: 660px`; lista “Principais frentes” e CTA no mesmo container à esquerda.
- Seções centralizadas, grids, tabelas, formulários e blocos com imagem lateral foram preservados.

### Quebras de linha editoriais

- Títulos com quebras intencionais no desktop via `<br class="hero-line-break">`, ocultas abaixo de 1024 px.
- Geotecnologias: “Diferentes métodos / para investigar / o que não está / visível na superfície.”
- Aplicações: “Geofísica aplicada / aos desafios / do seu projeto.”
- Groundradar: “Tecnologia GPR / para investigações / de maior profundidade.”
- Nenhuma palavra ou pontuação foi alterada; as quebras são geradas no `render-site.ps1` a partir da copy original.

### Menu superior

- Links inativos: Roboto 400, brancos, caixa alta.
- Página atual e hover: azul de destaque `--nav-active: #63b6e8` + peso 700.
- Largura estabilizada com `inline-grid` e uma cópia oculta em peso 700 (`aria-hidden="true"`), eliminando layout shift na troca de peso e sem duplicar o nome acessível do link.
- `aria-current="page"` na página atual e `aria-current="true"` no hub pai das subpáginas.
- Submenu marca a subpágina atual em azul/bold com barra lateral; hover segue o mesmo destaque.
- Estado ativo preservado no menu mobile, com abertura/fechamento e submenus inalterados.

## Conteúdo e auditoria de copy

- Fonte obrigatória: `copy/Copys-extraido.txt`, extraída de `Copys.docx`.
- 980 parágrafos não vazios na fonte.
- 69 seções técnicas geradas: 27 em Geotecnologias e 42 em Aplicações.
- 650 strings de conteúdo conferidas nas páginas renderizadas.
- 281 trechos técnicos comparados diretamente contra a fonte original.
- Nenhum parágrafo técnico foi resumido, parafraseado ou truncado.
- Nenhum uso de `line-clamp` nas páginas de conteúdo.
- Títulos editoriais `[BLOCO 10]` e `[BLOCO 11]` foram substituídos por títulos limpos:
  - “Como a tecnologia entra no projeto”
  - “Como desenvolvemos as aplicações”
- O nome completo “Perfilador de Subfundo (Sub-Bottom Profiler – SBP)” foi restaurado.

## Navegação, acessibilidade e responsividade

- Submenus de Geotecnologias e Aplicações no header:
  - abertura por mouse/hover;
  - abertura por toque no botão de seta;
  - teclado com Enter/Espaço, ArrowDown, ArrowUp, Home e End;
  - fechamento com Escape, clique fora e perda de foco;
  - `aria-expanded`, `aria-controls`, `aria-haspopup` e rótulos dinâmicos.
- Corrigido o fechamento indevido do menu mobile ao clicar no próprio botão.
- Links internos validados: nenhum `href="#"` restante.
- Âncoras dos hubs apontam para IDs reais nas páginas internas.
- Offset sob header sticky: 120 px nas subpáginas e 110 px nas páginas raiz.
- Uma única H1 por página, `lang="pt-BR"`, title, meta description e viewport em todas as 22 páginas.
- Layout validado em 390 px, 768 px, 1000 px, 1100 px e 1300 px sem overflow horizontal.
- `prefers-reduced-motion` respeitado.

## Blog e contato

- Blog mantido como template vazio, com placeholders neutros e sem artigos inventados.
- CTAs de artigos e “Carregar mais” foram neutralizados, sem links mortos.
- Contato recebeu a opção **Hidrossedimentologia**.
- “Quero ver como chegar” aponta para o Google Maps com o endereço da sede.
- O acesso ao Código de Ética foi convertido em solicitação por e-mail, pois o documento não existe no projeto.

## Arquivos principais

### Conteúdo e geração
- `scripts/build-content-json.ps1`
- `scripts/render-site.ps1`
- `content/geo-data.json`
- `content/sol-data.json`

### Estilos e comportamento
- `styles/global.css`
- `styles/home.css`
- `styles/pages.css`
- `styles/subpages.css`
- `styles/a-empresa.css`
- `scripts/main.js`

### Validação
- `scripts/audit-site.ps1`
- `scripts/serve.ps1`

### Páginas
- 2 hubs, 13 subpáginas e 7 páginas raiz preservadas.

## Testes executados

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\audit-site.ps1 -BaseUrl http://127.0.0.1:4173/
```

Resultado: **0 problemas**, 3 avisos (formulários sem backend), 22 páginas com HTTP 200.

Validações de navegador:
- menu mobile abre/fecha e mantém o submenu;
- submenu desktop visível, posicionado dentro da viewport;
- Escape fecha o submenu e devolve o foco ao botão;
- ArrowDown abre o submenu e foca o primeiro link;
- clique fora fecha o menu;
- âncoras param abaixo do header sticky.

Verificações visuais desta rodada (headless Chrome, 1440 px e 390 px):
- home desktop e mobile com hero de abertura em tela cheia, sem overflow horizontal;
- home: controle “CONHEÇA MAIS” com duas setas e âncora `#homepage-content` funcionais;
- home: Bloco 2 preservado após o hero, com placeholder preto, texto e caixa azul;
- A Empresa: cards centrados, atuação e presença alinhadas;
- hub, bloco de hub e subpágina técnica (desktop e mobile) sem quebra de layout;
- SMS: contraste de “Uma responsabilidade compartilhada.”, inversão de Sustentabilidade e política centralizada;
- Parceiros: faixa Groundradar e cards centralizados;
- Blog: faixa “Do campo para o conteúdo.”;
- heróis com fundo de P&D, SMS e Contato com camada visual visível e texto legível.

Verificações desta rodada de tipografia e navegação (headless Chrome):
- Geotecnologias, Aplicações, P&D, SMS, Parceiros, Blog e Contato com coluna de texto compacta à esquerda e lado direito do fundo livre;
- Geotecnologias com o H1 em 4 linhas no desktop e reflow natural em tablet/mobile (quebras ocultas abaixo de 1024 px);
- bloco Groundradar e faixa “Do campo para o conteúdo.” com coluna de 660 px e conteúdo alinhado;
- largura medida da coluna do hero: 620 px; `scrollWidth` igual à viewport em 1920, 1440, 1024, 768 e 390 px (sem rolagem horizontal);
- menu: inativos em peso 400, ativo e hover em peso 700 e azul `#63b6e8`;
- simulação de bold em todos os links: deslocamento horizontal de 0 px em todos os itens (sem layout shift);
- subpágina `geotecnologias/metodos-sismicos.html`: GEOTECNOLOGIAS ativo e “Métodos sísmicos” marcado no submenu;
- menu mobile aberto em 390 px com submenu expandido, estado ativo e subitem atual destacados.

## Imagens e ícones da homepage (13/11/2026)

Rodada restrita à homepage: `index.html` e `styles/home.css`. Nenhuma outra página, copy, rota, header, footer, menu ou formulário foi alterado. O hero de abertura e o placeholder da equipe foram mantidos intactos.

### Imagens inseridas (11)

Todas usam container próprio com `overflow: hidden`, imagem absoluta, `width/height: 100%`, `object-fit: cover` e `border-radius: inherit`, preservando dimensões e recortes aprovados.

| Arquivo | Seção | Container |
| --- | --- | --- |
| `01-neogeo-conhecimento-subsuperficie.png` | Bloco 2 — imagem principal com caixa azul | `.hero-media` |
| `02-neogeo-experiencia-em-campo.png` | “Experiência em campo.” | primeiro `.bar-placeholder` |
| `03-neogeo-conhecimento-para-interpretar.png` | “Conhecimento para interpretar.” | segundo `.bar-placeholder` |
| `05-neogeo-estrategia-investigacao.png` | Geotecnologias — abertura | `.geo-header-media` |
| `06-neogeo-cuidado-planejamento.png` | Como trabalhamos — cuidado/planejamento | `.work-wide-media` |
| `07-neogeo-como-trabalhamos.png` | Como trabalhamos — imagem lateral | `.work-media` |
| `08-neogeo-controle-qualidade.png` | Controle de qualidade | primeiro `.work-small-media` |
| `09-neogeo-investigacao-orientada-objetivo.png` | Investigação orientada pelo objetivo | `.work-large-media` |
| `10-neogeo-resultados-integrados.png` | Resultados integrados | segundo `.work-small-media` |
| `11-neogeo-pesquisa-desenvolvimento.png` | P&D — fundo com texto sobreposto | `.pd-bg` |
| `12-neogeo-contato.png` | Contato — bloco final | `.contato-media` |

A caixa azul do Bloco 2 permanece no primeiro plano, sobre a imagem. O CTA do contato também permanece acima da foto.

### Placeholders preservados

- Hero fullscreen (`home-hero` / `.home-hero-media`): reservado para o vídeo institucional; nenhuma imagem foi inserida.
- Fotografia da equipe (`.intro-media`): mantida preta, vazia e com as mesmas dimensões.
- `.geo-visual` (6 ocorrências): sem arquivo correspondente; mantidos como estão.
- Slots de logotipos de parceiros/clientes (10): sem arquivo correspondente; mantidos.

### Ícones (17)

Os 17 ícones dos círculos explicativos foram inseridos como **SVG inline** (mesmo desenho dos arquivos em `assets/icons`), para que `stroke="currentColor"` funcione e o ícone herde a cor do círculo. O diâmetro dos círculos não mudou.

- Geotecnologias (6, círculo preto 54 px, ícone branco):
  - Métodos elétricos e eletromagnéticos → `assets/icons/neogeo-metodos-eletricos-eletromagneticos.svg`
  - Métodos sísmicos → `assets/icons/neogeo-metodos-sismicos.svg`
  - Métodos potenciais → `assets/icons/neogeo-metodos-potenciais.svg`
  - Radar e investigação de alta resolução → `assets/icons/neogeo-radar-investigacao-alta-resolucao.svg`
  - Levantamentos aéreos com drones → `assets/icons/neogeo-levantamentos-aereos-drones.svg`
  - Perfilagem geofísica → `assets/icons/neogeo-perfilagem-geofisica.svg`
- Aplicações (6, círculo preto 46 px, ícone branco):
  - Geotecnia → `assets/icons/neogeo-geotecnia.svg`
  - Exploração Mineral → `assets/icons/neogeo-exploracao-mineral.svg`
  - Engenharia → `assets/icons/neogeo-engenharia.svg`
  - Hidrogeologia → `assets/icons/neogeo-hidrogeologia.svg`
  - Arqueologia → `assets/icons/neogeo-arqueologia.svg`
  - Monitoramento → `assets/icons/neogeo-monitoramento.svg`
- Como trabalhamos (5, círculo cinza 56 px, ícone azul-marinho):
  - Investigação orientada pelo seu objetivo → `assets/icons/neogeo-investigacao-orientada-objetivo.svg`
  - Controle de qualidade nas etapas técnicas → `assets/icons/neogeo-controle-qualidade-etapas-tecnicas.svg`
  - Conhecimento de diferentes especialidades → `assets/icons/neogeo-conhecimento-diferentes-especialidades.svg`
  - Segurança e responsabilidade na operação → `assets/icons/neogeo-seguranca-responsabilidade-operacao.svg`
  - Resultados integrados para seu objetivo → `assets/icons/neogeo-resultados-integrados-objetivo.svg`

Cada ícone ocupa 56% do diâmetro, fica centralizado horizontal e verticalmente (desvio 0 px) e não encosta na borda.

### Alterações técnicas

- `styles/home.css`: padrão reutilizável `.media-cover`; enquadramentos individuais por `object-position`; `.pd` como camada relativa com `.pd-bg` absoluto em `opacity: 0.35`; `.pd-grid` em `z-index: 1`; CTA do contato em `z-index: 1`; `.circle-icon` em 56% com flex centralizador.
- `index.html`: imagens reais nos 11 containers e 17 SVGs inline nos círculos; nenhuma copy, estrutura ou dimensão alterada.
- `scripts/audit-site.ps1`: o guard do Bloco 2 passou a aceitar `class="hero-media ..."` (o placeholder continua obrigatório, agora com a classe compartilhada `.media-cover`).

### Verificação

- 11/11 imagens carregadas, 0 caminhos quebrados, todas com `object-fit: cover`.
- 17/17 ícones renderizados e centralizados; círculos em 54 px (geo), 46 px (aplicações) e 56 px (processo).
- Sem overflow horizontal em 390, 768, 1280 e 1440 px.
- P&D: fundo preto preservado, imagem em 35% e conteúdo em 100%.
- `scripts/audit-site.ps1`: **0 problemas**, 3 avisos esperados (formulários sem backend).
- Build estático GitHub: **0 problemas**, 22 páginas e 912 referências relativas conferidas.
- Build Cloudflare: a verificação para por ausência de `login.html` na raiz do projeto (pré-existente e fora do escopo desta rodada); o artefato estático em si não apresenta referências quebradas.

## Etapa 2 — imagens nas páginas principais e refinamento global dos ícones (13/11/2026)

Rodada restrita às páginas principais (homepage, A Empresa, hubs Geotecnologias e Aplicações, P&D, SMS, Parceiros, Blog e Contato) e aos estilos compartilhados. Nenhuma subpágina de Geotecnologias ou Aplicações foi alterada. Copy, rotas, header, footer, menu e formulários permaneceram intactos.

### Imagens inseridas por página

Todas usam o padrão `.media-cover` (container próprio com `overflow: hidden`, imagem absoluta `width/height: 100%`, `object-fit: cover`, `object-position: center` e `border-radius: inherit`). Os fundos usam `.bg-photo` (camada absoluta, `inset: 0`, `opacity: 0.35`) sobre base preta, com o conteúdo em `z-index` superior.

| Página | Arquivo | Seção | Container |
| --- | --- | --- | --- |
| A Empresa | `a empresa/01-neogeo-a-empresa.png` | Hero | `.empresa-hero-bg` + `.bg-photo` |
| A Empresa | `a empresa/02-neogeo-quem-somos-equipe.png` | Quem somos | `.empresa-intro-visual` |
| A Empresa | `a empresa/03-neogeo-experiencia-construida-campo.png` | Nossa atuação | `.empresa-atuacao-media` |
| A Empresa | `a empresa/04-neogeo-planejamento-interpretacao.png` | Do planejamento à interpretação | `.empresa-processo` + `.bg-photo` |
| Geotecnologias | `geotecnologias/01-neogeo-geotecnologias.png` | Hero | `.bg-visual` + `.bg-photo` |
| Geotecnologias | `geotecnologias/02-neogeo-como-investigamos.png` | Como investigamos | `.hub-intro-media` |
| Aplicações | `aplicações/01-neogeo-aplicacoes.png` | Hero | `.bg-visual` + `.bg-photo` |
| Aplicações | `aplicações/02-neogeo-onde-aplicamos.png` | Onde aplicamos | `.hub-intro-media` |
| P&D | `ped/01-neogeo-pesquisa-desenvolvimento-novas-solucoes.png` | Hero | `.bg-visual` + `.bg-photo` |
| P&D | `ped/02-neogeo-pd-na-pratica.png` | P&D na prática | 1º `.split-media` |
| P&D | `ped/03-neogeo-geotrack-monitoramento-conceitual.png` | GEOTRACK | 2º `.split-media` |
| P&D | `ped/04-neogeo-ciencia-conhecimento.png` | Ciência e conhecimento | 3º `.split-media` |
| P&D | `ped/05-neogeo-contato-pd.png` | CTA final | `.page-cta-media` |
| SMS | `sms/01-neogeo-seguranca-meio-ambiente-saude.png` | Hero | `.bg-visual` + `.bg-photo` |
| SMS | `sms/02-neogeo-compromisso-sms.png` | Nosso compromisso | 1º `.split-media` |
| SMS | `sms/03-neogeo-seguranca-gestao.png` | Segurança começa na gestão | `.feature-band .bg-visual` + `.bg-photo` |
| SMS | `sms/04-neogeo-planejamento-seguro-campo.png` | Em campo | 2º `.split-media` |
| SMS | `sms/05-neogeo-etica-responsabilidade.png` | Ética e responsabilidade (Ouvidoria) | 4º `.split-media` |
| SMS | `sms/06-neogeo-contato-seguranca.png` | CTA final | `.page-cta-media` |
| Parceiros | `parceiros/01-neogeo-parceiros.png` | Hero | `.bg-visual` + `.bg-photo` |
| Parceiros | `parceiros/02-neogeo-parcerias-estrategicas.png` | Parcerias estratégicas | `.split-media` |
| Parceiros | `parceiros/03-neogeo-groundradar-conceitual.png` | Faixa Groundradar | `.feature-band .bg-visual` + `.bg-photo` |
| Parceiros | `parceiros/04-neogeo-contato-desafio.png` | CTA final | `.page-cta-media` |
| Blog | `blog/01-neogeo-blog.png` | Hero | `.bg-visual` + `.bg-photo` |
| Blog | `blog/02-neogeo-conhecimento-aplicado.png` | Do campo para o conteúdo | `.feature-band .bg-visual` + `.bg-photo` |
| Blog | `blog/03-neogeo-contato-blog.png` | CTA final | `.page-cta-media` |
| Contato | `contato/01-neogeo-pagina-contato.png` | Hero | `.bg-visual` + `.bg-photo` |

Total: **27 imagens** distribuídas em 8 páginas. Nenhuma imagem foi inserida nas 13 subpáginas de Geotecnologias e Aplicações.

### Ícones — nova linguagem sem fundo colorido

- **Homepage — “Como investigamos”**: removidos os 6 blocos `.geo-visual` (caixas pretas com sombra azul). Cada item agora exibe apenas ícone, título, linha divisória azul e descrição. O grid, os títulos, as descrições e a linha azul (`border-bottom: 2px solid var(--color-brand-blue)`) foram preservados.
- **Homepage — ícones explicativos**: `.geo-dot`, `.app-dot` e `.work-dot` deixaram de ter círculo/fundo; os SVGs são renderizados isolados em azul institucional (`--color-brand-blue`) sobre as seções claras. Tamanhos: 40 px (geotecnologias), 34 px (aplicações) e 40 px (como trabalhamos).
- **A Empresa — processo**: os 5 círculos cinza foram removidos; cada etapa recebeu um SVG branco (44 px) sobre o fundo escuro.
- **A Empresa — valores**: os 5 círculos cinza foram removidos; cada valor recebeu um SVG azul (32 px) sobre fundo branco.
- Origem dos desenhos: `assets/icons/*.svg`, reutilizados como SVG inline com `stroke="currentColor"` para herdar a cor do contexto sem alterar a geometria original.
- Elementos com outra função (numeração de etapas, botões, indicadores e ícones do footer) não foram alterados.

### Confirmação da homepage

- Caixas pretas e azuis de “Como investigamos” removidas.
- Linha azul divisória entre título e descrição preservada em todos os itens.
- Títulos e descrições originais integralmente preservados.
- Hero de abertura reservado ao vídeo institucional mantido intacto, assim como as 11 imagens aprovadas na rodada anterior.

### Placeholders preservados

- **A Empresa**: os 8 cards de fotografia da equipe (`.empresa-team-photo`) permanecem vazios — não há arquivos identificados para pessoas específicas.
- **Homepage**: `.intro-media` (fotografia da equipe) e `.home-hero-media` (vídeo) permanecem como estavam; slots de logotipos de clientes/parceiros seguem vazios.
- **SMS**: a seção **Sustentabilidade** permanece sem imagem, conforme decisão anterior; **Política de Álcool e Drogas** continua centralizada e sem imagem de fundo.
- **Blog**: `.featured-media` e os três `.post-media` permanecem vazios — não há artigos reais para associar.
- **Parceiros**: os 6 `.logo-box` de “Outros parceiros” permanecem como placeholders.
- **Subpáginas de Geotecnologias e Aplicações**: todos os placeholders seguem inalterados.

### Alterações técnicas

- `styles/pages.css`: novo `.bg-photo` (camada de foto com `opacity: 0.35`) e regras `.bg-visual.has-photo` / `.media-placeholder.has-photo` para ocultar as linhas decorativas quando há fotografia.
- `styles/home.css`: `.geo-card` editorial sem card branco; `.geo-dot`/`.app-dot`/`.work-dot` sem fundo e em azul; tamanhos de SVG 40/34/40 px; removida a regra `.geo-visual`.
- `styles/a-empresa.css`: `.empresa-processo` com `position: relative`, `isolation: isolate` e `overflow: hidden`; container em `z-index: 1`; ícones de processo e valores sem círculo, com `.icon-svg` dimensionado.
- `index.html`: remoção dos 6 `.geo-visual`.
- `a-empresa.html`: 4 imagens e 10 SVGs inline (5 processo + 5 valores).
- Demais páginas principais: imagens nos containers mapeados e classes `media-cover`/`has-photo`/`bg-photo` conforme a seção.
- `scripts/audit-site.ps1`: o guard de camada de fundo dos hubs passou a aceitar `class="bg-visual ..."` (variante com `has-photo`).

### Validação desta etapa

- `scripts/audit-site.ps1`: **0 problemas**, 3 avisos esperados (formulários `action="#"` em `contato.html`), 22 páginas.
- 27/27 imagens novas com caminho válido e carregamento confirmado (`naturalWidth` 1536, `naturalHeight` 1024).
- `scrollWidth == innerWidth` em 1440, 1920, 768, 390 e 375 px nas 9 páginas principais — sem rolagem horizontal.
- Verificação visual em headless Chrome (1440, 1920, 768 e 390 px): heróis, splits, faixas de fundo e CTAs com imagem visível, texto legível e recorte `cover` sem distorção.
- Nenhum arquivo das 13 subpáginas de Geotecnologias/Aplicações foi modificado.

## Pendências de conteúdo e integração

1. **Potássio** não possui descrição técnica na fonte; a página exibe “Descrição técnica em elaboração.”
2. **Investigação de áreas contaminadas** não possui copy dedicada na fonte; a página exibe o mesmo aviso.
3. A homepage já usa as 11 fotos definitivas em `assets/images/pagina inicial`; ainda faltam a foto da equipe (`.intro-media`), o vídeo do hero e os logotipos de parceiros/clientes. Os antigos cards `.geo-visual` foram removidos na Etapa 2.
4. Não há logotipos adicionais de clientes/parceiros além dos assets existentes.
5. Os formulários de contato e Ouvidoria ainda usam `action="#"` e precisam de endpoint/backend.
6. O Blog aguarda artigos reais.
7. O PDF do Código de Ética e Conduta não está no projeto; o acesso é feito por solicitação em `contato@ngg.com.br`.
8. As 11 fotos da homepage somam cerca de 28 MB (1,9–3,6 MB cada); recomenda-se otimização não destrutiva antes da publicação.

## Como executar

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\serve.ps1
```

Abrir: `http://127.0.0.1:4173/`

Para regenerar conteúdo e páginas:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\build-content-json.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\render-site.ps1
```
