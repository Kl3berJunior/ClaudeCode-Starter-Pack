# ClaudeCode Starter Pack — Workspace

Workspace operacional para o Claude Code com MCPs, agentes, comandos e memoria estruturada.

## Estrutura

```
claudeCode-workspace/
├── .claude/
│   ├── agents/          # Agentes especializados (review-deep, explain, agent-router)
│   ├── commands/        # Comandos slash customizados (/backlog, /heartbeat, /daily-memory, /worktree)
│   └── settings.json    # Configuracao canonica de MCPs e permissoes
├── .wt/                 # Worktrees temporarios (gitignored)
├── memory/              # Memoria diaria (YYYY-MM-DD.md)
├── repo/                # Repositorios de codigo governados pelo workspace
│   └── CLAUDE.md        # Template de contrato para cada repo
├── Relatorios/
│   ├── Swarm/           # task-backlog.md, supervisor-status.md
│   └── agent-sessions/  # Relatorios de sessao por data
├── CLAUDE.md            # Contrato operacional principal (importa os demais)
├── SOUL.md              # Principios permanentes
├── USER.md              # Contexto do time e ambiente
├── TOOLS.md             # Comandos, caminhos e MCPs por repo
├── MEMORY.md            # Memoria duravel
└── HEARTBEAT.md         # Checklist de saude operacional
```

## MCPs habilitados

| Plugin | Uso principal |
|--------|--------------|
| `serena` | Leitura semantica de codigo, busca de simbolos, edicao com contexto |
| `context7` | Documentacao atualizada de bibliotecas, SDKs e APIs externas |
| `playwright` | Automacao de browser, testes visuais, captura de UI |
| `context-mode` | Gestao de contexto longo, tarefas multi-etapa |
| `telegram` | Notificacoes e interacao remota via bot |
| `commit-commands` | Fluxo padrao de commit, push e PR |

## Comandos disponiveis

| Comando | Descricao |
|---------|-----------|
| `/heartbeat` | Verifica saude operacional do workspace |
| `/daily-memory` | Atualiza memoria diaria com fatos da sessao |
| `/backlog` | Gerencia tasks abertas em `Relatorios/Swarm/task-backlog.md` |
| `/worktree <acao>` | Cria, lista ou remove worktrees em `.wt/` |

## Agentes disponiveis

| Agente | Modelo | Uso |
|--------|--------|-----|
| `/review-deep <arquivo>` | Opus | Analise arquitetural profunda |
| `/explain <simbolo>` | Sonnet | Explicacao concisa de codigo |
| `/agent-router <tarefa>` | Sonnet | Roteamento automatico por complexidade |

## Fluxo de trabalho

### Inicio de sessao
```
1. /heartbeat                  — verificar estado do workspace
2. /daily-memory               — confirmar memoria do dia
3. Ler CLAUDE.md do repo alvo  — entender contrato local
```

### Trabalho em codigo
```
1. git checkout -b feat/<nome>  — criar branch dedicada (OBRIGATORIO)
2. Usar serena para navegar     — evitar leitura cega
3. Usar context7 para libs      — nao assumir contratos
4. Validar com testes/lint      — antes de commitar
5. gh pr create                 — abrir PR para review
```

### Encerramento de sessao
```
1. /daily-memory               — registrar fatos e decisoes
2. Avaliar MEMORY.md           — promover conhecimento duravel
3. /worktree limpar            — remover worktrees elegíveis
```

## Git

- Branch protegido: `main` nunca recebe commit direto
- Prefixos: `feat/`, `fix/`, `refactor/`, `chore/`
- Commits: conventional commits (`feat: ...`, `fix: ...`)
- PRs: sempre abrir PR, aguardar review explicita antes de merge

## Memoria

- **Diaria**: `memory/YYYY-MM-DD.md` — fatos, decisoes, riscos do dia
- **Duravel**: `MEMORY.md` — contratos e decisoes que transcendem a sessao
- **Operacional**: `TOOLS.md` — caminhos, comandos e ferramentas por repo

## Adicionar um repositorio

1. Copiar `repo/CLAUDE.md` para o repo alvo
2. Substituir os placeholders: `__REPO_NAME__`, `__BUILD_COMMAND__`, `__TEST_COMMAND__`, `__LINT_COMMAND__`
3. Registrar o repo em `TOOLS.md` com caminho, comandos e worktree-root
4. Criar `Relatorios/<nome-do-repo>/` para artefatos do repo

## Seguranca

- Segredos nunca em arquivos versionados
- Configs locais sensiveis em `.claude/settings.local.json`
- Push, publicacao e acoes externas sempre com confirmacao do usuario
