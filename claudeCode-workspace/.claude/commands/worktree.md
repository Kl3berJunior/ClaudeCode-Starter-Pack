Gerenciar worktrees temporarios do workspace. O diretorio base e `.wt/` (ja ignorado pelo .gitignore).

Uso: /worktree <acao> [tipo] [nome] [branch]

- `tipo`: `workspace` (padrao) ou `repo`
  - `workspace` — worktree do repo do proprio workspace (para isolar config, docs, experimentos)
  - `repo` — worktree de um repo interno em `repo/<nome>/` (git repo separado)

Acoes disponiveis:

## criar
Cria um novo worktree temporario.

Passos:

**Se tipo = workspace (padrao):**
1. Receber objetivo e branch (ou criar branch nova se nao existir)
2. Executar a partir de `claudeCode-workspace/`:
   ```
   git worktree add .wt/workspace/<objetivo> -b <branch>
   ```
   - Se branch ja existir: `git worktree add .wt/workspace/<objetivo> <branch>`
3. Confirmar criacao com `git worktree list`
4. Informar o caminho `.wt/workspace/<objetivo>`

**Se tipo = repo:**
1. Receber nome do repo (deve existir em `repo/<repo-name>/`), objetivo e branch
2. Verificar que `repo/<repo-name>/` existe e e um git repo valido
3. Executar a partir de `claudeCode-workspace/`:
   ```
   git -C repo/<repo-name> worktree add ../../.wt/<repo-name>/<objetivo> -b <branch>
   ```
   - Se branch ja existir: omitir `-b`
   - O caminho `../../.wt/` sobe de `repo/<repo-name>/` para `claudeCode-workspace/.wt/`
4. Confirmar criacao com `git -C repo/<repo-name> worktree list`
5. Informar o caminho `.wt/<repo-name>/<objetivo>`

## listar
Lista todos os worktrees ativos.

Passos:
1. Executar: `git worktree list` (worktrees do workspace)
2. Para cada repo em `repo/`, executar: `git -C repo/<repo-name> worktree list`
3. Mostrar path, commit e branch de cada um
4. Indicar qual e o worktree principal de cada repo

## remover
Remove um worktree temporario apos conclusao da tarefa.

Passos:

**Se tipo = workspace:**
1. Verificar mudancas: `git -C .wt/workspace/<objetivo> status`
2. Se houver mudancas, alertar e perguntar antes de prosseguir
3. Executar: `git worktree remove .wt/workspace/<objetivo>`
4. Executar: `git worktree prune`

**Se tipo = repo:**
1. Verificar mudancas: `git -C .wt/<repo-name>/<objetivo> status`
2. Se houver mudancas, alertar e perguntar antes de prosseguir
3. Executar: `git -C repo/<repo-name> worktree remove ../../.wt/<repo-name>/<objetivo>`
4. Executar: `git -C repo/<repo-name> worktree prune`

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
