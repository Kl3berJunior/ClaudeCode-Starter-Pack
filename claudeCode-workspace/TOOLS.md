# TOOLS

Fonte pratica de comandos, caminhos e MCPs do workspace.

Registre aqui:

- caminhos locais importantes
- comandos de build e teste por repo
- ferramentas instaladas e wrappers internos do time
- observacoes sobre runtime local

---

## MCPs habilitados neste workspace

Fonte canonica: `.claude/settings.json`

| Plugin | Dominio | Descricao |
|--------|---------|-----------|
| `serena` | Codigo semantico | Leitura e edicao semantica de codigo, busca por simbolos, referencias e pontos de entrada |
| `context7` | Documentacao externa | Consulta de documentacao atualizada de bibliotecas, frameworks, SDKs e APIs externas |
| `playwright` | Browser | Automacao de browser para validacao funcional, visual e testes de UI |
| `context-mode` | Contexto longo | Organizacao de contexto para tarefas longas, multi-etapa ou com historico extenso |
| `commit-commands` | Git | Fluxo padronizado de commit, push e abertura de PR |
| `telegram` | Notificacoes | Alertas e interacao remota quando o bot estiver pareado |

### Heuristica de uso

- codigo com dependencia entre funcoes, classes e arquivos: comecar por `serena`
- duvida sobre contrato externo ou API de biblioteca: consultar `context7`
- fluxo de UI, navegador, captura ou regressao visual: usar `playwright`
- sessao longa ou problema com muita troca de contexto: usar `context-mode`
- mensagens externas ou alerta operacional: usar `telegram` se estiver configurado

### Regra de contexto do Serena por repositorio

O serena opera sobre um diretorio-raiz de projeto. Ao receber uma tarefa que envolva codigo, identificar o contexto alvo antes de usar o serena:

**Regras de identificacao de contexto:**

1. Se a tarefa mencionar explicitamente um repo (`repo/<nome>`, nome do sistema, ou nome do servico) — usar o path desse repo como raiz do serena
2. Se a tarefa for sobre o proprio workspace (CLAUDE.md, commands, agents, MEMORY, TOOLS, etc.) — usar o path do workspace como raiz
3. Se nao houver indicacao clara — perguntar antes de assumir

**Ordem de troca de contexto:**

1. Identificar o repo alvo pela tarefa ou pela pergunta do usuario
2. Confirmar que o path existe em `repo/<nome>/` ou em `.wt/<nome>/<branch>/`
3. Iniciar ou redirecionar o serena para esse path antes de qualquer busca semantica
4. Registrar o contexto ativo se houver troca durante a sessao (ex: "serena apontado para repo/meu-servico")

**Paths de referencia:**

| Contexto | Path |
|----------|------|
| Workspace | `__WORKSPACE_ROOT__` |
| Repo interno | `__WORKSPACE_ROOT__/repo/<nome-do-repo>` |
| Worktree de repo | `__WORKSPACE_ROOT__/.wt/<nome-kebab>/<objetivo>` |

---

## Caminhos importantes

- workspace root: `__WORKSPACE_ROOT__`
- repositorios de codigo: `__WORKSPACE_ROOT__/repo/`
- testes: `__WORKSPACE_ROOT__/tests/`
- configuracao Claude Code: `.claude/settings.json`
- hooks de sessao: `.claude/hooks/`
- comandos customizados: `.claude/commands/`
- memoria diaria: `memory/`
- marcador local de sessao: `memory/_session-state.json`
- memoria duravel: `MEMORY.md`
- contrato operacional: `CLAUDE.md`
- worktrees locais: `.wt/`
- relatorios de sessao: `Relatorios/agent-sessions/`
- backlog de tasks: `Relatorios/Swarm/task-backlog.md`
- status do supervisor: `Relatorios/Swarm/supervisor-status.md`

---

## Fluxo de sessao no Claude CLI

Sequencia recomendada ao abrir o workspace:

1. abrir o Claude CLI na raiz do workspace
2. deixar o hook `SessionStart` auto-inicializar a sessao e gravar `memory/_session-state.json`
3. se houver bloqueio do `UserPromptSubmit` ou duvida de contexto, executar `/startup`
4. ler o resumo retornado e confirmar se a tarefa da sessao vai usar workspace principal, repo interno ou worktree
5. seguir com `/backlog`, `/worktree`, `/gh-project` e `/delegate` conforme o tipo de trabalho

Sequencia recomendada ao encerrar:

