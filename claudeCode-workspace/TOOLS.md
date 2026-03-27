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

---

## Caminhos importantes

- workspace root: `__WORKSPACE_ROOT__`
- repositorios de codigo: `__WORKSPACE_ROOT__/repo/`
- testes: `__WORKSPACE_ROOT__/tests/`
- configuracao Claude Code: `.claude/settings.json`
- comandos customizados: `.claude/commands/`
- memoria diaria: `memory/`
- memoria duravel: `MEMORY.md`
- contrato operacional: `CLAUDE.md`
- worktrees locais: `.wt/`
- relatorios de sessao: `Relatorios/agent-sessions/`
- backlog de tasks: `Relatorios/Swarm/task-backlog.md`
- status do supervisor: `Relatorios/Swarm/supervisor-status.md`

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
- prefixo de branch recomendado: `agent/<objetivo>`
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
git worktree add .wt/workspace/<objetivo> -b agent/<objetivo>

# Criar com branch existente
git worktree add .wt/workspace/<objetivo> <branch>
```

### Worktrees de repos internos

Repos em `repo/<nome>/` sao git repos separados. Para criar worktree de um repo interno:

```bash
# A partir da raiz do repo interno
git -C repo/<nome> worktree add ../../.wt/<nome-kebab>/<objetivo> -b agent/<objetivo>

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
