# Git e worktrees

- Use branch dedicada antes de editar codigo: `feat/`, `fix/`, `chore/`,
  `refactor/` ou `docs/`.
- Nunca commite diretamente em `main` ou `master`.
- Nao reverta trabalho alheio e nao use `--no-verify`, `--force-push` ou merge
  sem instrucao explicita.
- Commits e PRs devem ter descricao rica com contexto, principais mudancas,
  validacao e risco.
- Nenhum PR deve ser mergeado sem review explicita do usuario.
- Use o workspace principal para triagem, backlog e GitHub; crie worktree quando
  a issue ou task entrar em execucao.
- Worktrees operacionais vivem em `.wt/`.
- Para o workspace: `.wt/workspace/<objetivo-ou-branch>`.
- Para repos internos: `.wt/<repo-em-kebab-case>/<objetivo-ou-branch>`.
- Prefira uma issue ou task ativa por worktree.
- Quando a mesma demanda afetar varios repos, desdobre em varias tasks de
  execucao e abra uma worktree por repo ou faixa clara de mudanca.
- Quando houver item do GitHub, prefira nomes rastreaveis como
  `.wt/<repo>/gh-<numero>-<slug>` e branch `<prefixo>/<numero>-<slug>`.
- Antes de criar worktree, audite o estado atual com `git worktree list
  --porcelain`.
- Ao operar git fora do diretorio atual, prefira `git -C <path> ...` em vez de
  `cd <path> && git ...`.
- Proponha limpeza de worktrees elegiveis, mas peca confirmacao antes de
  remover.
