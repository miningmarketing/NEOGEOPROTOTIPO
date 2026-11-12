# ELEMENTOR-MIGRATION.md — Projeto Neogeo

Documento vivo de apoio ao desenvolvimento progressivo do site e à futura migração para **WordPress + Elementor Pro** (ou tema personalizado).

> **Status inicial:** análise de materiais concluída; nenhuma página desenvolvida ainda (aguardando indicação explícita da primeira página).

## 1. Materiais de referência analisados

### `/referências`
- **`HOMEPAGE.png`** — referência visual da página inicial (lida/analisada).
  - Estrutura observada: topo com navegação; hero com texto institucional forte e destaque tipográfico em bloco escuro; seções alternadas texto/imagem com placeholders escuros; blocos “Como investigamos” (geotecnologias em grid/cards alternados), “Onde aplicamos” (áreas em cards com ícones circulares), “Como trabalhamos” (etapas/processo), “P&D” em faixa escura, “Parceiros”, CTA final “O que o seu projeto precisa investigar?” e rodapé institucional.
  - Linguagem visual: base clara (cinza/branco), faixas escuras (navy/preto) para contraste, botões verdes em pílula, tipografia sem serifa com forte hierarquia, grandes respiros, composições editoriais e placeholders de imagem retangulares.
- **`A EMPRESA.png`** — referência visual da página A Empresa (lida/analisada via visualização reduzida; arquivo original preservado, 1515 KB).
  - Estrutura observada: hero “A Neogeo” + subtítulo técnico; bloco escuro com cards “pergunta que precisa ser respondida”; seção “Experiência construída em campo” com CTA; métricas (+350 projetos, +9.950 km, +70 barragens) e atuação na América Latina com mapa; processo “Do planejamento à interpretação” em diagrama/etapas sobre fundo escuro; Missão/Visão/Valores em colunas; equipe em grid de cards com foto/cargo; presença/mapa de Belo Horizonte; clientes; CTA final e rodapé.
  - Reforça a mesma identidade: navy/preto + cinza claro + verde de ação, cards arredondados em áreas escuras, ritmo editorial, uso de dados/prova institucional.

### `/copy`
- **`Copys.docx`** — documento com checklist, sitemap, menu e blocos de copy (lido/analisado por extração de texto do DOCX).
  - **Estrutura de navegação/sitemap identificada:** Início, A Empresa, Geotecnologias (com subpáginas: métodos elétricos/eletromagnéticos, métodos sísmicos, métodos potenciais, radar e investigação de alta resolução, levantamentos aéreos com drones, perfilagem geofísica), Aplicações/Soluções (Geotecnia, Exploração Mineral, Engenharia, Hidrogeologia, Arqueologia, Monitoramento), P&D, SMS, Parceiros, Blog (modelo de artigo), Contato.
  - **Conteúdo identificado no documento:** copy da Home por blocos (abertura/posicionamento, empresa, geotecnologias, aplicações, diferenciais, P&D, parceiros, contato), copy da A Empresa, página Geotecnologias (abertura, intro, blocos por família de métodos, integração, como a tecnologia entra no projeto, CTA) + descrições detalhadas de métodos/perfis/geotecnologias disponíveis, descrições de aplicações (geotecnia, engenharia, hidrogeologia, monitoramento, microssísmico etc., conforme extraído), P&D (incl. GEOTRACK, monitoramento, ciência/publicações), SMS, Parceiros, Blog e Contato/Ouvidoria.
  - **Observação:** o documento também contém checklist de insumos/aprovações e etapas de projeto; esses trechos orientam processo, mas não são copy de página pública. Na implementação de cada página, usar **apenas os textos/blocos correspondentes à página solicitada**.

## 2. Identidade visual e direção de arte (síntese inicial)

