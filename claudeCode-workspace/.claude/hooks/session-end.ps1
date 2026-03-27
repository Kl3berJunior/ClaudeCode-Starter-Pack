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

$hookInput = Read-HookInput
$workspaceRoot = Get-WorkspaceRoot
$memoryDir = Join-Path $workspaceRoot "memory"
$statePath = Join-Path $memoryDir "_session-state.json"
$today = Get-Date -Format "yyyy-MM-dd"
$sessionId = if ($hookInput -and $hookInput.session_id) { [string]$hookInput.session_id } else { "" }
$reason = if ($hookInput -and $hookInput.reason) { [string]$hookInput.reason } else { "other" }

if (-not (Test-Path -LiteralPath $memoryDir)) {
    New-Item -ItemType Directory -Path $memoryDir -Force | Out-Null
}

$state = $null
if (Test-Path -LiteralPath $statePath) {
    try {
        $state = Get-Content -LiteralPath $statePath -Raw | ConvertFrom-Json
    } catch {
        $state = $null
    }
}

if (-not $state) {
    $state = [pscustomobject]@{
        date                      = $today
        session_id                = $sessionId
        startup_done              = $false
        startup_source            = "unknown"
        startup_at                = $null
        close_done                = $false
        close_at                  = $null
        session_end_seen          = $false
        session_end_at            = $null
        session_end_reason        = $null
        previous_session_unclosed = $false
        branch                    = ""
        git_status                = "unknown"
        last_session_report       = $null
        last_memory_file          = "memory/$today.md"
    }
}

$state.date = $today
$state.session_id = $sessionId
$state.session_end_seen = $true
$state.session_end_at = (Get-Date).ToString("o")
$state.session_end_reason = $reason

if (-not $state.close_done) {
    $state | Add-Member -NotePropertyName "ended_without_close_session" -NotePropertyValue $true -Force
} else {
    $state | Add-Member -NotePropertyName "ended_without_close_session" -NotePropertyValue $false -Force
}

$state | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $statePath
