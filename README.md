# ClaudeCode-Starter-Pack - Resumo

## O que e

Template de workspace para Claude Code com contrato operacional, memoria, MCPs e gestao de worktrees.

O pack tem duas partes:

- `claudeCode-workspace/` - workspace principal
- `claudeCode-workspace/repo/CLAUDE.md` - template para cada repositorio

---

## Estrutura de arquivos

```text
ClaudeCode-Starter-Pack/
|-- scripts/
|   `-- sync-starter-pack-to-workspace.ps1   # Atualiza um workspace real a partir do starter pack local
`-- claudeCode-workspace/
    |-- .claude/
    |   |-- settings.json            # Permissoes locais e MCPs/plugins habilitados
    |   |-- settings.local.json      # Ajustes pessoais locais, fora do versionamento
    |   |-- agents/
    |   |   |-- review-deep.md       # Agente Opus: analise arquitetural profunda
    |   |   |-- explain.md           # Agente Sonnet: explicacao concisa de simbolos e arquivos
    |   |   |-- agent-router.md      # Agente Sonnet: classifica e delega por contexto operacional
    |   |   `-- test-runner.md       # Agente Sonnet: criacao e execucao de testes (PowerShell + Playwright)
    |   `-- commands/
    |       |-- backlog.md           # Slash command para listar e atualizar backlog operacional
    |       |-- close-session.md     # Slash command para fechamento rico da sessao
    |       |-- daily-memory.md      # Slash command para registrar memoria diaria
    |       |-- delegate.md          # Slash command para internalizar issue/PR no backlog
    |       |-- gh-project.md        # Slash command para consultar GitHub Projects
    |       |-- heartbeat.md         # Slash command para checagem completa de saude operacional (7 itens)
    |       |-- startup.md           # Slash command para auditoria e reparo manual da sessao
    |       `-- worktree.md          # Slash command para auditar e operar worktrees (workspace e repo)
    |-- .serena/
    |   |-- .gitignore               # Ignora estado local do Serena dentro da pasta
    |   |-- project.yml              # Config principal do projeto Serena
    |   `-- project.local.yml        # Ajustes locais do Serena, quando usados
    |-- memory/
    |   `-- README.md                # Instrucao curta sobre memoria diaria
    |-- repo/
    |   `-- CLAUDE.md                # Template para copiar para dentro de cada repo de codigo
    |-- .gitignore
    |-- CLAUDE.md                    # Contrato operacional principal do workspace
    |-- HEARTBEAT.md                 # Checklist curto de saude operacional
    |-- MEMORY.md                    # Memoria duravel com contratos e decisoes persistentes
    |-- README.md                    # Guia rapido do workspace (estrutura, MCPs, comandos, fluxo)
    |-- SOUL.md                      # Principios permanentes do fluxo de trabalho
    |-- TOOLS.md                     # Comandos, caminhos, MCPs e padrao de worktrees
    `-- USER.md                      # Contexto operacional do time e preferencias locais