- **Tom:** institucional técnico, sofisticado, contemporâneo, confiável; geofísica aplicada a decisões de projeto.
- **Paleta inferida:** fundos claros (cinza muito claro/branco), superfícies escuras (navy/preto) para contraste e autoridade, acento verde para CTAs/botões primários, texto escuro sobre claro e branco sobre escuro. Valores exatos a calibrar na primeira página/ajustes.
- **Tipografia:** sem serifa, hierarquia forte (títulos grandes/editoriais, labels em caixa alta em alguns contextos, corpo legível). Família exata não especificada nas imagens; tokens usam fallback seguro até definição.
- **Componentes visuais recorrentes:** header com logo + menu horizontal; botões pill verdes; cards/seções com cantos arredondados; grids alternados texto-imagem; placeholders/imagens de forte presença; ícones circulares em aplicações; métricas de destaque; diagrama/etapas de processo; blocos de CTA com formulário/ação; rodapé com endereço, contatos, canais e copyright.
- **Ritmo:** seções amplas, bom respiro, alternância claro/escuro, conteúdo orientado por objetivo e prova técnica.

## 3. Arquitetura técnica inicial (preparada, sem páginas)

Estrutura criada para organização progressiva e futura migração:

```text
/assets
  /images
  /icons
/components        (componentes reutilizáveis; vazio por enquanto)
/styles
  tokens.css       (design tokens globais iniciais)
/docs              (documentação auxiliar, se necessário)
/scripts           (utilitários/animações, quando necessário)
ELEMENTOR-MIGRATION.md
/referências       (originais preservados)
/copy              (original preservado)
```

- **`styles/tokens.css`:** variáveis CSS para cores, tipografia, espaçamentos, raios, sombras, transições, breakpoints e preferência de movimento reduzido. Devem ser refinadas conforme aprovação visual das páginas.
- **Princípios:** HTML semântico, CSS organizado, conteúdo separado da apresentação, seções independentes compatíveis com Containers Flexbox/Grid do Elementor, responsividade real (desktop/notebook/tablet/mobile), animações sutis e performáticas, dependências mínimas.

## 4. Páginas desenvolvidas até o momento

- **Início / Home (`index.html`)** — versão 2 (redesign fiel à referência `HOMEPAGE.png`), aguardando revisão/aprovação visual e de conteúdo.
  - Composição da referência reproduzida: header navy full-width com logotipo negativo; faixa hero cinza full-width; bloco preto + parágrafo + caixa navy sobreposta; seção “Experiência em campo” com títulos bicoloridos e placeholders cinza; cards de geotecnologias em 3 colunas com moldura azul deslocada; aplicações em 2 colunas com ícones circulares; “Como trabalhamos” com mídia preta e grid de etapas; P&D em fundo preto com badge azul; parceiros e clientes centralizados com faixa branca de logos; CTA final em duas colunas; rodapé cinza com botões verdes em pílula.
  - Arquivos principais: `index.html`, `styles/global.css`, `styles/home.css`, `scripts/main.js`, `styles/tokens.css`.
  - Navegação: links do menu apontam para páginas ainda não criadas (`#` com `aria-disabled="true"`), mantendo estrutura do sitemap sem antecipar desenvolvimento. Item "Início" ativo.

### Páginas principais entregues (v1 — protótipo)

- `index.html` — Início
- `a-empresa.html` — A Empresa
- `geotecnologias.html` — Geotecnologias (hub com links para as 6 subpáginas de métodos)
- `solucoes.html` — Aplicações (hub com links para as 7 subpáginas de aplicação)
- `pesquisa-desenvolvimento.html` — P&D
- `sms.html` — Segurança, Meio Ambiente e Saúde
- `parceiros.html` — Parceiros
- `blog.html` — Blog (com placeholders de artigos)
- `contato.html` — Contato + Ouvidoria

**Base compartilhada:** `styles/global.css` (reset, tipografia, container), `styles/home.css` (header navy, footer, botões e estilos da Home) e `styles/pages.css` (heróis internos, splits, cards, etapas, estatísticas, formulários, blog e CTA). Todas as páginas usam o mesmo header/footer e o script `scripts/main.js` para o menu mobile.

**Menu:** os rótulos foram atualizados para **Geotecnologias** e **Aplicações** em todas as páginas (home, páginas principais e subpáginas), substituindo “Tecnologias” e “Soluções”.

