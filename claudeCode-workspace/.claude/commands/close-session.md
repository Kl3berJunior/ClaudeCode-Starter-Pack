Executar o rito de encerramento da sessao no Claude CLI.

Objetivo:
- fechar a sessao com memoria e artefatos rastreaveis
- deixar pendencias e proximos passos claros
- evitar sair do CLI sem registrar o que foi feito
- marcar explicitamente a sessao como encerrada antes do fechamento do CLI

Passos:
1. Ler o estado atual da sessao:
   - `git status --short --branch`
   - arquivos alterados
   - comandos relevantes executados durante a sessao
2. Executar `/daily-memory` usando o contexto da sessao atual
3. Criar ou atualizar `Relatorios/agent-sessions/YYYY-MM-DD-session.md`
   - se o arquivo do dia nao existir, criar
   - se ja existir, acrescentar uma nova secao ou continuacao em vez de apagar o historico
4. Atualizar `memory/_session-state.json` via script PowerShell:
   - Executar `.claude/hooks/session-close.ps1` usando a ferramenta Bash com o comando:
     `powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".claude/hooks/session-close.ps1"`
   - O script le o estado atual, define `close_done=true` e `close_at` com timestamp ISO completo, e salva preservando todos os campos existentes (startup_at, session_id, branch, etc.)
   - Nao editar o JSON manualmente — sempre usar o script para evitar perda de campos
5. Registrar no relatorio:
   - objetivo
   - arquivos alterados
   - comandos executados
   - decisoes
   - pendencias
   - proximos passos
6. Avaliar se alguma decisao deve subir para `MEMORY.md`
7. Auditar worktrees:
   - `git worktree list --porcelain`
   - identificar worktrees orfas, sujas ou elegiveis para limpeza
8. Responder com checklist final:
   - memoria atualizada
   - relatorio atualizado
   - marcador de sessao atualizado
   - pendencias abertas
   - worktrees que exigem atencao

Regras:
- este comando faz o fechamento rico; o hook `SessionEnd` nao substitui este passo
- nao remover worktrees sem confirmacao do usuario
- nao concluir a sessao sem atualizar memoria e relatorio
- se nao houve mudanca de arquivo, ainda assim registrar resumo e proximo passo
- se houver risco ou bloqueio, deixar explicito no fechamento

Formato sugerido:
```md
## Close Session

- memoria diaria: atualizada
- relatorio de sessao: atualizado
- marcador de sessao: atualizado
- pendencias: <nenhuma-ou-resumo>
- worktrees: <ok-ou-alertas>
- proximo passo sugerido: <acao>
```
