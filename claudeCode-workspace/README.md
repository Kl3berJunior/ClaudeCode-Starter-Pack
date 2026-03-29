# ClaudeCode Starter Pack - Workspace

Workspace operacional para Claude Code com hooks, comandos, regras modulares,
memoria estruturada e isolamento por worktree.

## Estrutura

```text
claudeCode-workspace/
|-- .claude/
|   |-- agents/          # Subagentes especializados
|   |-- commands/        # Slash commands customizados
|   |-- hooks/           # Hooks nativos de sessao
|   |-- rules/           # Regras modulares do workspace
|   `-- settings.json    # Fonte canonica de hooks, permissoes e plugins
|-- .serena/
|   |-- .gitignore       # Runtime local do Serena
|   `-- project.yml      # Config base do projeto Serena
|-- memory/
|   `-- README.md        # Runtime local; diarios reais ficam fora do git
|-- repo/
|   `-- CLAUDE.md        # Template de contrato para repositorios internos
|-- Relatorios/
|   |-- Swarm/           # task-backlog.md e supervisor-status.md
|   `-- agent-sessions/  # Apenas o README e versionado
|-- .gitignore
|-- CLAUDE.md            # Bootstrap curto do workspace
|-- SOUL.md              # Principios permanentes
|-- MEMORY.md            # Memoria duravel
|-- TOOLS.md             # Referencia humana de comandos e caminhos
|-- USER.md              # Contexto operacional do time
`-- HEARTBEAT.md         # Checklist curto de saude operacional
```

## Como as regras ficaram organizadas

- `CLAUDE.md`: bootstrap curto, imports essenciais e fluxo minimo de sessao
- `.claude/rules/00-core-session.md`: invariantes de sessao e seguranca
- `.claude/rules/10-git-and-worktrees.md`: politica de git, branches e worktrees
- `.claude/rules/20-workspace-maintenance.md`: manutencao do starter pack
- `.claude/rules/30-repo-and-tests.md`: regras para repos internos e testes
- `.claude/rules/40-memory-and-reports.md`: memoria, backlog e relatorios

Use `CLAUDE.local.md` para preferencias locais privadas. Ele deve ficar
gitignored.

## MCPs e ferramentas

Fonte canonica: `.claude/settings.json`

Plugins esperados no pack:

- `serena` para navegacao semantica de codigo
- `context7` para documentacao externa atualizada
- `playwright` para UI, navegacao e regressao visual
- `context-mode` para tarefas longas
- `telegram` para notificacoes e triagem remota
- `commit-commands` para commit, push e PR

## Fluxo operacional

1. `SessionStart` injeta contexto minimo e repara o marcador local.
2. Se a sessao estiver duvidosa, rode `/startup`.
3. Use `/heartbeat` quando houver risco operacional.
4. Use `/pickup` quando a demanda vier do GitHub Project.
5. Trabalhe no workspace, em `repo/` ou em uma worktree rastreavel.
6. Registre fatos do dia em `/daily-memory`.
7. Feche a sessao com `/close-session`.

## Onde cada coisa deve viver

- regra duravel do workspace: `.claude/rules/`
- principio permanente: `SOUL.md`
- conhecimento duravel: `MEMORY.md`
- comando, caminho ou heuristica: `TOOLS.md`
- contexto do time: `USER.md`
- memoria do dia: `memory/YYYY-MM-DD.md`
- backlog: `Relatorios/Swarm/task-backlog.md`
- status do supervisor: `Relatorios/Swarm/supervisor-status.md`
- fechamento de sessao: `Relatorios/agent-sessions/YYYY-MM-DD-session.md`

## Runtime local e template limpo

O starter pack deve permanecer sem memoria diaria real, sem relatorios datados
e sem overrides locais versionados.

Arquivos locais recomendados:

- `CLAUDE.local.md`
- `.claude/settings.local.json`
- `.serena/project.local.yml`

## Sincronizacao e sandbox

Da raiz do repositorio do starter pack:

```powershell
.\scripts\sync-starter-pack-to-workspace.ps1 -TargetWorkspaceRoot 'C:\Work\MeuWorkspace'
.\scripts\sync-starter-pack-to-workspace.ps1 -TargetWorkspaceRoot 'C:\Work\MeuWorkspace' -MergeSourceSettingsLocal
.\scripts\new-disposable-workspace.ps1
.\scripts\new-disposable-workspace.ps1 -Name 'teste-rules' -ForceRecreate
```

O script `new-disposable-workspace.ps1` cria um workspace descartavel dentro de
`.tmp/`, reseta o runtime local (`memory/`, `Relatorios/agent-sessions/`,
`.serena/memories/` e `.claude/worktrees/`) e so copia `settings.local.json`
se voce pedir explicitamente.
