# USER

Contexto operacional do time para guiar o comportamento do agente.

Nao colocar aqui segredos, tokens ou senhas.
Ao instalar o template, substitua todos os placeholders `__...__` antes de usar
o workspace em producao.

## Time e ambiente

- linguagem principal dos backends: `__BACKEND_LANG__`
- linguagem principal dos frontends: `__FRONTEND_LANG__`
- ambiente principal de deploy: `__DEPLOY_ENV__`
- sistema operacional local: `__OS__`
- shell: `__SHELL__`

## Fluxo de trabalho

- todo trabalho de codigo via branch dedicada com prefixo convencional:
  - `feat/<objetivo>` - nova funcionalidade
  - `fix/<objetivo>` - correcao de bug
  - `chore/<objetivo>` - manutencao, configuracao, infraestrutura
  - `refactor/<objetivo>` - refatoracao sem mudanca de comportamento
  - `docs/<objetivo>` - documentacao
- PRs obrigatorias antes de mergear em `main`
- review explicita do usuario obrigatoria antes do merge - o agente nao mergea sem instrucao direta
- mensagens de commit no formato convencional: `feat:`, `fix:`, `refactor:`, `chore:`, `docs:`
- commit e PR devem ter descricao rica, com contexto, mudancas principais, validacao e risco
- apos merge: deletar branch local e remoto, rodar `git remote prune origin`
- GitHub configurado com `delete_branch_on_merge=true` - branch remoto apagado automaticamente

## Politica de worktrees

- raiz padrao: `.wt/`
- convencao de nome: `.wt/workspace/<objetivo>` para trabalho no workspace, `.wt/<repo-em-kebab-case>/<objetivo>` para repos internos
- usar o workspace principal para triagem e orquestracao; abrir worktree quando a task entrar em execucao
- preferir uma issue ou task ativa por worktree
- quando a mesma demanda afetar varios repos, abrir uma task de execucao por repo ou faixa de mudanca
- quando a origem vier do GitHub, incluir o numero da issue ou PR no nome da branch e da worktree
- abrir nova worktree quando houver tarefa paralela ou isolamento de contexto necessario
- auditar worktrees no heartbeat de cada sessao
- nunca remover worktree com mudancas nao commitadas sem confirmar antes
- limpeza autorizada pelo usuario ou quando a worktree estiver limpa e mergeada

## Testes

- testes de API: PowerShell (`pwsh`) em `tests/<repo>/<modulo>/`
- testes de frontend: Playwright (TypeScript) em `tests/<repo>/<modulo>/`
- diretorios criados sob demanda - nao criar estrutura vazia antecipadamente
- todo fix com impacto visual deve ter teste de API e teste Playwright correspondente

## GitHub

- gh-username: `__GH_USERNAME__`

### Organizacoes e Projetos

Liste todas as orgs e projetos aos quais voce tem acesso.
Formato: uma entrada por org, com seus projetos listados abaixo.

```
### Org `__GH_ORG_NAME__`
- login: __GH_ORG_LOGIN__
- projetos:
  - number: __GH_PROJECT_NUMBER__ | title: __GH_PROJECT_TITLE__ | descricao: __GH_PROJECT_DESC__
```

## Preferencias do agente

- responder de forma concisa e direta
- tarefas independentes em paralelo sempre que possivel
- nao criar arquivos desnecessarios (README, docs) salvo quando solicitado
- nao mergear PR sem aprovacao explicita do usuario
