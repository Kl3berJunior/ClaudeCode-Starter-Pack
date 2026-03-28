$ErrorActionPreference = "Stop"

. (Join-Path $PSScriptRoot "_common.ps1")

function Allow-Prompt {
    param([string]$Prompt)

    if ([string]::IsNullOrWhiteSpace($Prompt)) {
        return $true
    }

    return $Prompt -match '^\s*/(startup|close-session|help|hooks|clear|resume|heartbeat|backlog)\b'
}

$hookInput = Read-HookInput
$workspaceRoot = Get-WorkspaceRoot
$today = Get-Date -Format "yyyy-MM-dd"
$statePath = Get-SessionStatePath -WorkspaceRoot $workspaceRoot
$prompt = Get-HookInputValue -HookInput $hookInput -PropertyName "prompt" -Default ""
$sessionId = Get-HookInputValue -HookInput $hookInput -PropertyName "session_id" -Default ""

if (Allow-Prompt -Prompt $prompt) {
    exit 0
}

if (-not (Test-Path -LiteralPath $statePath)) {
    New-GuardBlockResponse `
        -Reason "Sessao sem marcador de startup. Rode /startup antes de continuar." `
        -AdditionalContext "O prompt foi bloqueado porque o marcador de sessao nao existe. Execute /startup para reinicializar o contexto do workspace." |
        Write-HookJson
    exit 0
}

$state = Read-SessionState -StatePath $statePath
if (-not $state) {
    New-GuardBlockResponse `
        -Reason "Marcador de sessao invalido. Rode /startup para reconstruir o estado da sessao." `
        -AdditionalContext "O marcador local de sessao esta invalido. Execute /startup para reconstruir o estado antes de continuar." |
        Write-HookJson
    exit 0
}

if ($state.date -ne $today -or -not $state.startup_done) {
    New-GuardBlockResponse `
        -Reason "Sessao fora do estado esperado. Rode /startup antes de continuar." `
        -AdditionalContext "O prompt foi bloqueado porque a sessao nao foi inicializada para a data atual. Execute /startup e reenvie a solicitacao." |
        Write-HookJson
    exit 0
}

if ($sessionId -and $state.session_id -and $state.session_id -ne $sessionId) {
    New-GuardBlockResponse `
        -Reason "O marcador pertence a outra sessao. Rode /startup para sincronizar o contexto." `
        -AdditionalContext "O prompt foi bloqueado porque o session_id atual nao bate com o marcador salvo. Execute /startup antes de continuar." |
        Write-HookJson
    exit 0
}

if ($state.close_done) {
    New-GuardBlockResponse `
        -Reason "A sessao ja foi encerrada logicamente com /close-session. Rode /startup se quiser continuar trabalhando." `
        -AdditionalContext "O prompt foi bloqueado porque a sessao ja foi fechada logicamente. Execute /startup para reabrir o fluxo antes de continuar." |
        Write-HookJson
    exit 0
}

exit 0
