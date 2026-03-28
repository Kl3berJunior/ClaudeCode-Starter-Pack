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

Observacao:

- o starter pack deve nascer sem memoria diaria ou relatorios datados; esses artefatos sao gerados ao longo do uso por hooks e commands

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
| `/commit-commands:commit` | Cria commit local com titulo convencional e corpo rico |
| `/commit-commands:commit-push-pr` | Cria commit, faz push e abre PR com descricao rica |
| `/commit-commands:clean_gone` | Limpa branches locais `[gone]` e worktrees associadas |

## Fluxo de commands

| Etapa | Sequencia recomendada |
|-------|-----------------------|
| Abrir sessao | hooks -> `/startup` se necessario -> `/heartbeat` se houver risco ou duvida |
| Trazer demanda do GitHub | `/gh-project` -> `/delegate` -> `/backlog` |
| Executar task local | `/backlog` -> `/worktree` se precisar de isolamento -> execucao |
| Finalizar entrega | validar mudanca -> `/commit-commands:commit` ou `/commit-commands:commit-push-pr` |
| Limpeza pos-merge | atualizar `main` -> `/commit-commands:clean_gone` |
| Registrar sessao longa | `/daily-memory` |
| Encerrar | `/close-session` |

## Agentes disponiveis

| Agente | Modelo | Uso |
|--------|--------|-----|
| `/review-deep <arquivo>` | Opus | Analise arquitetural profunda |
| `/explain <simbolo>` | Sonnet | Explicacao concisa de codigo |
| `/agent-router <tarefa>` | Sonnet | Roteamento automatico por contexto operacional |

## Fluxo de trabalho

### Inicio de sessao

```
1. SessionStart hook           - auto-inicializar a sessao e criar o marcador local
2. /startup (se necessario)    - auditar ou reparar o contexto da sessao
3. Ler o resumo retornado      - entender contexto herdado e riscos
4. /heartbeat (se houver risco) - verificar saude operacional
5. Ler CLAUDE.md do repo alvo  - entender contrato local
```

### Triagem de demanda

```
1. /backlog                    - ver ou atualizar fila local
2. /gh-project                 - descobrir demanda ainda nao internalizada
3. /delegate                   - transformar issue/PR em task rastreavel
4. /backlog                    - confirmar status e prioridade finais
```

### Trabalho em codigo

```
1. /worktree (se necessario)    - isolar execucao e branch
2. git checkout -b feat/<nome>  - criar branch dedicada (OBRIGATORIO)
3. Usar serena para navegar     - evitar leitura cega
4. Usar context7 para libs      - nao assumir contratos
5. Validar com testes e lint    - antes de commitar
6. /commit-commands:commit      - criar commit local com descricao rica
7. /commit-commands:commit-push-pr - abrir PR com descricao rica quando a entrega ja puder seguir
```

### Encerramento de sessao

```
1. /daily-memory (se a sessao foi longa) - registrar fatos antes de perder contexto
2. /close-session                        - atualizar memoria, relatorio e marcador de sessao
3. Avaliar MEMORY.md                     - promover conhecimento duravel
4. SessionEnd hook                       - registrar saida leve ao fechar o CLI
5. Revisar worktrees                     - propor limpeza apenas se elegivel
```

## Git

- Branch protegido: `main` nunca recebe commit direto
- Prefixos: `feat/`, `fix/`, `refactor/`, `chore/`, `docs/`
- Commits: conventional commits (`feat: ...`, `fix: ...`)
- Commit e PR: devem ter descricao rica com contexto, mudancas, validacao e risco
- PRs: sempre abrir PR e aguardar review explicita antes de merge

## Memoria

- Diaria: `memory/YYYY-MM-DD.md` - fatos, decisoes e riscos do dia
- Marcador local: `memory/_session-state.json` - estado de abertura e fechamento da sessao
- Duravel: `MEMORY.md` - contratos e decisoes que transcendem a sessao
- Operacional: `TOOLS.md` - caminhos, comandos e ferramentas por repo
- Relatorios de sessao: `Relatorios/agent-sessions/YYYY-MM-DD-session.md` - criados por `/close-session`, sem exemplos datados no template

## Adicionar um repositorio

1. Copiar `repo/CLAUDE.md` para o repo alvo
2. Substituir os placeholders: `__REPO_NAME__`, `__BUILD_COMMAND__`, `__TEST_COMMAND__`, `__LINT_COMMAND__`
3. Ajustar `__WORKSPACE_ROOT__` tambem em `.claude/settings.json` para o `--project-path` do Serena
4. Registrar o repo em `TOOLS.md` com caminho, comandos e worktree-root
5. Criar `Relatorios/<nome-do-repo>/` para artefatos do repo

## Seguranca

- Segredos nunca em arquivos versionados
- Configs locais sensiveis em `.claude/settings.local.json`
- Push, publicacao e acoes externas sempre com confirmacao do usuario
