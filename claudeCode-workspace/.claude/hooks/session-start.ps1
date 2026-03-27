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

function Get-CompactSummary {
    param(
        [string]$Path,
        [int]$MaxChars = 240
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        return $null
    }

    $text = (Get-Content -LiteralPath $Path -Raw).Trim()
    if ([string]::IsNullOrWhiteSpace($text)) {
        return $null
    }

    $text = $text -replace "\r?\n+", " | "
    if ($text.Length -gt $MaxChars) {
        return $text.Substring(0, $MaxChars).Trim() + "..."
    }

    return $text
}

$hookInput = Read-HookInput
$workspaceRoot = Get-WorkspaceRoot
$memoryDir = Join-Path $workspaceRoot "memory"
$reportsDir = Join-Path $workspaceRoot "Relatorios\agent-sessions"
$today = Get-Date -Format "yyyy-MM-dd"
$yesterday = (Get-Date).AddDays(-1).ToString("yyyy-MM-dd")
$todayMemory = Join-Path $memoryDir "$today.md"
$yesterdayMemory = Join-Path $memoryDir "$yesterday.md"
$statePath = Join-Path $memoryDir "_session-state.json"

if (-not (Test-Path -LiteralPath $memoryDir)) {
    New-Item -ItemType Directory -Path $memoryDir -Force | Out-Null
}

if (-not (Test-Path -LiteralPath $todayMemory)) {
    Set-Content -LiteralPath $todayMemory -Value "# $today`r`n"
}

$previousState = $null
if (Test-Path -LiteralPath $statePath) {
    try {
        $previousState = Get-Content -LiteralPath $statePath -Raw | ConvertFrom-Json
    } catch {
        $previousState = $null
    }
}

$latestReportRelative = $null
$latestReportSummary = $null
if (Test-Path -LiteralPath $reportsDir) {
    $todayReport = Join-Path $reportsDir "$today-session.md"
    $latestReport = $null

    if (Test-Path -LiteralPath $todayReport) {
        $latestReport = Get-Item -LiteralPath $todayReport
    } else {
        $latestReport = Get-ChildItem -LiteralPath $reportsDir -File | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    }

    if ($latestReport) {
        $latestReportRelative = "Relatorios/agent-sessions/$($latestReport.Name)"
        $latestReportSummary = Get-CompactSummary -Path $latestReport.FullName
    }
}

$todayMemorySummary = Get-CompactSummary -Path $todayMemory
$yesterdayMemorySummary = Get-CompactSummary -Path $yesterdayMemory
$branch = ""
$gitStatus = "unknown"

try {
    $branch = (& git -C $workspaceRoot branch --show-current 2>$null).Trim()
} catch {
    $branch = ""
}

try {
    $dirtyOutput = & git -C $workspaceRoot status --porcelain 2>$null
    if ($dirtyOutput) {
        $gitStatus = "dirty"
    } else {
        $gitStatus = "clean"
    }
} catch {
    $gitStatus = "unknown"
}

$previousSessionUnclosed = $false
if ($previousState -and $previousState.date -ne $today -and -not $previousState.close_done) {
    $previousSessionUnclosed = $true
}

$source = if ($hookInput -and $hookInput.source) { [string]$hookInput.source } else { "unknown" }
$sessionId = if ($hookInput -and $hookInput.session_id) { [string]$hookInput.session_id } else { "" }

$state = [ordered]@{
    date                      = $today
    session_id                = $sessionId
    startup_done              = $true
    startup_source            = $source
    startup_at                = (Get-Date).ToString("o")
    close_done                = $false
    close_at                  = $null
    session_end_seen          = $false
    session_end_at            = $null
    session_end_reason        = $null
    previous_session_unclosed = $previousSessionUnclosed
    branch                    = $branch
    git_status                = $gitStatus
    last_session_report       = $latestReportRelative
    last_memory_file          = "memory/$today.md"
}

$state | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $statePath

$contextLines = @(
    "Sessao auto-inicializada pelo hook SessionStart."
    "Fonte de abertura: $source."
)

if (-not [string]::IsNullOrWhiteSpace($branch)) {
    $contextLines += "Branch atual: $branch."
}

if ($gitStatus -ne "unknown") {
    $contextLines += "Estado do workspace: $gitStatus."
}

if ($todayMemorySummary) {
    $contextLines += "Memoria de hoje: $todayMemorySummary"
}

if ($yesterdayMemorySummary) {
    $contextLines += "Memoria de ontem: $yesterdayMemorySummary"
}

if ($latestReportSummary) {
    $contextLines += "Ultimo relatorio de sessao: $latestReportSummary"
}

if ($previousSessionUnclosed) {
    $contextLines += "Alerta: a sessao anterior aparenta ter sido encerrada sem /close-session."
}

$contextLines += "Se precisar repetir a auditoria manual, rode /startup. Antes de sair, rode /close-session."

$output = @{
    hookSpecificOutput = @{
        hookEventName    = "SessionStart"
        additionalContext = ($contextLines -join " ")
    }
}

$output | ConvertTo-Json -Depth 5