1. executar `/close-session`
2. conferir a memoria diaria, o relatorio de sessao e o marcador local atualizados
3. deixar o hook `SessionEnd` registrar o encerramento leve ao fechar o CLI
4. revisar pendencias, worktrees elegiveis para limpeza e proximos passos
5. so entao encerrar o Claude CLI

Regra pratica:

- se a auto-inicializacao falhar ou o prompt for bloqueado, executar `/startup`
- se a sessao vai terminar, nao sair do CLI antes de rodar `/close-session`

## Hooks de sessao

Eventos configurados em `.claude/settings.json`:

- `SessionStart`: cria ou repara `memory/_session-state.json`, garante memoria do dia e injeta contexto minimo
- `UserPromptSubmit`: bloqueia prompts quando a sessao nao estiver validada ou ja tiver sido fechada logicamente
- `SessionEnd`: registra a saida e marca quando o CLI foi encerrado sem `/close-session`

Uso recomendado:

- confiar nos hooks para enforcement leve e automatico
- usar `/startup` para auditoria manual ou reabertura de contexto
- usar `/close-session` para fechamento rico com memoria e relatorio

---

## Repositorios

Adicione uma secao por repositorio registrado neste workspace.

### Formato para novo repo

```
### Repo `<nome-do-repo>`

- path: `__WORKSPACE_ROOT__/repo/<nome-do-repo>`
- worktree-root: `.wt/<nome-em-kebab-case>/`
- tipo: <Backend | Frontend | Biblioteca | Infra | Docs>
- testes: `tests/<nome-em-kebab-case>/`
- build: <comando>
- test: <comando>
- lint: <comando>
- run: <comando>
- notes: <descricao>
```

### Exemplo — Repo `meu-servico`

```
### Repo `meu-servico`

- path: `__WORKSPACE_ROOT__/repo/meu-servico`
- worktree-root: `.wt/meu-servico/`
- tipo: Backend
- testes: `tests/meu-servico/`
- build: dotnet build
- test: dotnet test
- lint: dotnet format --verify-no-changes
- run: dotnet run
- notes: Servico principal de autenticacao
```

---

## Worktrees

Convencao:

- raiz local: `.wt/`
- padrao de caminho: `.wt/<repo-em-kebab-case>/<objetivo-ou-branch>`
- prefixo de branch recomendado: convencional (`feat/`, `fix/`, `chore/`, `refactor/`, `docs/`)
- uma worktree por contexto ativo relevante

Inventario minimo por worktree:

| Campo | Descricao |
|-------|-----------|
| repo | nome do repositorio em kebab-case |
| branch | branch associada |
| objetivo | o que esta sendo feito |
| dono | task ou agente responsavel |
| ultima atividade | data da ultima alteracao |

### Worktrees do workspace principal

Worktrees criadas a partir da raiz do workspace (para isolar trabalho no proprio workspace):

```bash
# Criar com nova branch
git worktree add .wt/workspace/<objetivo> -b <prefixo>/<objetivo>

# Criar com branch existente
git worktree add .wt/workspace/<objetivo> <branch>
```

### Worktrees de repos internos

Repos em `repo/<nome>/` sao git repos separados. Para criar worktree de um repo interno:

```bash
# A partir da raiz do repo interno
git -C repo/<nome> worktree add ../../.wt/<nome-kebab>/<objetivo> -b <prefixo>/<objetivo>

# Com branch existente
git -C repo/<nome> worktree add ../../.wt/<nome-kebab>/<objetivo> <branch>
```

### Comandos gerais

```bash
# Auditoria do workspace principal
git worktree list --porcelain

# Auditoria de repo interno
git -C repo/<nome> worktree list --porcelain

# Status de uma worktree
git -C .wt/<repo>/<objetivo> status --short --branch

# Remover worktree limpa
git worktree remove .wt/<repo>/<objetivo>

# Podar metadata orfa
git worktree prune
```

Regras:

- nunca remover worktree com mudancas nao commitadas sem confirmar
- nunca remover o worktree principal
- sempre rodar `git worktree prune` apos remover
- worktrees de repos internos precisam de `git -C repo/<nome> worktree prune` separado

---

## Testes

Executar testes de API (PowerShell):

```powershell
pwsh tests/<repo>/<modulo>/test_<cenario>.ps1
```

Executar testes de frontend (Playwright):

```bash
npx playwright test tests/<repo>/
npx playwright test tests/<repo>/<modulo>/
npx playwright test tests/<repo>/ --ui    # modo visual
```
