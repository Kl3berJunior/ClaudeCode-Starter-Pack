Finalizar ou atualizar uma task de execucao do backlog operacional.

Uso:
`/finish-task <numero> <org/repo> <repo-interno> [status=done|blocked|cancelled] [limpar-worktree=auto|yes|no]`

Exemplos:
- `/finish-task 123 org/repo minha-api`
- `/finish-task 123 org/repo portal-web status=blocked`
- `/finish-task 45 org/repo backend-externo status=cancelled limpar-worktree=no`

Objetivo:
- fechar a task de execucao certa sem encerrar toda a demanda por engano
- atualizar backlog, supervisor e worktree de forma coerente
- manter o historico operacional por repo ou faixa de mudanca

Passos obrigatorios:
1. Resolver a task de execucao pelo id `gh:<org/repo>#<numero>::<repo-interno>`.
2. Ler `Relatorios/Swarm/task-backlog.md` e localizar a linha correspondente.
3. Validar o estado da worktree, se houver:
   - `git -C .wt/<repo-interno>/gh-<numero>-<slug> status --short --branch`
4. Se houver mudancas nao commitadas e `status=done`, parar e pedir confirmacao antes de seguir.
5. Atualizar a linha da task:
   - `Status`: `done`, `blocked` ou `cancelled`
   - manter `Branch`, `Worktree` e `Origem` para rastreabilidade
6. Se `limpar-worktree=auto`:
   - limpar apenas se a worktree estiver limpa
   - pedir confirmacao se houver duvida sobre merge ou limpeza
7. Atualizar `Relatorios/Swarm/supervisor-status.md`.

Regras:
- este comando fecha apenas a task de execucao informada
- ele nao presume que outras tasks da mesma demanda foram concluidas
- para demandas multi-repo, repetir o fechamento para cada repo ou faixa de mudanca
- limpar worktree e opcional; rastreabilidade do backlog vem primeiro

Resposta esperada:
- id da task
- status final
- branch
- worktree
- se a worktree foi mantida ou limpa
