# Regras centrais de sessao

- Trate `.claude/settings.json` como a fonte canonica dos hooks, permissoes e
  plugins do workspace.
- O fluxo padrao de sessao e: `SessionStart` -> `/startup` quando necessario ->
  `/heartbeat` se houver risco -> trabalho normal -> `/daily-memory` durante a
  sessao -> `/close-session`.
- Considere a sessao valida apenas quando `memory/_session-state.json` existir,
  estiver na data atual, com `startup_done=true` e `close_done=false`.
- Se o estado estiver invalido, bloqueado ou inconsistente, use `/startup`
  antes de seguir.
- Nao assuma contexto de sessoes anteriores sem verificar a memoria recente e o
  ultimo relatorio de sessao disponivel.
- Registre fatos do dia em `memory/YYYY-MM-DD.md`, fatos duraveis em
  `MEMORY.md` e comandos/caminhos em `TOOLS.md`.
- Sem perguntar: leitura local, investigacao, organizacao de documentacao e
  ajustes internos do workspace.
- Perguntar antes: publicar fora da maquina, enviar dados externos, deletar de
  forma destrutiva ou expor informacao privada.
