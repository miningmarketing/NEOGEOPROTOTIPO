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

## Pendências de conteúdo e integração

1. **Potássio** não possui descrição técnica na fonte; a página exibe “Descrição técnica em elaboração.”
2. **Investigação de áreas contaminadas** não possui copy dedicada na fonte; a página exibe o mesmo aviso.
3. Não há fotos reais de campo, equipe ou projetos; os espaços visuais usam placeholders neutros.
4. Não há logotipos adicionais de clientes/parceiros além dos assets existentes.
5. Os formulários de contato e Ouvidoria ainda usam `action="#"` e precisam de endpoint/backend.
6. O Blog aguarda artigos reais.
7. O PDF do Código de Ética e Conduta não está no projeto; o acesso é feito por solicitação em `contato@ngg.com.br`.

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
