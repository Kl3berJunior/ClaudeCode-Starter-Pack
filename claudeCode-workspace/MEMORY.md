# MEMORY

Memoria curada de longo prazo do workspace.

Regra:

- registrar apenas decisoes, contratos e fatos duraveis
- evitar duplicata
- manter caminhos concretos sempre que possivel

Contratos duraveis deste workspace:

- worktrees operacionais vivem em `.wt/`
- o padrao preferido e `.wt/<repo-kebab-case>/<objetivo-ou-branch>`
- prefixo de branch recomendado para worktrees: `agent/<objetivo>`
- auditoria de worktrees faz parte do heartbeat operacional
- limpeza de worktree exige elegibilidade clara e confirmacao antes de remocao
- `Relatorios/Swarm/task-backlog.md` e o arquivo canonico do backlog (criado em 2026-03-26)
- `Relatorios/Swarm/supervisor-status.md` e o arquivo canonico de status do supervisor
- `Relatorios/agent-sessions/` contem relatorios de sessao no formato `YYYY-MM-DD-session.md`
- README.md na raiz contem o guia completo do workspace para novos usuarios
