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

function Get-SessionMemoryDir {
    param([string]$WorkspaceRoot)

    return (Join-Path $WorkspaceRoot "memory")
}

function Get-SessionStatePath {
    param([string]$WorkspaceRoot)

    return (Join-Path (Get-SessionMemoryDir -WorkspaceRoot $WorkspaceRoot) "_session-state.json")
}

function Initialize-Directory {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function Get-HookInputValue {
    param(
        $HookInput,
        [string]$PropertyName,
        [string]$Default = ""
    )

    if ($null -eq $HookInput) {
        return $Default
    }

    $property = $HookInput.PSObject.Properties[$PropertyName]
    if ($null -eq $property) {
        return $Default
    }

    $value = [string]$property.Value
    if ([string]::IsNullOrWhiteSpace($value)) {
        return $Default
    }

    return $value
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

function New-DefaultSessionState {
    param(
        [string]$Date,
        [string]$SessionId = "",
        [string]$LastMemoryFile
    )

    return [pscustomobject][ordered]@{
        date                         = $Date
        session_id                   = $SessionId
        startup_done                 = $false
        startup_source               = "unknown"
        startup_at                   = $null
        close_done                   = $false
        close_at                     = $null
        session_end_seen             = $false
        session_end_at               = $null
        session_end_reason           = $null
        previous_session_unclosed    = $false
        ended_without_close_session  = $false
        branch                       = ""
        git_status                   = "unknown"
        last_session_report          = $null
        last_memory_file             = $LastMemoryFile
    }
}

function Read-SessionState {
    param(
        [string]$StatePath
    )

    if (-not (Test-Path -LiteralPath $StatePath)) {
        return $null
    }

    try {
        return (Get-Content -LiteralPath $StatePath -Raw | ConvertFrom-Json)
    } catch {
        return $null
    }
}

function Save-SessionState {
    param(
        $State,
        [string]$StatePath
    )

    $State | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $StatePath
}

function New-HookOutput {
    param(
        [string]$HookEventName,
        [string]$AdditionalContext
    )

    return [pscustomobject]@{
        hookSpecificOutput = [pscustomobject]@{
            hookEventName     = $HookEventName
            additionalContext = $AdditionalContext
        }
    }
}

function New-GuardBlockResponse {
    param(
        [string]$Reason,
        [string]$AdditionalContext
    )

    return [pscustomobject]@{
        decision           = "block"
        reason             = $Reason
        hookSpecificOutput = [pscustomobject]@{
            hookEventName    = "UserPromptSubmit"
            additionalContext = $AdditionalContext
        }
    }
}

function Write-HookJson {
    param(
        [Parameter(ValueFromPipeline = $true)]
        $Payload
    )

    process {
        $Payload | ConvertTo-Json -Depth 5
    }
}
