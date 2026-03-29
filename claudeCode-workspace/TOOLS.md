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

## Operacao rapida

Fluxo base:

1. abrir o Claude CLI na raiz do workspace
2. confiar no `SessionStart`; usar `/startup` se a sessao estiver duvidosa
3. usar `/heartbeat` quando houver risco operacional
4. descobrir demanda com `/gh-project` ou confirmar fila com `/backlog`
5. usar `/pickup` para sair do Project e cair no backlog ou na execucao
6. materializar demanda com `/delegate` quando quiser separar manualmente as etapas
7. entrar em execucao com `/start-task`
8. implementar, validar e abrir PR
9. encerrar com `/finish-task` e `/close-session`

## Commands principais

| Etapa | Command | Quando usar |
|-------|---------|-------------|
| Abertura | `/startup` | reabrir contexto ou reparar sessao |
| Saude | `/heartbeat` | auditar backlog, supervisor e worktrees |
| Triagem GitHub | `/gh-project` | listar ou filtrar items do Project |
| Pickup do Project | `/pickup <acao>` | listar candidatos, delegar a demanda e sugerir ou iniciar execucao por repo |
| Backlog | `/delegate` | criar a umbrella task local da demanda antes da execucao |
| Execucao | `/start-task <numero> <org/repo> <repo-interno>` | criar ou retomar branch/worktree da execucao |
| Multi-repo | `/worktree <acao>` | abrir worktree adicional fora do fluxo padrao |
| Fechamento de execucao | `/finish-task <numero> <org/repo> <repo-interno>` | fechar ou atualizar a task de execucao |
| Fechamento da sessao | `/close-session` | encerrar a sessao com memoria e relatorio |

## Regras praticas

- `SessionStart`, `UserPromptSubmit` e `SessionEnd` fazem o enforcement leve da sessao
- GitHub Project e GitHub Issue/PR sao a fonte de verdade da demanda
- `Relatorios/Swarm/task-backlog.md` guarda apenas tasks operacionais ativas
- `/pickup` e o fluxo recomendado quando a demanda nasce no GitHub Project
- uma task de execucao deve mapear para um repo, uma branch e uma worktree
- uma mesma demanda pode desdobrar varias tasks de execucao quando afetar varios repositorios
- use `workspace` para triagem e coordenacao; use worktree para implementacao
- detalhes de commit, PR e operacao longa ficam no `guia.md` e nos commands especializados

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

### O que e uma worktree

Uma worktree e um diretorio adicional do mesmo repositorio Git, com `HEAD`,
`index` e arquivos de trabalho proprios. Na pratica, ela permite manter mais de
uma branch ativa ao mesmo tempo sem misturar arquivos de uma tarefa com outra.

Para este starter pack, a regra pratica e:

- usar o workspace principal como central de triagem, backlog e GitHub
- abrir worktree quando uma issue ou task for realmente entrar em execucao
- evitar worktree para consulta rapida, leitura de issue ou triagem

### Fluxo recomendado por issue do GitHub

1. Descobrir ou filtrar a demanda com `/pickup listar` ou `/gh-project` no workspace principal.
2. Usar `/pickup planejar` para criar a umbrella task e sugerir os repos de execucao.
3. Usar `/pickup executar` quando o repo estiver claro ou vier explicito.
4. Criar ou reutilizar uma worktree por task de execucao no repo alvo.
5. Manter relacao 1:1: uma task de execucao -> uma branch -> uma worktree -> um PR.
6. Apos merge ou cancelamento, limpar a worktree correspondente.

Padrao recomendado quando a origem for GitHub:

- worktree: `.wt/<repo>/gh-<numero>-<slug>`
- branch: `<prefixo>/<numero>-<slug>`
- dono: `gh:<org/repo>#<numero>::<repo-interno>`

Fonte de verdade recomendada:

- GitHub Project: priorizacao, visoes e fila macro
- GitHub Issue/PR: contexto funcional e historico da demanda
- `Relatorios/Swarm/task-backlog.md`: apenas tasks ativas, em execucao ou bloqueadas no workspace
- worktree: isolamento tecnico da implementacao em andamento

### Demandas multi-repo

Quando a mesma demanda afetar varios repositorios, nao tente concentrar tudo em
uma unica worktree.

Padrao recomendado:

- uma issue ou PR pode gerar varias tasks de execucao
- cada task de execucao deve apontar para um repo ou faixa de mudanca clara
- cada task de execucao ganha sua propria branch e worktree
- todas podem compartilhar a mesma origem no GitHub

Exemplos comuns:

- `frontend-interno` e `frontend-externo` para a mesma entrega visual
- `backend-interno` e `backend-externo` para a mesma integracao
- `frontend` + `backend` quando a mudanca atravessa a aplicacao inteira

Use worktree `workspace` apenas para evoluir o proprio template, docs, hooks ou
scripts do workspace. Para issues de produto, prefira worktree `repo`.

So use worktree detached (`git worktree add -d ...`) para experimento rapido ou
teste descartavel. Para fluxo rastreavel por issue, use branch nomeada.

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

Exemplo rastreavel por issue:

```bash
git -C repo/minha-api worktree add ../../.wt/minha-api/gh-123-login-social -b fix/123-login-social
git -C .wt/minha-api/gh-123-login-social status --short --branch
```

Regras:

- nunca remover worktree com mudancas nao commitadas sem confirmar
- nunca remover o worktree principal
- sempre rodar `git worktree prune` apos remover
- worktrees de repos internos precisam de `git -C repo/<nome> worktree prune` separado
- ao operar git fora do diretorio atual, preferir `git -C <path> ...`
- evitar `cd <path> && git ...` para respeitar a permissao `Bash(git:*)`

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
