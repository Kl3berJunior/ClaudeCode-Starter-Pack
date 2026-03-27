# Guia de Inicio e Uso do ClaudeCode-Starter-Pack

Este guia explica como pegar este starter pack, transformar isso em um workspace real e operar o Claude Code de forma consistente no dia a dia.

## 1. O que este pack entrega

O pack organiza o uso do Claude Code em dois niveis:

- `claudeCode-workspace/`: o workspace principal, com memoria, comandos customizados, configuracao local e contrato operacional.
- `claudeCode-workspace/repo/CLAUDE.md`: o template de `CLAUDE.md` para copiar para dentro de cada repositorio de codigo.

Na pratica, ele resolve estes problemas:

- cria um ponto de entrada claro para cada sessao
- separa memoria diaria de memoria duravel
- padroniza como o Claude deve agir no workspace e nos repos
- define comandos slash para rotina operacional
- incentiva uso de worktrees para trabalho paralelo limpo
- centraliza o uso de MCPs/plugins em um lugar canonico

## 2. Estrutura do pack

### Raiz deste repositorio

```text
ClaudeCode-Starter-Pack/
|-- README.md
|-- guia.md
`-- claudeCode-workspace/
    |-- .claude/
    |   |-- hooks/
    |   `-- commands/
    |-- .serena/
    |-- memory/
    |   `-- _session-state.json
    |-- repo/
    |   `-- CLAUDE.md
    |-- .gitignore
    |-- CLAUDE.md
    |-- HEARTBEAT.md
    |-- MEMORY.md
    |-- SOUL.md
    |-- TOOLS.md
    `-- USER.md
```

### O que cada arquivo faz

| Arquivo | Papel |
|---|---|
| `claudeCode-workspace/CLAUDE.md` | Contrato principal do workspace. E o primeiro arquivo que governa a sessao. |
| `claudeCode-workspace/SOUL.md` | Principios permanentes do fluxo. |
| `claudeCode-workspace/USER.md` | Contexto operacional do time ou da pessoa usuaria. |
| `claudeCode-workspace/TOOLS.md` | Caminhos, comandos e heuristicas de ferramentas. |
| `claudeCode-workspace/MEMORY.md` | Memoria duravel. So entra o que precisa sobreviver entre sessoes. |
| `claudeCode-workspace/HEARTBEAT.md` | Checklist curto de saude operacional. |
| `claudeCode-workspace/memory/` | Memoria diaria no formato `YYYY-MM-DD.md`. |
| `claudeCode-workspace/memory/_session-state.json` | Marcador local de abertura e fechamento da sessao. |
| `claudeCode-workspace/.claude/settings.json` | Permissoes e plugins habilitados. Fonte canonica dos MCPs. |
| `claudeCode-workspace/.claude/hooks/` | Hooks nativos do Claude Code para startup, guarda de prompt e encerramento. |
| `claudeCode-workspace/.claude/commands/` | Slash commands do workspace. |
| `claudeCode-workspace/.claude/agents/` | Subagentes especializados (review-deep, explain, agent-router, test-runner). |
| `claudeCode-workspace/Relatorios/` | Artefatos canonicos: backlog, status do supervisor, sessoes de agente. |
| `claudeCode-workspace/.serena/` | Configuracao local do Serena para navegacao semantica. |
| `claudeCode-workspace/repo/CLAUDE.md` | Template para o contrato local de cada repo de codigo. |

## 3. Antes de comecar

Voce vai precisar de:

- Claude Code instalado e funcionando no seu ambiente
- Git disponivel
- um diretorio que sera o seu workspace principal
- um ou mais repositorios de codigo para colocar dentro desse workspace

Importante:

- este pack nao deve guardar segredos, tokens ou senhas em arquivos versionados
- `.claude/settings.local.json` existe justamente para ajustes locais fora do versionamento
- `memory/`, `.wt/` e `.serena/memories/` estao no `.gitignore` — sao dados locais nao versionados
- `Relatorios/` e versionado — `task-backlog.md`, `supervisor-status.md` e `agent-sessions/` sao arquivos canonicos

## 4. Como instalar o pack em um workspace real

### Passo 1. Escolha a raiz do workspace

Escolha uma pasta que vai concentrar:

- os arquivos operacionais do Claude Code
- a memoria do workspace
- relatorios locais
- os repositorios principais de codigo

Exemplo:

```text
C:\Work\MeuWorkspace\
|-- .claude\
|-- .serena\
|-- memory\
|-- CLAUDE.md
|-- HEARTBEAT.md
|-- MEMORY.md
|-- SOUL.md
|-- TOOLS.md
|-- USER.md
`-- repo\
    |-- api\
    `-- web\
