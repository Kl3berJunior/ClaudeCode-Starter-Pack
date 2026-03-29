# CLAUDE.md - Workspace `__WORKSPACE_ROOT__`

Bootstrap curto do workspace para o Claude Code.

`CLAUDE.md` deve permanecer enxuto. Regras duraveis por tema ou por caminho
devem viver em `.claude/rules/`, como recomendado na documentacao do Claude
Code.

@SOUL.md
@MEMORY.md

## Estrutura de instrucoes

- `.claude/settings.json` e a fonte canonica de hooks, permissoes e plugins
- `.claude/rules/` concentra regras globais e regras condicionais por path
- `TOOLS.md`, `USER.md` e `README.md` sao referencia humana e devem ser lidos
  sob demanda
- `repo/CLAUDE.md` e o template para contratos locais dos repositorios
- `CLAUDE.local.md` e o lugar recomendado para preferencias locais privadas

## Fluxo minimo de sessao

- confiar no `SessionStart` para inicializacao minima e no `UserPromptSubmit`
  para bloquear sessoes invalidas
- se o estado da sessao estiver duvidoso, executar `/startup`
- antes de encerrar o CLI, executar `/close-session`
- o starter pack nao deve guardar memoria diaria, relatorios datados ou ajustes
  locais como parte do template versionado