**Subpáginas:** as 13 subpáginas de Geotecnologias e Aplicações estão desenvolvidas, com detalhamento técnico de cada método e de cada aplicação.

### Estrutura resumida das páginas internas

- **A Empresa:** hero solo (título + textos institucionais); faixa navy com dois cards conceito; atuação (split texto/mídia + CTA); números (3 estatísticas + mapa/placeholder + CTA); processo em 5 etapas sobre navy; Missão/Visão/Valores em 3 colunas; time em navy com grid de fotos; presença (split + mapa); clientes (logos); CTA final.
- **Geotecnologias:** hero com mídia; introdução; 6 seções de métodos (elétricos, sísmicos, potenciais, radar, drones, perfilagem) em splits alternados com listas de métodos; integração multimétodo em navy; processo em 5 etapas; CTA.
- **Aplicações/Soluções:** hero; introdução; 7 áreas de aplicação em splits alternados com listas (Geotecnia, Exploração Mineral, Engenharia, Hidrogeologia, Arqueologia, Hidrossedimentologia, Monitoramento); abordagem integrada em navy; processo em 5 etapas; CTA.
- **P&D:** hero; P&D na prática; 4 cards do que é desenvolvido; GEOTRACK em fundo preto com lista de parâmetros; monitoramento microssísmico em 5 etapas; ciência e conhecimento; publicações (2); CTA.
- **SMS:** hero; compromisso com lista de diretrizes; 4 pilares em cards; responsabilidade compartilhada em navy; SMS na operação; sustentabilidade; política de álcool e drogas; ética/ouvidoria em navy; CTA.
- **Parceiros:** hero; rede; Groundradar em split com lista; outros parceiros (grid de logos); parcerias na prática (3 cards); CTA.
- **Blog:** hero; destaque (card grande com placeholders); publicações recentes (3 cards); conhecimento aplicado; CTA.
- **Contato:** hero solo; formulário comercial + canais diretos; localização com mapa; bloco “comece pelo problema”; Ouvidoria com formulário próprio.

### Modelo padrão de subpáginas (Geotecnologias e Aplicações)

As 13 subpáginas foram geradas a partir de um único template (`scripts/build-subpages.ps1`), garantindo consistência visual e de conteúdo:

1. **Hero:** breadcrumb da área, título, lead e CTA “Quero falar sobre meu projeto” + mídia placeholder.
2. **Visão geral:** texto de contexto em split com mídia.
3. **Escopo:** lista de métodos/tecnologias/aplicações em tags.
4. **Detalhamento:** uma subseção (`h3` + parágrafos) para cada método ou aplicação listado no escopo, com o texto explicativo correspondente da copy. Em Geotecnologias, cobre todos os métodos elétricos/eletromagnéticos, sísmicos, potenciais, tecnologias de radar, recursos de drones e perfis de poço; em Aplicações, cobre cada contexto de geotecnia (8), exploração mineral (14), engenharia (4), hidrogeologia (7), arqueologia (4), hidrossedimentologia (4) e monitoramento (3).
5. **Como conduzimos:** processo em 5 etapas (objetivo → estratégia → campo → processamento/interpretação → entrega).
6. **Continue explorando:** 3 cards com outras subpáginas da mesma área.
7. **CTA final** + header/footer compartilhados.

**Geração e conteúdo:** os textos ficam em `scripts/geo-data.json` e `scripts/sol-data.json` (UTF-8); o layout em `scripts/subpage-template.html`; o gerador `scripts/build-subpages.ps1` lê os dois arquivos como UTF-8 e grava as páginas sem dupla codificação. O script `scripts/update-menu.ps1` padroniza os rótulos do menu e `scripts/validate.ps1` verifica menu, acentos, links internos, contagem de detalhamentos e HTTP.

**Geotecnologias (`/geotecnologias/`):** `metodos-eletricos-e-eletromagneticos.html`, `metodos-sismicos.html`, `metodos-potenciais.html`, `radar-e-investigacao-de-alta-resolucao.html`, `levantamentos-aereos-com-drones.html`, `perfilagem-geofisica.html`.