```

### Passo 2. Copie `claudeCode-workspace/` para a raiz escolhida

O objetivo e fazer com que o conteudo de `claudeCode-workspace/` vire a base do seu workspace real.

Exemplo em PowerShell:

```powershell
robocopy .\claudeCode-workspace C:\Work\MeuWorkspace /E
```

Observe que o importante e preservar tambem as pastas ocultas, como `.claude/` e `.serena/`.

### Passo 3. Coloque seus repositorios de codigo dentro da pasta `repo`

O contrato recomendado deste pack assume que os repos principais ficam dentro de uma pasta `repo/` na raiz do workspace. Isso deixa a estrutura mais previsivel, facilita documentacao em `TOOLS.md` e evita misturar arquivos operacionais do workspace com codigo de produto.

Exemplo:

```text
C:\Work\MeuWorkspace\
`-- repo\
    |-- api\
    |-- web\
    `-- mobile\
```

Se voce adotar outro caminho, registre isso explicitamente em `TOOLS.md`. Mas o padrao sugerido por este guia e `repo/<nome-do-repo>`.

### Passo 4. Copie o template de repo para cada repositorio

Para cada repositorio de codigo, copie `claudeCode-workspace/repo/CLAUDE.md` para a raiz do repo correspondente.

Exemplo:

```text
C:\Work\MeuWorkspace\repo\api\CLAUDE.md
C:\Work\MeuWorkspace\repo\web\CLAUDE.md
```

Esse arquivo e o contrato local do repo. O Claude deve respeita-lo sempre que estiver trabalhando naquele repositorio.

## 5. Configuracao inicial do workspace

Depois de copiar o pack, faca a configuracao abaixo.

### 5.1. Ajuste `CLAUDE.md` do workspace

Arquivo:

- `claudeCode-workspace/CLAUDE.md`

Troque o placeholder:

- `__WORKSPACE_ROOT__` pelo caminho real do seu workspace

Esse arquivo define:

- arquivos importados automaticamente
- startup obrigatorio
- regras de seguranca
- prioridade de MCPs
- politica de worktrees
- roteamento de modelos para subagentes

### 5.2. Preencha `USER.md`

Arquivo:

- `claudeCode-workspace/USER.md`

Coloque contexto util para o trabalho, por exemplo:

- linguagem principal dos repos
- ambiente de deploy
- horario do time
- politica de branch e PR
- regra de abertura e limpeza de worktrees

Nao coloque:

- tokens
- senhas
- chaves privadas

### 5.3. Preencha `TOOLS.md`

Arquivo:

- `claudeCode-workspace/TOOLS.md`

Esse arquivo deve virar sua referencia pratica do workspace. Registre:

- caminhos locais importantes
- comandos de build, test, lint e run por repo
- onde vivem os repos
- wrappers internos
- detalhes de runtime local

O proprio arquivo ja sugere um formato por repositorio:

```md
## Repo `api`

- path: `C:/Work/MeuWorkspace/repo/api`
- worktree-root: `.wt/api/`
- build: `npm run build`
- test: `npm test`
- lint: `npm run lint`
- publish: `n/a`
- run: `npm run dev`
- notes: `API principal do produto`
```

### 5.4. Revise `.claude/settings.json`

Arquivo:

- `claudeCode-workspace/.claude/settings.json`

No estado atual deste pack, ele:

- libera leitura, escrita, edicao, glob e grep
- habilita comandos basicos de bash para `git`, `ls` e `cat`
- registra hooks nativos de sessao:
  - `SessionStart`
  - `UserPromptSubmit`
  - `SessionEnd`
- habilita estes plugins:
  - `telegram@claude-plugins-official`
  - `serena@claude-plugins-official`
  - `playwright@claude-plugins-official`
  - `context7@claude-plugins-official`
  - `context-mode@context-mode`
  - `commit-commands@claude-plugins-official`

Se algum plugin nao fizer sentido no seu ambiente, ajuste aqui. O guia operacional do workspace assume que esse arquivo e a fonte canonica dos MCPs ativos.

### 5.5. Opcional: ajuste `.serena/project.yml`

Arquivo:

- `claudeCode-workspace/.serena/project.yml`

Ele ja vem pronto, mas com `languages: []`. Se voce quiser usar melhor o Serena com language servers, vale preencher as linguagens do projeto.

Exemplo:

```yaml
languages:
  - typescript
  - python
