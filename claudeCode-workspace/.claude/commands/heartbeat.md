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
5. Auditar worktrees do workspace:
   - Executar `git worktree list --porcelain`
   - Existe worktree orfa, sem branch valida, HEAD detached ou sem objetivo claro?
   - Existe worktree com mudancas locais sem task rastreavel? (verificar com `git -C <path> status --short`)
   - Existe worktree limpa, mergeada ou encerrada elegivel para limpeza?
6. Auditar worktrees de repos internos:
   - Para cada repo em `repo/`, executar `git -C repo/<nome> worktree list`
   - Aplicar as mesmas verificacoes: branch valida, HEAD detached, mudancas sem task, elegivel para limpeza
7. Reportar estado completo:
   - Para cada item acima: OK ou ATENCAO com descricao do problema
   - Responder `HEARTBEAT_OK` somente se todos os itens estiverem sem problemas
   - Se houver qualquer item com ATENCAO, listar o que precisa ser resolvido