**Aplicações (`/solucoes/`):** `geotecnia.html`, `exploracao-mineral.html`, `engenharia.html`, `hidrogeologia.html`, `arqueologia.html`, `hidrossedimentologia.html`, `monitoramento.html`.

**Botões dos hubs corrigidos conforme a copy:** cada seção das páginas Geotecnologias e Aplicações aponta para sua subpágina específica, com o texto de CTA correspondente (ex.: “Quero conhecer os métodos sísmicos”, “Quero conhecer as aplicações para Geotecnia”).

**Mapeamento Elementor (subpáginas):** o template inteiro pode ser salvo como Template de Página no Elementor e reutilizado; hero, visão geral, escopo, detalhamento, etapas, cards relacionados e CTA são Containers reutilizáveis. O detalhamento pode usar um Loop Grid ou Containers repetidos (título + Text Editor), com o conteúdo de cada método/aplicação editável.

**Mapeamento Elementor (páginas internas):** heróis e faixas → Containers; textos → Heading/Text Editor; listas → Icon List ou Text Editor; cards/estatísticas/etapas → Containers aninhados ou Loop Grid; formulários → Form; mapas → widget de mapa/embed; header/footer → Theme Builder. Componentes com comportamento próprio (menu mobile, formulários, futuros filtros do blog) exigirão configuração no Elementor ou pequeno código custom.

## 5. Estrutura das seções por página

### Home / Início (`index.html`) — Blocos 1–9 (copy)
1. **Header (global):** logo (`Logotipo_Neogeo_Principal.png`), navegação principal (Início, A Empresa, Geotecnologias, Aplicações, P&D, SMS, Parceiros, Blog, Contato), menu mobile com toggle JS.
2. **Hero / Posicionamento (Blocos 1-2):** grid visual + texto. Mensagem “A superfície mostra apenas parte do cenário.”, parágrafo de posicionamento (copy), destaque tipográfico “Seu projeto começa com o conhecimento da subsuperfície.” em bloco navy. Placeholder de mídia.
3. **A Empresa — resumo (Bloco 3):** “Experiência em campo.” (com placeholder + texto “Desde 2010...”) e “Conhecimento para interpretar.” (texto institucional). CTA “Quero conhecer a Neogeo”.
4. **Geotecnologias / Como investigamos (Bloco 4):** eyebrow “Como investigamos”, título, CTA “Quero explorar as geotecnologias”, grid de 6 itens (Métodos elétricos e eletromagnéticos, Métodos sísmicos, Métodos potenciais, Radar e investigação de alta resolução, Levantamentos aéreos com drones, Perfilagem geofísica) com texto + placeholder.
5. **Aplicações / Onde aplicamos (Bloco 5):** eyebrow, título, texto introdutório, grid de 6 cards (Geotecnia, Exploração Mineral, Engenharia, Hidrogeologia, Arqueologia, Monitoramento) com ícone circular placeholder e descrições, CTA “Quero conhecer as aplicações”.
6. **Diferenciais / Como trabalhamos (Bloco 6):** eyebrow, título, 5 etapas em blocos alternados texto/mídia: Investigação orientada pelo seu objetivo; Controle de qualidade nas etapas técnicas; Conhecimento de diferentes especialidades; Segurança e responsabilidade na operação; Resultados integrados para seu objetivo.
7. **P&D (Bloco 7):** faixa escura (navy), eyebrow “P&D”, título, 2 parágrafos incluindo GEOTRACK, CTA “Quero conhecer o P&D”.
8. **Parceiros (Bloco 8):** título “Conhecimento e tecnologia em parceria”, texto, área placeholder para logotipos `[Logotipos de parceiros]`.
9. **Contato / CTA final (Bloco 9):** título “O que o seu projeto precisa investigar?”, 2 parágrafos, painel escuro com CTA “Falar sobre meu projeto”.
10. **Footer (global):** logo, endereço, botões “Fale conosco” e “Ouvidoria”, telefone/e-mail, placeholders de redes sociais, copyright.

