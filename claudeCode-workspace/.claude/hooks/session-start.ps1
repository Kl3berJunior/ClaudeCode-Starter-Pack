$ErrorActionPreference = "Stop"

. (Join-Path $PSScriptRoot "_common.ps1")

$hookInput = Read-HookInput
$workspaceRoot = Get-WorkspaceRoot
$memoryDir = Get-SessionMemoryDir -WorkspaceRoot $workspaceRoot
$reportsDir = Join-Path (Join-Path $workspaceRoot "Relatorios") "agent-sessions"
$today = Get-Date -Format "yyyy-MM-dd"
$yesterday = (Get-Date).AddDays(-1).ToString("yyyy-MM-dd")
$todayMemory = Join-Path $memoryDir "$today.md"
$yesterdayMemory = Join-Path $memoryDir "$yesterday.md"
$statePath = Get-SessionStatePath -WorkspaceRoot $workspaceRoot

Initialize-Directory -Path $memoryDir

if (-not (Test-Path -LiteralPath $todayMemory)) {
    Set-Content -LiteralPath $todayMemory -Value "# $today`r`n"
}

$previousState = Read-SessionState -StatePath $statePath

$latestReportRelative = $null
$latestReportSummary = $null
if (Test-Path -LiteralPath $reportsDir) {
    $todayReport = Join-Path $reportsDir "$today-session.md"
    $latestReport = $null

    if (Test-Path -LiteralPath $todayReport) {
        $latestReport = Get-Item -LiteralPath $todayReport
    } else {
        $latestReport = Get-ChildItem -LiteralPath $reportsDir -File |
            Where-Object { $_.Name -like "*-session.md" } |
            Sort-Object LastWriteTime -Descending |
            Select-Object -First 1
    }

    if ($latestReport) {
        $latestReportRelative = "Relatorios/agent-sessions/$($latestReport.Name)"
        $latestReportSummary = Get-CompactSummary -Path $latestReport.FullName
    }
}

$todayMemorySummary = Get-CompactSummary -Path $todayMemory
$yesterdayMemorySummary = Get-CompactSummary -Path $yesterdayMemory
$branch = Get-GitBranch -WorkspaceRoot $workspaceRoot
$gitStatus = Get-GitWorkspaceStatus -WorkspaceRoot $workspaceRoot
$branchIsProtected = Test-ProtectedBranch -Branch $branch

$previousSessionUnclosed = $false
if ($previousState -and -not $previousState.close_done) {
    $previousSessionUnclosed = $true
}

$source = Get-HookInputValue -HookInput $hookInput -PropertyName "source" -Default "unknown"
$sessionId = Get-HookInputValue -HookInput $hookInput -PropertyName "session_id" -Default ""

$state = New-DefaultSessionState -Date $today -SessionId $sessionId -LastMemoryFile "memory/$today.md"
$state.startup_done = $true
$state.startup_source = $source
$state.startup_at = (Get-Date).ToString("o")
$state.previous_session_unclosed = $previousSessionUnclosed
$state.branch = $branch
$state.branch_is_protected = $branchIsProtected
$state.git_status = $gitStatus
$state.last_session_report = $latestReportRelative

Save-SessionState -State $state -StatePath $statePath

$contextLines = @(
    "Sessao auto-inicializada pelo hook SessionStart."
    "Fonte de abertura: $source."
)

if (-not [string]::IsNullOrWhiteSpace($branch)) {
    $contextLines += "Branch atual: $branch."
}

if ($branchIsProtected) {
    $contextLines += "Alerta: branch protegida detectada. Antes de pedir mudancas, crie uma branch dedicada ou abra uma worktree rastreavel."
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

$output = New-HookOutput -HookEventName "SessionStart" -AdditionalContext ($contextLines -join " ")
Write-HookJson -Payload $output
