Delegar uma issue ou PR do GitHub para o backlog operacional do workspace.

Uso:
`/delegate <numero> <org/repo> [tipo=issue|pr] [prioridade=high|medium|low] [status=open|in-progress|blocked|done|cancelled]`

Exemplos:
- `/delegate 123 org/repo`
- `/delegate 123 org/repo tipo=issue prioridade=high`
- `/delegate 45 org/repo tipo=pr status=in-progress`

Objetivo:
- buscar o contexto completo da issue ou PR no GitHub
- criar ou atualizar a task correspondente em `Relatorios/Swarm/task-backlog.md`
- manter `Relatorios/Swarm/supervisor-status.md` sincronizado

Passos obrigatorios:
1. Ler `USER.md` para obter o contexto GitHub do workspace.
2. Validar autenticacao com `gh auth status`.
3. Se o token estiver invalido ou sem permissao suficiente, parar e orientar:
   - `gh auth login -h github.com`
4. Validar argumentos:
   - `numero` e obrigatorio
   - `org/repo` e obrigatorio
   - `tipo`, `prioridade` e `status` sao opcionais
5. Garantir que existem:
   - `Relatorios/Swarm/task-backlog.md`
   - `Relatorios/Swarm/supervisor-status.md`
   Se nao existirem, criar com cabecalho padrao do workspace.

## Resolucao do item

Se `tipo=issue`:
- executar `gh issue view <numero> --repo <org/repo> --json number,title,body,labels,assignees,state,url`

Se `tipo=pr`:
- executar `gh pr view <numero> --repo <org/repo> --json number,title,body,labels,assignees,state,url`

Se `tipo` nao for informado:
1. tentar como issue
2. se falhar por nao encontrado, tentar como PR
3. se ambos falharem, reportar erro e nao alterar backlog

## Regras de derivacao

Id da task:
- usar formato estavel de umbrella task: `gh:<org/repo>#<numero>::triage`

Repo:
- usar `-` quando a demanda ainda nao estiver associada a um repo de execucao

Titulo:
- usar o `title` retornado pelo GitHub

Origem:
- usar a `url` do item

Status:
- se informado pelo usuario, respeitar
- senao usar `open` por padrao
- se o item estiver fechado ou merged, parar e pedir confirmacao antes de criar task no backlog

Prioridade:
- se informada pelo usuario, respeitar
- senao tentar inferir por labels:
  - `high`, `priority:high`, `prio:high` -> `high`
  - `medium`, `priority:medium`, `prio:medium` -> `medium`
  - `low`, `priority:low`, `prio:low` -> `low`
- se nao houver label util, usar `medium`

## Escrita no backlog

Formato canonico:
`| TaskId | Repo | Titulo | Status | Prioridade | Branch | Worktree | Origem |`

Regras:
1. Ler `Relatorios/Swarm/task-backlog.md`
2. Se existir `_Nenhuma task aberta._` e for adicionar a primeira task, remover essa linha
3. Se ja existir linha com o mesmo `TaskId`, atualizar a linha em vez de duplicar
4. Ao delegar a task pela primeira vez, inicializar `Repo`, `Branch` e `Worktree` com `-`
5. Se nao existir, adicionar nova linha mantendo a tabela Markdown valida
6. Nunca apagar outras tasks

Formato da linha:
```md
| gh:<org/repo>#<numero>::triage | - | <titulo> | <status> | <prioridade> | - | - | <url> |
```

## Sincronizacao do supervisor

Passos:
1. Recontar tasks abertas em `task-backlog.md`
   - considerar abertas: `open`, `in-progress`, `blocked`
2. Recontar tasks bloqueadas
3. Atualizar `Relatorios/Swarm/supervisor-status.md`:
   - `Atualizado em: <data-de-hoje>`
   - `Tasks abertas: <N>`
   - `Tasks bloqueadas: <N>`
4. Preservar notas existentes quando possivel

Se o arquivo nao existir, criar neste formato:
```md
# Supervisor Status

Atualizado em: <YYYY-MM-DD>

## Resumo

- Tasks abertas: <N>
- Tasks bloqueadas: <N>
- Worktrees ativas: 0
- Ultimo heartbeat: <YYYY-MM-DD ou desconhecido>

## Notas

- Atualizado por /delegate
```

## Resposta ao usuario

Depois de atualizar os arquivos, responder com:
- tipo detectado: `issue` ou `pr`
- identificador da task criada ou atualizada
- titulo
- status e prioridade finais
- assignees, se houver
- labels, se houver
- resumo curto do body em no maximo 3 linhas
- origem no GitHub

Formato sugerido:
```md
Task delegada com sucesso.

- id: gh:<org/repo>#<numero>::triage
- tipo: <issue-ou-pr>
- repo: -
- titulo: <titulo>
- status: <status>
- prioridade: <prioridade>
- origem: <url>
```

## Regras operacionais
- este comando nao executa merge
- este comando nao altera issue, PR ou project no GitHub; apenas le metadados
- este comando cria a umbrella task local; `/start-task` e o responsavel por abrir a execucao por repo
- o GitHub continua sendo a fonte de verdade da demanda
- se a task ja existir no backlog, atualizar em vez de duplicar
- se o item estiver fechado, cancelado ou merged, confirmar com o usuario antes de delegar
- em caso de erro do `gh`, nao editar backlog parcialmente

## Erros comuns
- `Failed to log in`: executar `gh auth login -h github.com`
- issue ou PR nao encontrada: conferir `numero` e `org/repo`
- backlog sem cabecalho: recriar o cabecalho canonico antes de inserir a linha
- titulo com pipe `|`: escapar ou substituir antes de escrever na tabela Markdown