**Observações:** imagens da Home no Figma são placeholders escuros; implementados como `.placeholder-media` até recebimento de assets reais. Pequenos ajustes de redação de CTA/artefatos de extração tratados com cautela para manter fidelidade ao sentido da copy. Seção “Clientes da Neogeo” vista no layout de referência não consta como bloco de copy da Home no documento; mantida fora até orientação.

## 6. Componentes reutilizáveis

Candidatos identificados nas referências/copy (a implementar somente quando necessário às páginas solicitadas):
- Header/navegação (com menu e submenus conforme sitemap)
- Footer institucional (endereço, contatos, redes, canais, copyright)
- Botão primário (CTA verde, pill) e variações
- Hero institucional / hero de página interna
- Bloco texto + imagem (alternado)
- Card de método/geotecnologia
- Card de aplicação/solução (ícone + título + descrição)
- Etapas de processo (“como trabalhamos”)
- Bloco de métricas/prova
- Bloco Missão/Visão/Valores
- Card de equipe
- Seção de parceiros/clientes (logos)
- Bloco CTA final
- Formulários (Contato/Ouvidoria) — exigirão configuração no WordPress/Elementor

## 7. Cores e fontes utilizadas

- **Atualizadas em `styles/tokens.css`** conforme diretrizes fornecidas:
  - **Fonte:** `Roboto` carregada via Google Fonts (`@import` em `styles/tokens.css`) para uso no CSS (`--font-family-base`, `--font-family-heading`).
  - **Paleta oficial:**
    - `#227DC2` — `--color-brand-blue` (textos e fundos)
    - `#13355E` — `--color-brand-navy` (textos e fundos)
    - `#F5F5F7` — `--color-brand-light` (textos e fundos)
    - `#555555` — `--color-text-gray` (textos)
    - `#A2AAAD` — `--color-text-silver` (textos)
    - `#5CB85C` — `--color-button` / `--button-bg` (**somente botões**)
    - `#D9534F` — `--color-negative` / `--color-indicator-negative` (**somente indicativos negativos**)
  - **Regras de uso:** `#5CB85C` restrito a componentes de botão; `#D9534F` restrito a indicativos negativos/status de erro. Demais cores podem ser aplicadas em textos e fundos conforme a hierarquia/composição.
- **Pendência:** calibrar aplicação fina por seção (contraste, pesos, hierarquia e variações de hover) durante o desenvolvimento das páginas, respeitando as referências visuais.

## 8. Regras responsivas

- Breakpoints de referência: 640 / 768 / 1024 / 1280 px.
- Abordagem: base mobile com ajustes progressivos em `768px`, `1024px`, `1280px`; adaptação real de hierarquia, tipografia, grids, imagens, navegação e CTAs.
- Evitar cortes, sobreposição e rolagem horizontal; preservar identidade em todas as resoluções.
- **Home (implementado):**
  - **Mobile (<768px):** header sticky com menu hambúrguer (JS), nav colapsada; seções em coluna única; CTAs full/auto conforme contexto; grids (geotecnologias, aplicações, etapas) empilhados.
  - **Tablet (>=768px):** grids de aplicações e geotecnologias em 2 colunas.
  - **Desktop (>=1024px):** nav horizontal, hero em 2 colunas, intro empresa em 2 colunas, geotecnologias/etapas alternadas texto-mídia em 2 colunas, aplicações em 3 colunas, P&D e CTA final em 2 colunas, footer em 3 colunas.
  - **Ajustes finos pendentes:** validar proporções exatas de hero/cards/imagens e comportamento do menu conforme feedback visual.

## 9. Animações e interações

- Tokens de transição definidos (`150/250/400ms`) e respeito a `prefers-reduced-motion: reduce`.
- Diretriz: microinterações sutis, fluidas, compatíveis com mobile e viáveis no WordPress/Elementor (preferir CSS para efeitos simples).
- _Interações específicas serão registradas por página._

