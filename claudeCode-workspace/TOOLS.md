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

## Worktrees

Convencao:

- raiz local: `.wt/`
- padrao de caminho: `.wt/<repo>/<objetivo-ou-branch>`
- uma worktree por contexto ativo relevante

Auditoria:

- listar worktrees: `git worktree list --porcelain`
- verificar status de uma worktree: `git -C .wt/<repo>/<objetivo-ou-branch> status --short --branch`
- podar metadata orfa: `git worktree prune`

Criacao:

- nova branch em worktree dedicada: `git worktree add .wt/<repo>/<objetivo-ou-branch> -b <branch>`
- usar branch existente em worktree dedicada: `git worktree add .wt/<repo>/<objetivo-ou-branch> <branch>`

Limpeza:

- remover worktree limpa: `git worktree remove .wt/<repo>/<objetivo-ou-branch>`
- nunca remover worktree com mudancas nao commitadas sem confirmar antes

Inventario minimo por worktree:

- repo
- branch
- objetivo
- dono ou task
- data da ultima atividade

Formato sugerido:

## Repo `__REPO_NAME__`

- path: `__WORKSPACE_ROOT__/repo/__REPO_NAME__`
- worktree-root: `.wt/__REPO_NAME__/`
- build: `__COMMAND__`
- test: `__COMMAND__`
- lint: `__COMMAND__`
- publish: `__COMMAND__`
- run: `__COMMAND__`
- notes: `__NOTES__`

---
