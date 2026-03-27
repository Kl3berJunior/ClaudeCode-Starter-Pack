Executar o rito de abertura da sessao no Claude CLI.

Objetivo:
- carregar o contexto minimo confiavel antes de comecar qualquer tarefa
- reduzir perda de contexto entre sessoes
- mostrar riscos, pendencias e proximo passo recomendado
- reparar manualmente a sessao se a auto-inicializacao por hook falhar

Passos:
1. Ler `CLAUDE.md`, `SOUL.md`, `USER.md`, `TOOLS.md` e `MEMORY.md`
2. Ler `memory/YYYY-MM-DD.md` de hoje e, se existir, o arquivo do dia anterior
3. Ler o relatorio de sessao mais recente em `Relatorios/agent-sessions/`
   - preferir o arquivo de hoje, se existir
   - senao usar o arquivo mais recente disponivel
4. Ler `.claude/settings.json` para confirmar MCPs/plugins habilitados
5. Verificar `memory/_session-state.json`
   - se nao existir, criar
   - se estiver desatualizado, recriar para a data atual
   - garantir `startup_done=true` e `close_done=false`
6. Executar `/heartbeat`
7. Verificar `git status --short --branch`
8. Responder com um resumo curto contendo:
   - branch atual
   - contexto herdado da ultima sessao
   - memoria relevante de hoje e de ontem
   - alertas do heartbeat
   - estado do marcador local de sessao
   - recomendacao pratica de proximo passo

Regras:
- este comando e o fallback manual do hook `SessionStart`
- nao assumir continuidade sem ler memoria e relatorio
- se algum arquivo esperado estiver ausente, reportar como observacao e seguir
- se houver risco operacional, listar antes de qualquer proposta de execucao
- se o workspace estiver limpo e sem pendencias, dizer isso explicitamente

Formato sugerido:
```md
## Startup

- branch: <branch>
- ultima sessao: <resumo>
- memoria relevante: <resumo>
- marcador de sessao: <ok-ou-reparado>
- heartbeat: <OK-ou-alertas>
- proximo passo recomendado: <acao>
```
