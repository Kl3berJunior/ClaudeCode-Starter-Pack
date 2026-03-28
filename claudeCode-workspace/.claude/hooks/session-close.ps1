$ErrorActionPreference = "Stop"

. (Join-Path $PSScriptRoot "_common.ps1")

$workspaceRoot = Get-WorkspaceRoot
$statePath = Get-SessionStatePath -WorkspaceRoot $workspaceRoot
$today = Get-Date -Format "yyyy-MM-dd"

$state = Read-SessionState -StatePath $statePath
if (-not $state) {
    $state = New-DefaultSessionState -Date $today -LastMemoryFile "memory/$today.md"
}

$state.close_done = $true
$state.close_at = (Get-Date).ToString("o")

Save-SessionState -State $state -StatePath $statePath

Write-Output "session-close: close_done=true registrado em $($state.close_at)"
