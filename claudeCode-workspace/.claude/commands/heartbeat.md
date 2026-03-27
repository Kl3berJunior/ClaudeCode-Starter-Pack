Verificar o arquivo HEARTBEAT.md e reportar o estado operacional atual do workspace.

Passos:
1. Ler `HEARTBEAT.md`
2. Verificar tasks bloqueadas em `Relatorios/Swarm/task-backlog.md`:
   - Existe task com status `blocked` sem dono claro?
3. Verificar relatorios e supervisor:
   - Ler `Relatorios/Swarm/supervisor-status.md` — existe erro critico registrado?
   - Existe relatorio de sessao em `Relatorios/agent-sessions/` com data vencida sem conclusao?
4. Verificar memoria do dia:
   - Existe `memory/YYYY-MM-DD.md` para hoje? (substitua pela data real)
5. Auditar worktrees com `git worktree list --porcelain`:
   - Existe worktree sem branch valida (branch inexistente ou HEAD detached)?
   - Existe worktree com mudancas locais sem task ou dono rastreavel? (verificar com `git -C <path> status --short`)
   - Existe worktree limpa, mergeada ou sem uso que pode ser removida?
   - Para repos internos em `repo/`, auditar tambem com `git -C repo/<nome> worktree list`
6. Reportar o estado completo:
   - Para cada item acima: OK ou ATENCAO com descricao do problema
   - Responder `HEARTBEAT_OK` somente se todos os 7 itens estiverem sem problemas
   - Se houver qualquer item com ATENCAO, listar o que precisa ser resolvido
