Gerenciar worktrees temporarios do workspace. O diretorio base e `.wt/` (ja ignorado pelo .gitignore).

Uso: /worktree <acao> [tipo] [nome] [branch]

Regra operacional:

- usar o workspace principal para triagem, GitHub e backlog
- criar worktree quando a issue ou task for entrar em execucao
- preferir uma issue ou task ativa por worktree
- quando houver item do GitHub, usar nome rastreavel como `gh-<numero>-<slug>` e branch `<prefixo>/<numero>-<slug>`

- `tipo`: `workspace` (padrao) ou `repo`
  - `workspace` — worktree do repo do proprio workspace (para isolar config, docs, experimentos)
  - `repo` — worktree de um repo interno em `repo/<nome>/` (git repo separado)

Acoes disponiveis:

## criar
Cria um novo worktree temporario.

Passos:

**Se tipo = workspace (padrao):**
1. Receber objetivo e branch (ou criar branch nova se nao existir)
2. Confirmar que o trabalho e do proprio workspace, e nao de um repo em `repo/`
3. Se a origem vier de backlog ou GitHub, manter o identificador da task no nome da branch e da worktree
4. Executar a partir de `claudeCode-workspace/`:
   ```
   git worktree add .wt/workspace/<objetivo> -b <branch>
   ```
   - Se branch ja existir: `git worktree add .wt/workspace/<objetivo> <branch>`
5. Confirmar criacao com `git worktree list --porcelain`
6. Se houver task correspondente no backlog, atualizar a coluna `Worktree` e a branch associada
7. Informar o caminho `.wt/workspace/<objetivo>`

**Se tipo = repo:**
1. Receber nome do repo (deve existir em `repo/<repo-name>/`), objetivo e branch
2. Verificar que `repo/<repo-name>/` existe e e um git repo valido
3. Se a tarefa vier do GitHub, preferir `objetivo = gh-<numero>-<slug>` e `branch = <prefixo>/<numero>-<slug>`
4. Confirmar se a task ja existe no backlog ou se o objetivo esta claro antes de abrir nova worktree
5. Executar a partir de `claudeCode-workspace/`:
   ```
   git -C repo/<repo-name> worktree add ../../.wt/<repo-name>/<objetivo> -b <branch>
   ```
   - Se branch ja existir: omitir `-b`
   - O caminho `../../.wt/` sobe de `repo/<repo-name>/` para `claudeCode-workspace/.wt/`
6. Confirmar criacao com `git -C repo/<repo-name> worktree list --porcelain`
7. Se houver task correspondente no backlog, atualizar `Branch` com `<branch>` e `Worktree` com `.wt/<repo-name>/<objetivo>`
8. Informar o caminho `.wt/<repo-name>/<objetivo>`

## listar
Lista todos os worktrees ativos.

Passos:
1. Executar: `git worktree list --porcelain` (worktrees do workspace)
2. Para cada repo em `repo/`, executar: `git -C repo/<repo-name> worktree list --porcelain`
3. Mostrar path, commit e branch de cada um
4. Indicar qual e o worktree principal de cada repo
5. Sinalizar worktrees sem branch clara, sem task rastreavel ou com nome fora do padrao

## remover
Remove um worktree temporario apos conclusao da tarefa.

Passos:

**Se tipo = workspace:**
1. Verificar mudancas: `git -C .wt/workspace/<objetivo> status`
2. Se houver mudancas, alertar e perguntar antes de prosseguir
3. Executar: `git worktree remove .wt/workspace/<objetivo>`
4. Executar: `git worktree prune`
5. Se houver task vinculada, limpar ou atualizar a coluna `Worktree`

**Se tipo = repo:**
1. Verificar mudancas: `git -C .wt/<repo-name>/<objetivo> status`
2. Se houver mudancas, alertar e perguntar antes de prosseguir
3. Executar: `git -C repo/<repo-name> worktree remove ../../.wt/<repo-name>/<objetivo>`
4. Executar: `git -C repo/<repo-name> worktree prune`
5. Se houver task vinculada, limpar ou atualizar a coluna `Worktree`

## limpar
Remove todos os worktrees temporarios de uma vez.

Passos:
1. Listar todos os worktrees com `git worktree list` e por repo
2. Para cada worktree em `.wt/`, verificar status de mudancas
3. Alertar se houver mudancas nao commitadas em qualquer um
4. Remover cada temporario elegivel com o comando adequado (workspace ou repo)
5. Executar `git worktree prune` e `git -C repo/<repo-name> worktree prune` para limpar refs

## Regras
- Nunca remover o worktree principal (nem do workspace nem de repos internos)
- Sempre verificar mudancas antes de remover
- Manter `.wt/workspace/` para worktrees do workspace e `.wt/<repo-name>/` para repos internos
- Apos remover, sempre rodar `worktree prune` no git repo correspondente
- Worktrees de repos internos usam o git do repo, nao o git do workspace
- Quando o git precisar apontar para outro diretorio, usar `git -C <path> ...`
- Evitar `cd <path> && git ...` para manter compatibilidade com `Bash(git:*)`
- Para trabalho vindo do GitHub, preferir uma relacao 1:1 entre issue, branch, worktree e PR