```

## 6. Configuracao inicial de cada repositorio

Em cada repo de codigo, ajuste o `CLAUDE.md` copiado do template.

### Placeholders que precisam ser trocados

- `__REPO_NAME__`
- `__BUILD_COMMAND__`
- `__TEST_COMMAND__`
- `__LINT_COMMAND__`
- `__WORKSPACE_ROOT__`

### Exemplo preenchido

```md
# CLAUDE.md - Repo `api`

Este arquivo governa como o Claude Code deve atuar neste repositorio.

## Validacao local

- build: `npm run build`
- test: `npm test`
- lint: `npm run lint`

## Relatorios

Artefatos deste repo vivem em:

- `C:/Work/MeuWorkspace/Relatorios/api/`
```

### O que esse arquivo garante

Ele faz o Claude:

- ler o contrato do repo antes de alterar codigo
- usar `serena` para mapear simbolos quando isso acelerar entendimento
- consultar `context7` antes de assumir comportamento de dependencia externa
- usar `playwright` quando a mudanca tocar UI ou navegacao
- validar o que foi alterado
- pedir confirmacao antes de publicar, fazer push ou mexer fora do ambiente local

## 7. Startup obrigatorio de cada sessao

O `CLAUDE.md` do workspace define um gate de sessao. No fluxo atual:

1. O hook `SessionStart` auto-inicializa a sessao.
2. O hook cria ou atualiza `memory/_session-state.json`.
3. Se o estado estiver invalido, o hook `UserPromptSubmit` bloqueia o prompt e exige `/startup`.
4. O comando `/startup` funciona como auditoria manual e reparo da sessao.
5. O Claude nao deve assumir contexto anterior sem verificar memoria, relatorio de sessao e heartbeat.

### O que fazer no primeiro dia

Se ainda nao existir memoria diaria, crie:

```text
memory/2026-03-26.md
```

ou use o comando:

```text
/daily-memory
```

O arquivo deve registrar:

- fatos do dia
- mudancas operacionais
- riscos encontrados
- links para artefatos gerados
- itens que talvez devam subir para `MEMORY.md`

## 8. Fluxo recomendado de uso no dia a dia

### Inicio da sessao

1. Abra o Claude Code na raiz do workspace.
2. Deixe o hook `SessionStart` auto-inicializar a sessao.
3. Se houver bloqueio de prompt ou duvida de contexto, rode `/startup`.
4. Confira o resumo retornado e o estado do workspace.
5. Se necessario, abra ou retome uma worktree.

### Durante o trabalho

Use as ferramentas conforme o tipo de tarefa:

- `serena`: para estrutura de codigo, simbolos, referencias e pontos de entrada
- `context7`: para documentacao atualizada de bibliotecas, SDKs e APIs externas
- `playwright`: para fluxos web, validacao funcional e regressao visual
- `context-mode`: para tarefas longas, com muitos arquivos ou continuidade de contexto
- `telegram`: para notificacoes e interacao remota, se estiver configurado
- `commit-commands`: para commits, push e abertura de PR via slash commands

Sempre que estiver mexendo em codigo:

- verifique se o branch atual esta limpo antes de comecar
- crie um branch dedicado antes de qualquer edicao usando prefixo convencional:
  - `git checkout -b feat/<objetivo>`
  - `git checkout -b fix/<objetivo>`
  - `git checkout -b chore/<objetivo>`
  - `git checkout -b refactor/<objetivo>`
  - `git checkout -b docs/<objetivo>`
- nunca commite em `main` ou `master`
- use formato convencional nas mensagens: `feat:`, `fix:`, `refactor:`, `chore:`, `docs:`
- respeite primeiro o `CLAUDE.md` do repo local
- valide o que alterou (testes, lint, build)
- nao reverta trabalho alheio
- nao faca push ou publicacao sem instrucao clara

### Pos-merge obrigatorio

Apos um PR ser mergeado:

1. Use `gh pr merge <numero> --merge` — sem `--delete-branch` (o GitHub apaga o remoto automaticamente via `delete_branch_on_merge=true`).
2. Volte para main e atualize:
   ```
   git checkout main
   git pull origin main
   ```
3. Delete o branch local (se ainda existir):
   ```
   git branch -d <branch>
   ```
4. Pode referencias remotas obsoletas:
   ```
   git remote prune origin
   ```

### Encerramento da sessao

1. Rode testes, linters e verifique que o projeto compila.
2. Rode `/close-session`.
3. Atualize a memoria diaria e o relatorio de sessao.
4. Promova para `MEMORY.md` apenas o que for realmente duravel.
5. Verifique se alguma worktree pode ser limpa.
6. Ao fechar o CLI, deixe o hook `SessionEnd` registrar o encerramento leve.

## 9. Slash commands incluidos no pack

Os comandos ficam em:

- `claudeCode-workspace/.claude/commands/`

### `/heartbeat`

Objetivo:

- verificar rapidamente a saude operacional do workspace

O que ele checa:

- task bloqueada sem dono claro
- relatorio critico vencido
- erro novo no supervisor
- memoria do dia atualizada
- worktree orfa ou sem objetivo claro
- worktree com mudancas sem task ou dono rastreavel
- worktree limpa ou encerrada pronta para limpeza

Se nada precisar de atencao, a resposta esperada e:

```text
HEARTBEAT_OK
```

### `/backlog`

Objetivo:

- listar e atualizar o backlog operacional

Arquivos usados:

- `Relatorios/Swarm/task-backlog.md`
- `Relatorios/Swarm/supervisor-status.md`

Se os arquivos nao existirem, o proprio fluxo do comando pode cria-los.

### `/daily-memory`

Objetivo:

- criar ou atualizar a memoria diaria do workspace

Fluxo esperado:

- verificar se o arquivo do dia existe
- criar se necessario
- registrar fatos, decisoes, riscos e links
- avaliar promocao para `MEMORY.md`

### `/startup`

Objetivo:

- auditar e reparar manualmente o estado da sessao

Fluxo esperado:

- ler memoria e relatorio mais recentes
- verificar `.claude/settings.json`
- verificar ou recriar `memory/_session-state.json`
- executar `/heartbeat`

### `/close-session`

Objetivo:

- fazer o fechamento rico da sessao antes de sair do Claude CLI

Fluxo esperado:

- atualizar memoria diaria
- atualizar `Relatorios/agent-sessions/YYYY-MM-DD-session.md`
- marcar `close_done=true` em `memory/_session-state.json`
- revisar pendencias e worktrees

### `/commit-commands:commit`

Objetivo:

- criar um commit git com mensagem gerada automaticamente a partir das mudancas staged

### `/commit-commands:commit-push-pr`

Objetivo:

- criar um commit, fazer push e abrir um pull request em sequencia

### `/commit-commands:clean_gone`

Objetivo:

- limpar branches locais marcadas como `[gone]` (deletadas no remoto)
- remove worktrees associadas antes de deletar a branch

### `/worktree <acao> [tipo] [nome] [branch]`

Objetivo:

- listar, criar, remover e limpar worktrees

Acoes previstas:

- `criar`
- `listar`
- `remover`
- `limpar`

O parametro `tipo` define o contexto da worktree:

- `workspace` (padrao): worktree do proprio workspace, para isolar config, docs ou experimentos
  - caminho: `.wt/workspace/<objetivo>`
  - comando: `git worktree add .wt/workspace/<objetivo> -b <branch>`
- `repo`: worktree de um repo interno em `repo/<nome>/` — sao git repos separados
  - caminho: `.wt/<repo>/<objetivo>`
  - comando: `git -C repo/<nome> worktree add ../../.wt/<repo>/<objetivo> -b <branch>`

Exemplos:

```text
/worktree criar workspace ajuste-config chore/ajuste-config
/worktree criar repo minha-api feat-login feat/login
```

## 10. Agentes incluidos no pack

Os agentes ficam em:

- `claudeCode-workspace/.claude/agents/`

Todos os agentes herdam automaticamente todos os MCPs habilitados no workspace (serena, context7, playwright, context-mode). Nao ha restricao de ferramentas — o modelo escolhido e a unica diferenca entre eles.

### `/review-deep <arquivo-ou-modulo>`

Usa:

- `claude-opus-4-6`

Quando usar:

- analise arquitetural
- acoplamento excessivo
- risco tecnico
- proposta de refatoracao

O agente nao modifica arquivos. Ele so analisa e reporta.

### `/explain <simbolo-ou-arquivo>`

Usa:

- `claude-sonnet-4-6`

Quando usar:

- para entender rapidamente o comportamento observavel de um trecho

O foco e:

- o que entra
- o que sai
- efeitos colaterais relevantes

### `/agent-router <tarefa>`

Usa:

- `claude-sonnet-4-6` como roteador — o proprio router roda em Sonnet e delega para o modelo adequado

Funcao:

- classificar a tarefa e acionar o modelo adequado

Heuristica atual:

- `opus`: arquitetura, refatoracao ampla, debugging com causa desconhecida
- `sonnet`: geracao de codigo, testes, explicacoes e tarefas com escopo claro
- `haiku`: operacoes mecanicas, glob, grep, rename, verificacoes simples

### `/test-runner <repo e cenario>`

Usa:

- `claude-sonnet-4-6`

Quando usar:

- criar testes de API em PowerShell para um repo
- criar testes de frontend em Playwright TypeScript
- executar testes existentes e reportar resultados

Convencao de arquivos:

- API: `tests/<repo-kebab>/<modulo>/test_<cenario>.ps1`
- Frontend: `tests/<repo-kebab>/<modulo>/<cenario>.spec.ts`

Se o fix tiver impacto visual, criar teste de API **e** teste Playwright correspondente.

## 11. Como usar worktrees do jeito certo

O pack trata worktree como mecanismo padrao para paralelo limpo e rastreavel.

### Dois tipos de worktree

**Tipo `workspace`** — para isolar trabalho no proprio workspace (config, docs, experimentos):

```text
.wt/workspace/<objetivo-ou-branch>
```

Exemplos:

```text
.wt/workspace/ajuste-config
.wt/workspace/docs-novo-fluxo
```

**Tipo `repo`** — para repos internos em `repo/` (cada um e um git repo separado):

```text
.wt/<repo-em-kebab-case>/<objetivo-ou-branch>
```

Exemplos:

```text
.wt/minha-api/feat-login-social
.wt/portal-web/fix-header-mobile
.wt/app-mobile/chore-upgrade-sdk
```

O branch associado deve seguir prefixo convencional: `feat/`, `fix/`, `chore/`, `refactor/`, `docs/`.

### Regras operacionais do pack

- auditar worktrees antes de criar novas
- reaproveitar worktree adequada antes de abrir outra
- registrar objetivo claro, branch e dono ou task
- pedir confirmacao antes de remover
- preferir `git worktree prune` para metadata orfa

### Comandos uteis

```bash
# Auditoria do workspace
git worktree list --porcelain

