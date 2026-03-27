# TOOLS

Fonte pratica de comandos, caminhos e MCPs do workspace.

Registre aqui:

- caminhos locais importantes
- comandos de build e teste por repo
- ferramentas instaladas
- wrappers internos do time
- observacoes sobre runtime local

## MCPs habilitados neste workspace

Fonte canonica: `.claude/settings.json`

- `serena`: leitura e edicao semantica de codigo, busca por simbolos, referencias e pontos de entrada
- `context7`: consulta de documentacao atualizada de bibliotecas, frameworks, SDKs e APIs
- `playwright`: automacao de browser para validacao funcional e visual
- `context-mode`: organizacao de contexto para tarefas longas, multi-etapa ou com historico grande
- `telegram`: notificacoes e interacao remota quando o pareamento do bot estiver configurado
- `commit-commands`: fluxo padrao de commit, push e abertura de PR

## Heuristica de uso

- codigo com dependencia entre funcoes, classes e arquivos: começar por `serena`
- duvida sobre contrato externo ou API de biblioteca: consultar `context7`
- fluxo de UI, navegador, captura ou regressao visual: usar `playwright`
- sessao longa ou problema com muita troca de contexto: usar `context-mode`
- mensagens externas ou alerta operacional: usar `telegram` se estiver configurado

## Caminhos importantes

- workspace root: `__WORKSPACE_ROOT__`
- repositorios de codigo: `__WORKSPACE_ROOT__/repo/`
- configuracao Claude Code: `.claude/settings.json`
- comandos customizados: `.claude/commands/`
- memoria diaria: `memory/`
- memoria duravel: `MEMORY.md`
- contrato operacional: `CLAUDE.md`
- worktrees locais: `.wt/`
- backlog de tasks: `Relatorios/Swarm/task-backlog.md`
- status do supervisor: `Relatorios/Swarm/supervisor-status.md`
- relatorios de sessao: `Relatorios/agent-sessions/`

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

## Worktrees

Convencao:

- raiz local: `.wt/`
- padrao de caminho: `.wt/<repo-kebab-case>/<objetivo-ou-branch>`
- uma worktree por contexto ativo relevante
- prefixo de branch recomendado: `agent/<objetivo>`

Inventario minimo por worktree:

| Campo | Descricao |
|-------|-----------|
| repo | nome do repositorio em kebab-case |
| branch | branch associada |
| objetivo | o que esta sendo feito |
| dono | task ou agente responsavel |
| ultima atividade | data da ultima alteracao |

Comandos:

```bash
# Auditoria
git worktree list --porcelain
git -C .wt/<repo>/<objetivo> status --short --branch

# Criar com nova branch
git worktree add .wt/<repo>/<objetivo> -b agent/<objetivo>

# Criar com branch existente
git worktree add .wt/<repo>/<objetivo> <branch>

# Remover worktree limpa
git worktree remove .wt/<repo>/<objetivo>

# Podar metadata orfa
git worktree prune
```

Regras:

- nunca remover worktree com mudancas nao commitadas sem confirmar
- nunca remover o worktree principal
- sempre rodar `git worktree prune` apos remover

## Formato de entrada por repo

Adicione uma secao por repositorio registrado:

```
## Repo <nome-do-repo>

- path: `repo/<nome-do-repo>`
- worktree-root: `.wt/<nome-do-repo>/`
- build: <comando>
- test: <comando>
- lint: <comando>
- run: <comando>
- notes: <observacoes>
```

---
