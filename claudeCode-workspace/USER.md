# USER

Contexto operacional do workspace ClaudeCode-Starter-Pack.

## Linguagens e Tecnologias

- Linguagem principal: TypeScript/JavaScript, Python, Markdown
- Ambiente: Desenvolvimento local com Node.js, Git
- Frameworks: Claude Code, MCPs/plugins

## Ambiente de Deploy

- Local development only
- No production deployment configured yet

## Horario de Trabalho

- Desenvolvimento contínuo conforme necessidade
- Memória diária atualizada diariamente

## Políticas de Git

- Branches: usar `feat/`, `fix/`, `refactor/`, `chore/` prefixes
- Commits: conventional commits (feat:, fix:, etc.)
- PRs: criar PRs para mudanças significativas
- Worktrees: usar para isolamento de tarefas

## Políticas de Segurança

- Não armazenar segredos em arquivos versionados
- Usar `.claude/settings.local.json` para configurações locais
- Validar mudanças antes de commit/push

## Worktrees

- Raiz padrão para worktrees: `.wt/`
- Convenção de nome: `repo/objetivo` ou `repo/branch`
- Critério para abrir nova worktree: quando trabalhar em feature/task específica
- Tempo máximo de ociosidade: auditar semanalmente worktrees inativas
- Autorização para remoção: maintainer do workspace pode autorizar
