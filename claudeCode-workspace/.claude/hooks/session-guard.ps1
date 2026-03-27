$ErrorActionPreference = "Stop"

function Read-HookInput {
    $raw = [Console]::In.ReadToEnd()
    if ([string]::IsNullOrWhiteSpace($raw)) {
        return $null
    }

    return $raw | ConvertFrom-Json
}

function Get-WorkspaceRoot {
    if (-not [string]::IsNullOrWhiteSpace($env:CLAUDE_PROJECT_DIR)) {
        return $env:CLAUDE_PROJECT_DIR
    }

    return (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent)
}

function Allow-Prompt {
    param([string]$Prompt)

    if ([string]::IsNullOrWhiteSpace($Prompt)) {
        return $true
    }

    return $Prompt -match '^\s*/(startup|close-session|help|hooks|clear|resume)\b'
}

$hookInput = Read-HookInput
$workspaceRoot = Get-WorkspaceRoot
$today = Get-Date -Format "yyyy-MM-dd"
$statePath = Join-Path $workspaceRoot "memory\_session-state.json"
$prompt = if ($hookInput -and $hookInput.prompt) { [string]$hookInput.prompt } else { "" }
$sessionId = if ($hookInput -and $hookInput.session_id) { [string]$hookInput.session_id } else { "" }

if (Allow-Prompt -Prompt $prompt) {
    exit 0
}

if (-not (Test-Path -LiteralPath $statePath)) {
    @{
        decision = "block"
        reason = "Sessao sem marcador de startup. Rode /startup antes de continuar."
        hookSpecificOutput = @{
            hookEventName = "UserPromptSubmit"
            additionalContext = "O prompt foi bloqueado porque o marcador de sessao nao existe. Execute /startup para reinicializar o contexto do workspace."
        }
    } | ConvertTo-Json -Depth 5
    exit 0
}

try {
    $state = Get-Content -LiteralPath $statePath -Raw | ConvertFrom-Json
} catch {
    @{
        decision = "block"
        reason = "Marcador de sessao invalido. Rode /startup para reconstruir o estado da sessao."
        hookSpecificOutput = @{
            hookEventName = "UserPromptSubmit"
            additionalContext = "O marcador local de sessao esta invalido. Execute /startup para reconstruir o estado antes de continuar."
        }
    } | ConvertTo-Json -Depth 5
    exit 0
}

if ($state.date -ne $today -or -not $state.startup_done) {
    @{
        decision = "block"
        reason = "Sessao fora do estado esperado. Rode /startup antes de continuar."
        hookSpecificOutput = @{
            hookEventName = "UserPromptSubmit"
            additionalContext = "O prompt foi bloqueado porque a sessao nao foi inicializada para a data atual. Execute /startup e reenvie a solicitacao."
        }
    } | ConvertTo-Json -Depth 5
    exit 0
}

if ($sessionId -and $state.session_id -and $state.session_id -ne $sessionId) {
    @{
        decision = "block"
        reason = "O marcador pertence a outra sessao. Rode /startup para sincronizar o contexto."
        hookSpecificOutput = @{
            hookEventName = "UserPromptSubmit"
            additionalContext = "O prompt foi bloqueado porque o session_id atual nao bate com o marcador salvo. Execute /startup antes de continuar."
        }
    } | ConvertTo-Json -Depth 5
    exit 0
}

if ($state.close_done) {
    @{
        decision = "block"
        reason = "A sessao ja foi encerrada logicamente com /close-session. Rode /startup se quiser continuar trabalhando."
        hookSpecificOutput = @{
            hookEventName = "UserPromptSubmit"
            additionalContext = "O prompt foi bloqueado porque a sessao ja foi fechada logicamente. Execute /startup para reabrir o fluxo antes de continuar."
        }
    } | ConvertTo-Json -Depth 5
    exit 0
}

exit 0
