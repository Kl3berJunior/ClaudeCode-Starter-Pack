Capturar demanda do GitHub Project para o fluxo operacional do workspace.

Uso:
`/pickup <acao> [argumentos]`

Acoes disponiveis:
- `listar [org=<login>] [project=<numero>] [query="<filtro>"] [limit=<n>]`
- `planejar <numero> <org/repo> [tipo=issue|pr] [repos=<repo1,repo2>] [prefixo=feat|fix|chore|refactor|docs]`
- `executar <numero> <org/repo> [tipo=issue|pr] [repos=<repo1,repo2>] [prefixo=feat|fix|chore|refactor|docs]`

Objetivo:
- listar candidatos do GitHub Project
- garantir que a demanda exista no backlog operacional local
- sugerir ou iniciar as tasks de execucao certas por repo
- reduzir a passagem manual entre `/gh-project`, `/delegate` e `/start-task`

Passos comuns:
1. Ler `USER.md` para resolver owner, projetos e convencoes.
2. Ler `TOOLS.md` para descobrir os repos internos registrados.
3. Validar autenticacao com `gh auth status`.
4. Se faltar escopo `project`, orientar:
   - `gh auth refresh -s project`
5. Resolver defaults de `org` e `project` a partir de `USER.md`.
6. Ler `Relatorios/Swarm/task-backlog.md` para cruzar o estado operacional atual.

## listar

Objetivo:
- mostrar itens do Project com contexto suficiente para decidir o pickup

Passos:
1. Executar `gh project item-list <project> --owner <org> --limit <n> --format json`
2. Se `query` vier informada, aplicar o filtro suportado pelo comando ou filtrar localmente na saida
3. Para cada item, destacar:
   - tipo (`issue` ou `pr`)
   - numero
   - repositorio de origem
   - titulo
   - status do Project, se disponivel
   - se ja existe umbrella task `::triage` no backlog
   - se ja existem tasks de execucao abertas para a mesma demanda
4. Ordenar a resposta priorizando:
   - itens do Project sem task local
   - itens com umbrella task mas sem execucao aberta
   - itens ja em execucao

Formato sugerido:
```md
## Pickup do Project <org>/<project>

- [issue #123] Corrigir login social
  repo-origem: org/repo
  backlog: sem task local
  sugestao: /pickup planejar 123 org/repo
```

## planejar

Objetivo:
- transformar a demanda em plano operacional sem criar worktree automaticamente

Passos:
1. Resolver o item no GitHub:
   - issue: `gh issue view <numero> --repo <org/repo> --json number,title,body,labels,assignees,state,url`
   - pr: `gh pr view <numero> --repo <org/repo> --json number,title,body,labels,assignees,state,url`
   - se `tipo` nao vier, tentar issue e depois PR
2. Garantir a umbrella task local equivalente ao `/delegate`:
   - `gh:<org/repo>#<numero>::triage`
3. Inferir os repos de execucao:
   - usar `repos=` se vier explicito
   - senao procurar mencoes a repos registrados em `TOOLS.md`
   - considerar labels, titulo e body para identificar `frontend`, `backend`, `web`, `api`, `externo`, `interno`
   - se houver apenas um repo plausivel, sugeri-lo
   - se houver varios repos plausiveis, listar todos como candidatos
   - se a inferencia for fraca, nao iniciar execucao automaticamente
4. Gerar sugestoes de `/start-task` por repo sugerido
5. Se a demanda parecer multi-repo, sinalizar isso explicitamente

Formato sugerido:
```md
## Plano de pickup

- demanda: gh:<org/repo>#<numero>
- umbrella task: criada ou atualizada
- repos sugeridos:
  - frontend-interno -> /start-task <numero> <org/repo> frontend-interno
  - backend-externo -> /start-task <numero> <org/repo> backend-externo
```

## executar

Objetivo:
- sair do Project e entrar em execucao com o menor atrito possivel

Passos:
1. Executar tudo o que esta em `planejar`
2. Se `repos=` vier explicito:
   - executar `/start-task` para cada repo informado
3. Se `repos=` nao vier:
   - executar `/start-task` automaticamente apenas quando houver um unico repo plausivel
   - se houver varios repos plausiveis, parar no plano e pedir confirmacao
4. Consolidar a resposta final com:
   - umbrella task local
   - tasks de execucao criadas
   - branches
   - worktrees

Regras:
- `listar` nao altera backlog nem worktrees
- `planejar` pode criar ou atualizar a umbrella task `::triage`, mas nao deve abrir worktree
- `executar` so deve abrir worktree sem confirmacao adicional quando a inferencia de repo for clara ou `repos=` vier explicito
- uma demanda pode gerar varias tasks de execucao
- uma task de execucao deve mapear para um repo, uma branch e uma worktree
- o GitHub continua sendo a fonte de verdade da demanda

Resposta esperada em `executar`:
- demanda base
- umbrella task
- lista de tasks de execucao criadas ou sugeridas
- comandos ou paths finais das worktrees
