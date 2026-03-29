# CLAUDE.md — ClaudeCode-Starter-Pack

Este repositorio e um **template base** para workspaces do Claude Code.
`claudeCode-workspace/` e o molde — nao um workspace real.

## Regra de ouro

**Nunca substituir placeholders por valores reais.**
`__WORKSPACE_ROOT__` e similares sao intencionais — o script de sync os
substitui em tempo de execucao.

## Fluxo de trabalho

### 1. Editar o template

Arquivos do template ficam em `claudeCode-workspace/`.
Se adicionar arquivo novo ou nova pasta de assets, atualizar tambem
`scripts/sync-starter-pack-to-workspace.ps1`.

### 2. Testar no sandbox

```powershell
# Criar sandbox em .tmp/claudeCode-workspace-temp
.\scripts\new-disposable-workspace.ps1

# Recriar do zero (apaga e recria)
.\scripts\new-disposable-workspace.ps1 -ForceRecreate

# Incluir settings.local do template no sandbox
.\scripts\new-disposable-workspace.ps1 -ForceRecreate -IncludeSettingsLocal
```

Abrir o Claude Code apontando para `.tmp/claudeCode-workspace-temp/`.

### 3. Sincronizar para workspace real

```powershell
.\scripts\sync-starter-pack-to-workspace.ps1 -TargetWorkspaceRoot 'C:\Caminho\Para\Workspace'
```

## O que atualizar no sync script

| O que mudou no template | O que revisar |
|---|---|
| Arquivo novo copiado diretamente | Adicionar em `$filesToCopy` |
| Nova pasta de assets (agents, hooks, rules) | Adicionar em `Get-RelativeFiles` |
| Arquivo com logica de merge (ex: TOOLS.md) | Criar/ajustar funcao `Merge-*` |
| Placeholder novo | Garantir que `Convert-WorkspaceText` o cobre |

## Estrutura

```text
ClaudeCode-Starter-Pack/
|-- CLAUDE.md              ← voce esta aqui
|-- scripts/
|   |-- sync-starter-pack-to-workspace.ps1
|   `-- new-disposable-workspace.ps1
|-- claudeCode-workspace/  ← template do workspace
`-- .tmp/                  ← sandboxes descartaveis (gitignored)
```

Documentacao detalhada: `README.md` e `guia.md`.
