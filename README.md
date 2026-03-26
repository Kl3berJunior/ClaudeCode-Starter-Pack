# ClaudeCode-Stater-Pack - Resumo

## O que e

Template de workspace para Claude Code com contrato operacional, memoria, MCPs e gestao de worktrees.

O pack tem duas partes:

- `claudeCode-workspace/` - workspace principal
- `claudeCode-workspace/repo/CLAUDE.md` - template para cada repositorio

---

## Estrutura de arquivos

```text
ClaudeCode-Stater-Pack/
`-- claudeCode-workspace/
    |-- .claude/
    |   |-- settings.json            # Permissoes locais e MCPs/plugins habilitados
    |   |-- settings.local.json      # Ajustes pessoais locais, fora do versionamento
    |   |-- agents/
    |   |   |-- review-deep.md       # Agente Opus: analise arquitetural profunda
    |   |   |-- explain.md           # Agente Sonnet: explicacao concisa de simbolos e arquivos
    |   |   `-- agent-router.md      # Agente roteador: classifica e delega por complexidade
    |   `-- commands/
    |       |-- backlog.md           # Slash command para listar e atualizar backlog operacional
    |       |-- daily-memory.md      # Slash command para registrar memoria diaria
    |       |-- heartbeat.md         # Slash command para checagem rapida de saude operacional
    |       `-- worktree.md          # Slash command para auditar e operar worktrees
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

Roteador de complexidade via **Sonnet**. Classifica a tarefa (Opus / Sonnet / Haiku) e spawna o subagente adequado. Suporta execucao paralela de partes independentes.

### Criterio de roteamento

| Modelo | Quando usar |
|---|---|
| Opus | Arquitetura, refatoracao cross-repo, debugging sem causa conhecida |
| Sonnet | Geracao de codigo, testes, explicacoes, buscas |
| Haiku | Glob, grep, rename, verificacoes mecanicas |

---

## `.claude/settings.json`

Define permissoes locais e os MCPs/plugins habilitados no workspace.

MCPs atuais:

- `serena`
- `context7`
- `playwright`
- `telegram`
- `context-mode`

---

## `.gitignore`

Ignora configuracoes locais, relatorios gerados, segredos locais e `.wt/`.

---

## `claudeCode-workspace/repo/CLAUDE.md`

Template que governa o comportamento do Claude dentro de cada repositorio, com regras minimas, comandos de validacao e prioridade de ferramentas.

---

## Worktrees

Worktrees sao o mecanismo padrao para isolamento e paralelo limpo.

Convencao:

- raiz em `.wt/`
- padrao `.wt/<repo>/<objetivo-ou-branch>`

Regras:

- auditar antes de criar nova worktree
- verificar reaproveitamento antes de abrir outra
- pedir confirmacao antes de remover

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
| Relatorios por repo | `Relatorios/__REPO_NAME__/` |
| Config local | `.claude/settings.local.json` |
| Worktrees | `.wt/` |
| Repositorios de codigo | `repo/__REPO_NAME__/` |

---

## Como usar o pack

1. Copie `claudeCode-workspace/` para seu workspace.
2. Preencha `USER.md` e `TOOLS.md`.
3. Coloque seus repositorios dentro de `repo/` no workspace, copie `claudeCode-workspace/repo/CLAUDE.md` para cada repo e substitua os placeholders.
4. Ajuste `__WORKSPACE_ROOT__`.
5. Revise `.claude/settings.json`.
6. Abra o Claude Code no workspace.

---

## Plugins MCP

MCPs/plugins habilitados em `.claude/settings.json`:

```json
"enabledPlugins": {
  "context7@claude-plugins-official": true,
  "serena@claude-plugins-official": true,
  "playwright@claude-plugins-official": true,
  "telegram@claude-plugins-official": true,
  "context-mode@context-mode": true
}
```

Uso rapido:

- `serena` para codigo
- `context7` para documentacao externa
- `playwright` para UI/browser
- `context-mode` para tarefas longas
- `telegram` para interacao remota