```

---

## Como funciona

O Claude Code usa o `CLAUDE.md` do workspace como ponto de entrada.

### Startup obrigatorio

```text
1. Ler memory/YYYY-MM-DD.md de hoje
2. Ler memory/YYYY-MM-DD.md de ontem, se existir
3. Ler .claude/settings.json
4. Executar /heartbeat
```

---

## Componentes

### `CLAUDE.md` do workspace

Define o contrato principal:

1. importa arquivos de apoio
2. define startup obrigatorio
3. estabelece regras de seguranca
4. orienta uso de MCPs
5. padroniza worktrees

### `SOUL.md`

Guarda os principios permanentes do fluxo.

### `USER.md`

Guarda contexto operacional do time, sem segredos.

### `TOOLS.md`

Centraliza comandos por repo, caminhos importantes, MCPs e worktrees.

### Memoria diaria - `memory/YYYY-MM-DD.md`

Registra fatos, riscos e decisoes do dia.

### Memoria duravel - `MEMORY.md`

Guarda contratos e decisoes que precisam sobreviver entre sessoes.

### `HEARTBEAT.md`

Checklist curto de saude operacional, incluindo auditoria leve de worktrees.

---

## Slash Commands

### Fluxo recomendado

| Etapa | Sequencia recomendada |
|---|---|
| Abertura | hooks -> `/startup` se necessario -> `/heartbeat` se houver risco |
| Triagem local | `/backlog` |
| Triagem GitHub | `/gh-project` -> `/delegate` -> `/backlog` |
| Execucao isolada | `/worktree` |
| Finalizacao de entrega | validar -> `/commit-commands:commit` ou `/commit-commands:commit-push-pr` com descricao rica |
| Limpeza pos-merge | atualizar `main` -> `/commit-commands:clean_gone` |
| Registro e fechamento | `/daily-memory` durante a sessao -> `/close-session` no fim |

### `/heartbeat`

Verifica estado operacional, bloqueios e sinais de worktrees com risco ou limpeza pendente.

### `/backlog`

Lista e atualiza tasks em `Relatorios/Swarm/task-backlog.md`.

### `/daily-memory`

Cria ou atualiza a memoria diaria e avalia promocao para `MEMORY.md`.

---

## Agentes (`.claude/agents/`)

Agentes sao subagentes especializados com modelo e ferramentas fixos. O Claude Code os invoca automaticamente por contexto ou diretamente via `/nome-do-agente`.

### `/review-deep <arquivo>`

Analise arquitetural profunda via **Opus**. Identifica problemas de design, acoplamento e risco. Propoe refatoracoes com localizacao exata. Nao modifica arquivos.

### `/explain <simbolo-ou-arquivo>`

Explicacao concisa do comportamento via **Sonnet**. Foco no que entra, o que sai e efeitos colaterais. Sem analise global.

### `/agent-router <tarefa>`

Roteador contextual via **Sonnet**. O proprio router roda em Sonnet, le o contexto minimo necessario do workspace e classifica a tarefa para delegar ao modelo adequado (Opus / Sonnet / Haiku). Suporta execucao paralela de partes independentes.

### `/test-runner <repo e cenario>`

Criacao e execucao de testes via **Sonnet**. Cobre testes de API em PowerShell (`tests/<repo>/<modulo>/test_<cenario>.ps1`) e testes de frontend em Playwright TypeScript (`tests/<repo>/<modulo>/<cenario>.spec.ts`). Reporta resultados com total de passou/falhou e proximos passos.

### Criterio de roteamento

| Modelo | Quando usar |
|---|---|
| Opus | Arquitetura, refatoracao cross-repo, debugging sem causa conhecida, decisoes que cruzam workspace, repos e supervisor |
| Sonnet | Codigo, testes, docs, exploracao com contexto identificavel, ajustes no proprio workspace |
| Haiku | Glob, grep, rename, formatacao e verificacoes realmente mecanicas |

---

## `.claude/settings.json`

Define permissoes locais e os MCPs/plugins habilitados no workspace.

MCPs atuais:

- `serena`
- `context7`
- `playwright`
- `telegram`
- `context-mode`
- `commit-commands`

---

## `.gitignore`

Ignora configuracoes locais, diarios de memoria, segredos locais e `.wt/`.

`Relatorios/` e versionado — `task-backlog.md`, `supervisor-status.md` e `agent-sessions/` sao arquivos canonicos do workspace.

`memory/` e ignorado — diarios operacionais sao locais e nao devem ser versionados no template.

---

## `claudeCode-workspace/repo/CLAUDE.md`

Template que governa o comportamento do Claude dentro de cada repositorio, com regras minimas, comandos de validacao e prioridade de ferramentas.

---

## Worktrees

Worktrees sao o mecanismo padrao para isolamento e paralelo limpo.

Convencao:

- raiz em `.wt/`
- dois subtipos:
  - `workspace`: `.wt/workspace/<objetivo-ou-branch>` — para isolar trabalho no proprio workspace
  - `repo`: `.wt/<repo-em-kebab-case>/<objetivo-ou-branch>` — para repos internos em `repo/` (git repos separados)
- prefixo de branch: `feat/`, `fix/`, `chore/`, `refactor/`, `docs/`

Regras:

- fora do diretorio atual, preferir `git -C <path> ...` em vez de `cd <path> && git ...` para respeitar `Bash(git:*)`
- auditar antes de criar nova worktree
- verificar reaproveitamento antes de abrir outra
- nunca remover com mudancas nao commitadas sem confirmar
- pedir confirmacao antes de remover
- repos internos usam `git -C repo/<nome> worktree` — sao git repos separados

---

## Fluxo completo de uma sessao

```text
Sessao inicia
 -> Claude le CLAUDE.md
 -> le memoria
 -> le settings.json
 -> executa /heartbeat
 -> trabalha respeitando o contrato do workspace e dos repos
 -> registra fatos em /daily-memory
