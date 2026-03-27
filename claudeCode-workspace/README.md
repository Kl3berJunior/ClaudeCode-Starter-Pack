# ClaudeCode Starter Pack - Workspace

Workspace operacional para o Claude Code com MCPs, agentes, comandos e memoria estruturada.

## Estrutura

```
claudeCode-workspace/
|-- .claude/
|   |-- agents/          # Agentes especializados (review-deep, explain, agent-router)
|   |-- commands/        # Comandos slash customizados
|   |-- hooks/           # Hooks nativos de sessao e automacao
|   `-- settings.json    # Configuracao canonica de MCPs e permissoes
|-- .wt/                 # Worktrees temporarios (gitignored)
|-- memory/              # Memoria diaria (YYYY-MM-DD.md)
|   `-- _session-state.json  # Marcador local de sessao (nao versionado)
|-- repo/                # Repositorios de codigo governados pelo workspace
|   `-- CLAUDE.md        # Template de contrato para cada repo
|-- Relatorios/
|   |-- Swarm/           # task-backlog.md, supervisor-status.md
|   `-- agent-sessions/  # Relatorios de sessao por data
|-- CLAUDE.md            # Contrato operacional principal (importa os demais)
|-- SOUL.md              # Principios permanentes
|-- USER.md              # Contexto do time e ambiente
|-- TOOLS.md             # Comandos, caminhos e MCPs por repo
|-- MEMORY.md            # Memoria duravel
`-- HEARTBEAT.md         # Checklist de saude operacional
```

## MCPs habilitados

| Plugin | Uso principal |
|--------|---------------|
| `serena` | Leitura semantica de codigo, busca de simbolos e edicao com contexto |
| `context7` | Documentacao atualizada de bibliotecas, SDKs e APIs externas |
| `playwright` | Automacao de browser, testes visuais e captura de UI |
| `context-mode` | Gestao de contexto longo e tarefas multi-etapa |
| `telegram` | Notificacoes e interacao remota via bot |
| `commit-commands` | Fluxo padrao de commit, push e PR |

## Comandos disponiveis

| Comando | Descricao |
|---------|-----------|
| `/startup` | Executa o rito de abertura da sessao e resume contexto, memoria e alertas |
| `/heartbeat` | Verifica saude operacional do workspace |
| `/daily-memory` | Atualiza memoria diaria com fatos da sessao |
| `/close-session` | Executa o rito de encerramento e garante memoria e relatorio |
| `/backlog` | Gerencia tasks abertas em `Relatorios/Swarm/task-backlog.md` |
| `/worktree <acao>` | Cria, lista ou remove worktrees em `.wt/` |
| `/gh-project <acao>` | Consulta projetos do GitHub via `gh project` |
| `/delegate <numero> <org/repo>` | Le issue ou PR do GitHub e cria ou atualiza task no backlog |

## Agentes disponiveis

| Agente | Modelo | Uso |
|--------|--------|-----|
| `/review-deep <arquivo>` | Opus | Analise arquitetural profunda |
| `/explain <simbolo>` | Sonnet | Explicacao concisa de codigo |
| `/agent-router <tarefa>` | Sonnet | Roteamento automatico por complexidade |

## Fluxo de trabalho

### Inicio de sessao

```
1. SessionStart hook           - auto-inicializar a sessao e criar o marcador local
2. /startup (se necessario)    - auditar ou reparar o contexto da sessao
3. Ler o resumo retornado      - entender contexto herdado e riscos
4. Ler CLAUDE.md do repo alvo  - entender contrato local
```

### Trabalho em codigo

```
1. git checkout -b feat/<nome>  - criar branch dedicada (OBRIGATORIO)
2. Usar serena para navegar     - evitar leitura cega
3. Usar context7 para libs      - nao assumir contratos
4. Validar com testes e lint    - antes de commitar
5. gh pr create                 - abrir PR para review
```

### Encerramento de sessao

```
1. /close-session              - atualizar memoria, relatorio e marcador de sessao
2. Avaliar MEMORY.md           - promover conhecimento duravel
3. SessionEnd hook             - registrar saida leve ao fechar o CLI
4. Revisar worktrees           - propor limpeza apenas se elegivel
```

## Git

- Branch protegido: `main` nunca recebe commit direto
- Prefixos: `feat/`, `fix/`, `refactor/`, `chore/`, `docs/`
- Commits: conventional commits (`feat: ...`, `fix: ...`)
- PRs: sempre abrir PR e aguardar review explicita antes de merge

## Memoria

- Diaria: `memory/YYYY-MM-DD.md` - fatos, decisoes e riscos do dia
- Marcador local: `memory/_session-state.json` - estado de abertura e fechamento da sessao
- Duravel: `MEMORY.md` - contratos e decisoes que transcendem a sessao
- Operacional: `TOOLS.md` - caminhos, comandos e ferramentas por repo

## Adicionar um repositorio

1. Copiar `repo/CLAUDE.md` para o repo alvo
2. Substituir os placeholders: `__REPO_NAME__`, `__BUILD_COMMAND__`, `__TEST_COMMAND__`, `__LINT_COMMAND__`
3. Registrar o repo em `TOOLS.md` com caminho, comandos e worktree-root
4. Criar `Relatorios/<nome-do-repo>/` para artefatos do repo

## Seguranca

- Segredos nunca em arquivos versionados
- Configs locais sensiveis em `.claude/settings.local.json`
- Push, publicacao e acoes externas sempre com confirmacao do usuario
