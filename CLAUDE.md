# CLAUDE.md — ClaudeCode-Starter-Pack

Este repositorio e um **template base** para workspaces do Claude Code.
O codigo aqui nao e um workspace real — e o molde que gera workspaces reais.

## Papel deste repositorio

- `claudeCode-workspace/` e o template canônico do workspace
- `scripts/` contem os scripts de sincronizacao e criacao de sandbox
- `.tmp/` e a area descartavel para testes (ignorada pelo git)

## Regra de ouro

**Nunca substituir placeholders por valores reais.**
`__WORKSPACE_ROOT__` e similares sao intencionais — o script de sync os
substitui em tempo de execucao.

## Fluxo de trabalho aqui na raiz

### Fazer uma melhoria no template

1. Editar os arquivos dentro de `claudeCode-workspace/`
2. Se adicionar arquivo novo ou mudar estrutura de pastas, atualizar
   `scripts/sync-starter-pack-to-workspace.ps1` tambem
3. Testar no workspace descartavel antes de commitar

### Testar no workspace descartavel

```powershell
# Criar (ou recriar) o sandbox em .tmp/claudeCode-workspace-temp
.\scripts\new-disposable-workspace.ps1 -ForceRecreate

# Abrir Claude Code no sandbox para validar
```

O sandbox vive em `.tmp/claudeCode-workspace-temp/` e pode ser
descartado e recriado quantas vezes quiser.

### Sincronizar para um workspace real

```powershell
.\scripts\sync-starter-pack-to-workspace.ps1 -TargetWorkspaceRoot 'C:\Caminho\Para\Workspace'
```

## O que atualizar quando mudar o template

| O que mudou | O que revisar |
|---|---|
| Arquivo novo em `claudeCode-workspace/` | Adicionar em `$filesToCopy` no sync script |
| Nova pasta de assets (agents, hooks, rules) | Adicionar em `Get-RelativeFiles` no sync script |
| Logica de merge de arquivo existente | Criar/ajustar funcao `Merge-*` no sync script |
| Placeholder novo | Garantir que `Convert-WorkspaceText` o substitui |

## Estrutura relevante

```text
ClaudeCode-Starter-Pack/
|-- CLAUDE.md              ← voce esta aqui
|-- scripts/
|   |-- sync-starter-pack-to-workspace.ps1
|   `-- new-disposable-workspace.ps1
|-- claudeCode-workspace/  ← template do workspace
`-- .tmp/                  ← sandboxes descartaveis (gitignored)
```
