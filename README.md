# ClaudeCode-Starter-Pack

Template de workspace para Claude Code com foco em:

- hooks de sessao
- regras modulares em `.claude/rules/`
- memoria diaria e memoria duravel separadas
- worktrees rastreaveis
- comandos e agentes compartilhados

## O que mudou na arquitetura

O bootstrap do workspace agora fica curto em `claudeCode-workspace/CLAUDE.md`.
As regras foram quebradas em arquivos menores dentro de
`claudeCode-workspace/.claude/rules/`, seguindo a recomendacao da documentacao
do Claude Code para projetos maiores.

Isso reduz acoplamento, facilita manutencao e permite regras por path, em vez de
concentrar tudo em um unico `CLAUDE.md`.

## Estrutura principal

```text
ClaudeCode-Starter-Pack/
|-- .gitignore
|-- README.md
|-- guia.md
|-- scripts/
|   |-- sync-starter-pack-to-workspace.ps1
|   `-- new-disposable-workspace.ps1
`-- claudeCode-workspace/
    |-- .claude/
    |   |-- agents/
    |   |-- commands/
    |   |-- hooks/
    |   |-- rules/
    |   `-- settings.json
    |-- .serena/
    |-- Relatorios/
    |-- memory/
    |-- repo/
    |-- .gitignore
    |-- CLAUDE.md
    |-- SOUL.md
    |-- MEMORY.md
    |-- TOOLS.md
    |-- USER.md
    `-- HEARTBEAT.md
```

## Onde guardar cada tipo de regra

- regra curta e sempre carregada: `CLAUDE.md`
- regra modular do projeto: `.claude/rules/*.md`
- preferencia local privada: `CLAUDE.local.md`
- configuracao local privada: `.claude/settings.local.json`
- memoria duravel: `MEMORY.md`
- memoria do dia: `memory/YYYY-MM-DD.md`

## Scripts

### Sincronizar para um workspace real

```powershell
.\scripts\sync-starter-pack-to-workspace.ps1 -TargetWorkspaceRoot 'C:\Work\MeuWorkspace'
.\scripts\sync-starter-pack-to-workspace.ps1 -TargetWorkspaceRoot 'C:\Work\MeuWorkspace' -MergeSourceSettingsLocal
```

O script agora sincroniza tambem:

- `.claude/rules/`
- `.serena/.gitignore`
- `.serena/project.yml`

Por padrao ele nao propaga `.claude/settings.local.json` do template. Se voce
quiser isso, use `-MergeSourceSettingsLocal`.

### Criar um workspace descartavel para testes

```powershell
.\scripts\new-disposable-workspace.ps1
.\scripts\new-disposable-workspace.ps1 -Name 'teste-rules' -ForceRecreate
```

Esse script cria um sandbox dentro de `.tmp/`, reseta runtime local e so replica
`settings.local.json` se voce pedir explicitamente.

## Gitignore

Revisoes aplicadas:

- suporte a `CLAUDE.local.md`
- runtime de `.claude/worktrees/`
- runtime do Serena em `.serena/.gitignore`
- manutencao de `.tmp/` como area descartavel do repositorio

## Referencias

- Guia detalhado: [guia.md](/c:/Sistema/ClaudeCode-Starter-Pack/guia.md)
- Workspace: [claudeCode-workspace/README.md](/c:/Sistema/ClaudeCode-Starter-Pack/claudeCode-workspace/README.md)
- Documentacao oficial usada como base:
  - https://code.claude.com/docs/en/memory
  - https://code.claude.com/docs/en/claude-directory
  - https://code.claude.com/docs/en/hooks
  - https://code.claude.com/docs/en/common-workflows