```

---

## Onde os dados ficam

| Dado | Localizacao |
|---|---|
| Memoria do dia | `memory/YYYY-MM-DD.md` |
| Memoria duravel | `MEMORY.md` |
| Ferramentas e comandos | `TOOLS.md` |
| Backlog | `Relatorios/Swarm/task-backlog.md` |
| Status operacional | `Relatorios/Swarm/supervisor-status.md` |
| Sessoes de agente | `Relatorios/agent-sessions/YYYY-MM-DD-session.md` |
| Relatorios por repo | `Relatorios/__REPO_NAME__/` |
| Config local | `.claude/settings.local.json` |
| Worktrees | `.wt/` |
| Repositorios de codigo | `repo/__REPO_NAME__/` |

---

## Como usar o pack

1. Copie `claudeCode-workspace/` para seu workspace.
2. Preencha `USER.md` e `TOOLS.md`.
3. Coloque seus repositorios dentro de `repo/` no workspace, copie `claudeCode-workspace/repo/CLAUDE.md` para cada repo e substitua os placeholders.
4. Ajuste `__WORKSPACE_ROOT__` nos arquivos com placeholder, incluindo o `--project-path` do Serena em `.claude/settings.json`.
5. Revise `.claude/settings.json`.
6. Abra o Claude Code no workspace.

## Atualizar um workspace existente

Para reaplicar melhorias do starter pack em um workspace real ja existente, use:

```powershell
.\scripts\sync-starter-pack-to-workspace.ps1
```

Exemplos uteis:

```powershell
.\scripts\sync-starter-pack-to-workspace.ps1 -TargetWorkspaceRoot 'C:\Work\MeuWorkspace'
.\scripts\sync-starter-pack-to-workspace.ps1 -ResetRuntimeState
.\scripts\sync-starter-pack-to-workspace.ps1 -WhatIf
```

O script:

- sincroniza arquivos estruturais do starter pack
- preserva a secao de repositorios de `TOOLS.md`
- faz merge conservador de `USER.md`, `MEMORY.md` e `.claude/settings.local.json`
- nao toca no conteudo de `repo/` nem em `tests/`
- so reseta `memory/`, `agent-sessions/` e `supervisor-status.md` quando `-ResetRuntimeState` for usado

---

## Plugins MCP

MCPs/plugins habilitados em `.claude/settings.json`:

```json
"enabledPlugins": {
  "context7@claude-plugins-official": true,
  "serena@claude-plugins-official": true,
  "playwright@claude-plugins-official": true,
  "telegram@claude-plugins-official": true,
  "context-mode@context-mode": true,
  "commit-commands@claude-plugins-official": true
}
```

Uso rapido:

- `serena` para codigo
- `context7` para documentacao externa
- `playwright` para UI/browser
- `context-mode` para tarefas longas
- `telegram` para interacao remota
- `commit-commands` para commits, push e PRs via slash commands
