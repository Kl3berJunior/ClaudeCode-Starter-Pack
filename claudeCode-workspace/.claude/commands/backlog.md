Gerenciar o backlog de tasks do workspace.

Passos:
1. Ler `Relatorios/Swarm/task-backlog.md` (criar se nao existir, com cabecalho padrao)
2. Mostrar as tasks abertas com status, prioridade e repo
3. Perguntar ao usuario o que deseja fazer: adicionar, atualizar status, ou listar
4. Aplicar a mudanca no arquivo mantendo o formato de tabela Markdown:
   `| Id | Repo | Titulo | Status | Prioridade | Origem |`
5. Atualizar `Relatorios/Swarm/supervisor-status.md` com o novo total de tasks abertas e a data atual

Status validos: `open`, `in-progress`, `blocked`, `done`, `cancelled`
Prioridades validas: `high`, `medium`, `low`
