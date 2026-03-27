# USER

Contexto operacional do time para guiar o comportamento do agente.

Não colocar aqui segredos, tokens ou senhas.

## Time e ambiente

- linguagem principal dos backends: `__BACKEND_LANG__`
- linguagem principal dos frontends: `__FRONTEND_LANG__`
- ambiente principal de deploy: `__DEPLOY_ENV__`
- sistema operacional local: `__OS__`
- shell: `__SHELL__`

## Fluxo de trabalho

- todo trabalho de código via branch dedicada com prefixo convencional:
  - `feat/<objetivo>` — nova funcionalidade
  - `fix/<objetivo>` — correcao de bug
  - `chore/<objetivo>` — manutencao, configuracao, infraestrutura
  - `refactor/<objetivo>` — refatoracao sem mudanca de comportamento
  - `docs/<objetivo>` — documentacao
- PRs obrigatórias antes de mergear em `main`
- review explícita do usuário obrigatória antes do merge — o agente não mergea sem instrução direta
- mensagens de commit no formato convencional: `feat:`, `fix:`, `refactor:`, `chore:`, `docs:`
- após merge: deletar branch local e remoto, rodar `git remote prune origin`
- GitHub configurado com `delete_branch_on_merge=true` — branch remoto apagado automaticamente

## Política de worktrees

- raiz padrão: `.wt/`
- convenção de nome: `.wt/<repo-em-kebab-case>/<objetivo>`
- abrir nova worktree quando houver tarefa paralela ou isolamento de contexto necessário
- auditar worktrees no heartbeat de cada sessão
- nunca remover worktree com mudanças não commitadas sem confirmar antes
- limpeza autorizada pelo usuário ou quando a worktree estiver limpa e mergeada

## Testes

- testes de API: PowerShell (`pwsh`) em `tests/<repo>/<modulo>/`
- testes de frontend: Playwright (TypeScript) em `tests/<repo>/<modulo>/`
- diretórios criados sob demanda — não criar estrutura vazia antecipadamente
- todo fix com impacto visual deve ter teste de API e teste Playwright correspondente

## GitHub

- gh-username: `__GH_USERNAME__`

### Organizações e Projetos

Liste todas as orgs e projetos aos quais você tem acesso.
Formato: uma entrada por org, com seus projetos listados abaixo.

```
### Org `__GH_ORG_NAME__`
- login: __GH_ORG_LOGIN__
- projetos:
  - number: __GH_PROJECT_NUMBER__ | title: __GH_PROJECT_TITLE__ | descricao: __GH_PROJECT_DESC__
```

---

### Org `Tectrilha`
- login: tectrilha
- projetos:
  - number: 7 | title: Tectrilha | descricao: Projeto principal com todas as tarefas do time
  - number: 5 | title: TransparenciaWebNew | descricao: Projeto do sistema de transparência
  - number: 4 | title: Novo ContratoWeb | descricao: Projeto do sistema de contratos

- gh-username: `Kl3berJunior`

## Preferências do agente

- responder de forma concisa e direta
- tarefas independentes em paralelo sempre que possível
- não criar arquivos desnecessários (README, docs) salvo quando solicitado
- não mergear PR sem aprovação explícita do usuário