## 10. Assets necessários

- Originais preservados: `referências/HOMEPAGE.png`, `referências/A EMPRESA.png`, `copy/Copys.docx`.
- **Logotipos inseridos em assets (identificados):**
  - `assets/images/Logotipo_Neogeo_Principal.png`
  - `assets/images/Logotipo_Neogeo_Positivo.png`
  - `assets/images/Logotipo_Neogeo_Negativo.png`
  - `assets/images/Logotipo_Neogeo_Tons_de_Cinza.png`
- A levantar durante o desenvolvimento: logo em formato editável/SVG (se disponível), imagens reais de campo/equipe/projetos, ícones, logos de parceiros/clientes, mapas, selos/prêmios, imagens de blog (conforme checklist/copy).
- _Lista detalhada por página será atualizada conforme solicitações._

## 11. Mapeamento de seções para widgets do Elementor

Diretriz geral:
- Seções -> Containers (Flexbox/Grid)
- Títulos/textos -> Heading/Text Editor
- Botões -> Button
- Imagens -> Image
- Cards/grids -> Loop/Grid/Containers aninhados
- Formulários -> Form
- Menus/rodapé -> Header/Footer do Theme Builder ou widgets nativos

### Home (mapeamento preliminar)
- **Header:** Theme Builder Header; Container flex (logo + nav menu). Menu hambúrguer/off-canvas no mobile (widget Nav Menu / Toggle).
- **Hero:** Container 2 colunas (imagem + conteúdo/texto + caixa de destaque navy).
- **Empresa resumo:** Container 2 colunas com Heading, Image, Text Editor e Button.
- **Geotecnologias:** Heading + Button + Grid/Containers repetidos (texto + imagem) para 6 itens.
- **Aplicações:** Heading + Text + Grid de 6 cards (ícone/imagem + heading + texto) + Button.
- **Como trabalhamos:** 5 blocos alternados em Containers 2 colunas.
- **P&D:** Container fundo navy, 2 colunas (título + textos/CTA).
- **Parceiros:** Heading + Text + galeria/grid de logos.
- **CTA final:** Container 2 colunas (texto + painel/CTA).
- **Footer:** Theme Builder Footer; Containers para marca, endereço/ações, contatos/redes e copyright. Botões/links configuráveis.

## 12. Elementos que exigirão código personalizado

- Possíveis candidatos (a confirmar): navegação avançada/submenus complexos, animações específicas, diagramas/processos customizados, mapas interativos, comportamentos de blog/filtros, integrações de formulário/CRM, otimizações de desempenho.
- _Nenhum implementado até o momento._

## 13. Observações para futura conversão em tema WordPress

- Manter seções modulares e classes/estrutura reproduzíveis no Elementor.
- Centralizar estilos em tokens/globais para mapear em Site Settings do Elementor.
- Separar conteúdo editável de decoração/estrutura quando possível.
- Evitar dependências JS desnecessárias; documentar qualquer script custom.
- Preservar semântica, acessibilidade e performance.

## 14. Pendências / arquivos ausentes ou ilegíveis

- **Nenhum arquivo ausente ou ilegível:** as pastas `/referências` e `/copy` foram localizadas e seus conteúdos analisados.
- **Limitações da análise:** `A EMPRESA.png` tem 1515 KB (original preservado) e foi analisado por descrição visual derivada de visualização reduzida; detalhes finos (valores exatos de cor, fonte, espaçamentos em px) podem exigir calibração na implementação. `Copys.docx` foi extraído via texto do XML interno (legível); formatação rica/tabelas/eventuais elementos não textuais podem não estar totalmente representados na extração — a base textual está compreendida.
- **Insumos ainda dependentes do cliente (conforme checklist do documento):** validações de estrutura/prioridades, materiais técnicos completos por tecnologia/solução, lista definitiva de parceiros e logos, definição de P&D/SMS, contatos/redes finais, responsável por aprovações, fotos próprias autorizadas, e conteúdos para áreas marcadas como `[INSERIR ...]` no copy.