# Auditoria de repo interno
git -C repo/minha-api worktree list --porcelain

# Criar worktree do workspace
git worktree add .wt/workspace/ajuste-config -b chore/ajuste-config

# Criar worktree de repo interno (a partir da raiz do workspace)
git -C repo/minha-api worktree add ../../.wt/minha-api/feat-login-social -b feat/login-social

# Status de uma worktree
git -C .wt/minha-api/feat-login-social status --short --branch

# Remover worktree do workspace
git worktree remove .wt/workspace/ajuste-config && git worktree prune

# Remover worktree de repo interno
git -C repo/minha-api worktree remove ../../.wt/minha-api/feat-login-social
git -C repo/minha-api worktree prune
```

### Inventario minimo recomendado por worktree

- repo
- branch
- objetivo
- dono ou task
- data da ultima atividade

## 12. Onde cada tipo de informacao deve ir

Use esta regra para manter o workspace limpo:

| Tipo de informacao | Lugar certo |
|---|---|
| fato, risco ou decisao do dia | `memory/YYYY-MM-DD.md` |
| contrato ou decisao duravel | `MEMORY.md` |
| comando, caminho ou ferramenta | `TOOLS.md` |
| preferencia de time ou operacao | `USER.md` |
| principio permanente | `SOUL.md` |
| checklist de saude | `HEARTBEAT.md` |
| backlog operacional | `Relatorios/Swarm/task-backlog.md` |
| status resumido do supervisor | `Relatorios/Swarm/supervisor-status.md` |
| resumo de sessao de agente | `Relatorios/agent-sessions/YYYY-MM-DD-session.md` |
| artefatos por repositorio | `Relatorios/__REPO_NAME__/` |

Regra pratica:

- se vale lembrar hoje, escreva em `memory/`
- se precisa sobreviver por semanas ou meses, promova para `MEMORY.md`
- se ajuda a executar tarefas futuras, registre em `TOOLS.md`

## 13. Boas praticas para usar o pack bem

- mantenha `CLAUDE.md` do workspace curto, normativo e atualizado
- mantenha `CLAUDE.md` de cada repo focado no que muda por repositorio
- use `USER.md` para contexto operacional, nao para segredos
- trate `.claude/settings.json` como fonte canonica dos plugins ativos
- registre a memoria no mesmo dia, nao depois
- valide antes de concluir
- documente caminhos reais e comandos reais, nao placeholders esquecidos
- use worktrees para reduzir mistura de contexto entre tarefas

## 14. Erros comuns ao adotar o pack

### Copiar sem as pastas ocultas

Se `.claude/` e `.serena/` nao forem copiadas, voce perde:

- configuracao dos plugins
- slash commands
- agentes
- configuracao do Serena

### Esquecer placeholders

Se `__WORKSPACE_ROOT__`, `__REPO_NAME__` ou os comandos de validacao ficarem sem ajuste, o guia operacional passa a mentir para o Claude.

### Usar o workspace sem `CLAUDE.md` nos repos

Sem o contrato local do repo, o Claude perde contexto importante de validacao e de limites especificos daquele projeto.

### Guardar coisa duravel so na memoria diaria

Se algo precisa sobreviver entre sessoes, promova para `MEMORY.md`. Senao a informacao se perde no historico diario.

### Abrir worktrees com nome inconsistente

Se cada worktree seguir um padrao diferente, a auditoria fica ruim. O pack usa dois subtipos:

```text
.wt/workspace/<objetivo>        # para trabalho no workspace
.wt/<repo>/<objetivo>           # para repos internos
```

Repos internos em `repo/` sao git repos separados e precisam de `git -C repo/<nome> worktree add` — nao use `git worktree add` diretamente para eles.

## 15. Checklist rapido de implantacao

Use esta lista para validar que a adocao ficou completa:

1. O conteudo de `claudeCode-workspace/` foi copiado para a raiz do workspace real.
2. `CLAUDE.md` do workspace teve `__WORKSPACE_ROOT__` substituido.
3. `USER.md` foi preenchido sem segredos.
4. `TOOLS.md` foi preenchido com caminhos e comandos reais.
5. `.claude/settings.json` foi revisado.
6. `.serena/project.yml` foi ajustado se voce quiser language servers.
7. Cada repo de codigo recebeu seu proprio `CLAUDE.md`.
8. Os placeholders de cada repo foram substituidos.
9. Os hooks de sessao foram revisados em `.claude/settings.json`.
10. O startup obrigatorio foi entendido: hooks + `/startup` como fallback manual.
11. O time combinou uma convencao unica para worktrees.

## 16. Exemplo de rotina completa

Um uso tipico pode ser assim:

1. Abrir `C:\Work\MeuWorkspace` no Claude Code.
2. Deixar o hook `SessionStart` inicializar a sessao.
3. Se necessario, rodar `/startup`.
4. Escolher o repo `api`.
5. Se necessario, abrir `.wt/api/feat-ajuste-login`.
6. Trabalhar respeitando `repo/api/CLAUDE.md`.
7. Rodar build, test e lint do repo.
8. Rodar `/close-session`.
9. Promover alguma decisao duravel para `MEMORY.md`.
10. Avaliar limpeza da worktree se a tarefa tiver terminado.

## 17. Resumo final

Se voce quiser simplificar a adocao, pense assim:

- `claudeCode-workspace/` vira a raiz operacional do seu workspace
- `claudeCode-workspace/repo/CLAUDE.md` vai para cada repo de codigo dentro de `repo/`
- `CLAUDE.md` dita o comportamento
- `memory/` registra o dia
- `MEMORY.md` guarda o que fica
- `.claude/settings.json` define os plugins ativos
- `.wt/` organiza o paralelo

Com isso, o starter pack deixa de ser apenas um conjunto de arquivos e passa a ser um sistema de trabalho repetivel, auditavel e facil de retomar.
