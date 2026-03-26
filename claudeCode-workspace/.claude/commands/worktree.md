Gerenciar worktrees temporarios do workspace. O diretorio base e `.wt/` (ja ignorado pelo .gitignore).

Uso: /worktree <acao> [nome] [branch]

Acoes disponiveis:

## criar
Cria um novo worktree temporario.

Passos:
1. Receber nome da tarefa e branch (ou criar branch nova se nao existir)
2. Executar: `git worktree add .wt/<nome> <branch>`
   - Se a branch nao existir: `git worktree add -b <branch> .wt/<nome>`
3. Confirmar criacao com `git worktree list`
4. Informar o caminho `.wt/<nome>` para uso

## listar
Lista todos os worktrees ativos.

Passos:
1. Executar: `git worktree list`
2. Mostrar path, commit e branch de cada um
3. Indicar qual e o worktree principal

## remover
Remove um worktree temporario apos conclusao da tarefa.

Passos:
1. Verificar se ha mudancas nao commitadas: `git -C .wt/<nome> status`
2. Se houver mudancas, alertar e perguntar antes de prosseguir
3. Executar: `git worktree remove .wt/<nome>`
4. Confirmar remocao com `git worktree list`

## limpar
Remove todos os worktrees temporarios de uma vez.

Passos:
1. Listar worktrees com `git worktree list`
2. Para cada worktree em `.wt/`, verificar status de mudancas
3. Alertar se houver mudancas nao commitadas em qualquer um
4. Executar `git worktree remove` para cada temporario
5. Executar `git worktree prune` para limpar referencias obsoletas

## Regras
- Nunca remover o worktree principal
- Sempre verificar mudancas antes de remover
- Manter o `.wt/` como diretorio base padrao
- Apos remover, rodar `git worktree prune` para limpar refs
