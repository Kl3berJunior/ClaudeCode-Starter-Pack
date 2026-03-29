Iniciar a execucao de uma issue ou PR do GitHub como task operacional ativa no workspace.

Uso:
`/start-task <numero> <org/repo> <repo-interno> [tipo=issue|pr] [prefixo=feat|fix|chore|refactor|docs] [slug=<texto>]`

Exemplos:
- `/start-task 123 org/repo minha-api`
- `/start-task 123 org/repo minha-api tipo=issue prefixo=fix`
- `/start-task 45 org/repo portal-web tipo=pr prefixo=refactor slug=ajuste-cache`

Objetivo:
- sair da triagem e entrar em execucao sem perder rastreabilidade
- garantir que a demanda exista no backlog operacional local
- criar ou reutilizar a branch e a worktree corretas no repo alvo
- atualizar `Relatorios/Swarm/task-backlog.md` com status, branch e worktree

Passos obrigatorios:
1. Ler `USER.md` para entender orgs, projetos e convencoes do workspace.
2. Validar autenticacao com `gh auth status`.
3. Resolver o item no GitHub:
   - issue: `gh issue view <numero> --repo <org/repo> --json number,title,body,labels,assignees,state,url`
   - pr: `gh pr view <numero> --repo <org/repo> --json number,title,body,labels,assignees,state,url`
   - se `tipo` nao vier, tentar issue e depois PR
4. Validar que `repo/<repo-interno>/` existe e e um git repo valido.
5. Garantir a task de execucao no backlog:
   - demanda base: `gh:<org/repo>#<numero>`
   - task de execucao: `gh:<org/repo>#<numero>::<repo-interno>`
   - se existir apenas a umbrella task `::triage`, atualizar ou complementar sem perder a origem
6. Derivar os nomes de execucao:
   - `slug`: usar o informado ou derivar do titulo em kebab-case
   - `branch`: `<prefixo>/<numero>-<slug>`
   - `worktree`: `.wt/<repo-interno>/gh-<numero>-<slug>`
7. Auditar se a worktree ja existe:
   - `git -C repo/<repo-interno> worktree list --porcelain`
   - se ja existir worktree para a mesma issue, reutilizar em vez de duplicar
8. Se nao existir, criar:
   - `git -C repo/<repo-interno> worktree add ../../.wt/<repo-interno>/gh-<numero>-<slug> -b <prefixo>/<numero>-<slug>`
   - se a branch ja existir, omitir `-b`
9. Atualizar o backlog:
   - `Status`: `in-progress`
   - `Branch`: `<prefixo>/<numero>-<slug>`
   - `Worktree`: `.wt/<repo-interno>/gh-<numero>-<slug>`
10. Atualizar `Relatorios/Swarm/supervisor-status.md`.

Formato canonico da linha no backlog:
```md
| gh:<org/repo>#<numero>::<repo-interno> | <repo-interno> | <titulo> | in-progress | <prioridade> | <prefixo>/<numero>-<slug> | .wt/<repo-interno>/gh-<numero>-<slug> | <url> |
```

Regras:
- o GitHub continua sendo a fonte de verdade da demanda
- o backlog local guarda apenas o recorte operacional ativo
- preferir uma task de execucao por worktree
- para demandas multi-repo, repetir `/start-task` uma vez por repo ou faixa de mudanca
- nao abrir worktree nova se ja existir uma equivalente para a mesma issue
- se o item estiver fechado, merged ou cancelado, pedir confirmacao antes de iniciar
- worktree `workspace` nao deve ser usada para issues de produto

Resposta esperada:
- id da task
- tipo detectado
- repo interno escolhido
- branch final
- worktree final
- status final no backlog
- origem no GitHub
