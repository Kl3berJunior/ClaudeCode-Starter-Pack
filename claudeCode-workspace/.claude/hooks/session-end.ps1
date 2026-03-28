$ErrorActionPreference = "Stop"

. (Join-Path $PSScriptRoot "_common.ps1")

$hookInput = Read-HookInput
$workspaceRoot = Get-WorkspaceRoot
$memoryDir = Get-SessionMemoryDir -WorkspaceRoot $workspaceRoot
$statePath = Get-SessionStatePath -WorkspaceRoot $workspaceRoot
$today = Get-Date -Format "yyyy-MM-dd"
$sessionId = Get-HookInputValue -HookInput $hookInput -PropertyName "session_id" -Default ""
$reason = Get-HookInputValue -HookInput $hookInput -PropertyName "reason" -Default "other"

Ensure-Directory -Path $memoryDir

$state = Read-SessionState -StatePath $statePath
if (-not $state) {
    $state = New-DefaultSessionState -Date $today -SessionId $sessionId -LastMemoryFile "memory/$today.md"
}

$state.date = $today
$state.session_id = $sessionId
$state.session_end_seen = $true
$state.session_end_at = (Get-Date).ToString("o")
$state.session_end_reason = $reason

$state.ended_without_close_session = (-not $state.close_done)

Save-SessionState -State $state -StatePath $statePath
