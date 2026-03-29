Gerenciar o backlog de tasks do workspace.

Passos:
1. Ler `Relatorios/Swarm/task-backlog.md` (criar se nao existir, com cabecalho padrao)
2. Tratar esse arquivo como backlog operacional local, nao como espelho completo do GitHub
3. Mostrar as tasks abertas com status, prioridade, repo e contexto de execucao
4. Perguntar ao usuario o que deseja fazer: adicionar, atualizar status, vincular branch/worktree, ou listar
5. Aplicar a mudanca no arquivo mantendo o formato de tabela Markdown:
   `| TaskId | Repo | Titulo | Status | Prioridade | Branch | Worktree | Origem |`
6. Atualizar `Relatorios/Swarm/supervisor-status.md` com o novo total de tasks abertas e a data atual
   - Se o arquivo nao existir, criar com cabecalho padrao antes de atualizar

Status validos: `open`, `in-progress`, `blocked`, `done`, `cancelled`
Prioridades validas: `high`, `medium`, `low`

Regra de modelagem:
- `TaskId` identifica a task operacional, nao a demanda inteira
- para demandas multi-repo, use um `TaskId` por repo ou faixa de mudanca
