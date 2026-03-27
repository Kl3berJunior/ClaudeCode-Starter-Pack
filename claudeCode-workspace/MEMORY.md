# MEMORY

Memoria curada de longo prazo do workspace.

Regra:

- registrar apenas decisoes, contratos e fatos duraveis
- evitar duplicata
- manter caminhos concretos sempre que possivel

Contratos duraveis deste workspace:

- worktrees operacionais vivem em `.wt/` com dois subtipos:
  - workspace: `.wt/workspace/<objetivo>` — para trabalho no proprio workspace
  - repo interno: `.wt/<repo-kebab-case>/<objetivo>` — repos em `repo/` sao git repos separados, usar `git -C repo/<nome> worktree`
- prefixo de branch: convencional (`feat/`, `fix/`, `chore/`, `refactor/`, `docs/`) — nao usar `agent/` para branches
- auditoria de worktrees faz parte do heartbeat operacional
- limpeza de worktree exige elegibilidade clara e confirmacao antes de remocao
- agentes em `.claude/agents/` nao devem ter campo `tools:` no frontmatter — herdam todos os MCPs do workspace
- `Relatorios/` e versionado — `task-backlog.md`, `supervisor-status.md` e `agent-sessions/` sao canonicos
- `memory/` e ignorado pelo git — diarios operacionais sao locais
- `Relatorios/Swarm/task-backlog.md` e o arquivo canonico do backlog
- `Relatorios/Swarm/supervisor-status.md` e o arquivo canonico de status do supervisor
- `Relatorios/agent-sessions/` contem relatorios de sessao no formato `YYYY-MM-DD-session.md`
- README.md e guia.md na raiz contem documentacao completa do workspace para novos usuarios
