[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$TargetWorkspaceRoot = 'C:\Sistema\claudeCode-workspace',
    [switch]$ResetRuntimeState,
    [switch]$SkipSettingsLocal
)

$ErrorActionPreference = 'Stop'

$starterPackRoot = Split-Path -Parent $PSScriptRoot
$sourceWorkspaceRoot = Join-Path $starterPackRoot 'claudeCode-workspace'

if (-not (Test-Path -LiteralPath $sourceWorkspaceRoot)) {
    throw "Workspace fonte nao encontrado: $sourceWorkspaceRoot"
}

$resolvedTargetRoot = [System.IO.Path]::GetFullPath($TargetWorkspaceRoot)
if (-not (Test-Path -LiteralPath $resolvedTargetRoot)) {
    throw "Workspace alvo nao encontrado: $resolvedTargetRoot"
}

$sourceWorkspaceRootUnix = $sourceWorkspaceRoot.Replace('\', '/')
$resolvedTargetRootUnix = $resolvedTargetRoot.Replace('\', '/')

$copiedFiles = New-Object 'System.Collections.Generic.List[string]'
$mergedFiles = New-Object 'System.Collections.Generic.List[string]'
$resetItems = New-Object 'System.Collections.Generic.List[string]'

function Read-Utf8([string]$Path) {
    return [System.IO.File]::ReadAllText($Path, [System.Text.UTF8Encoding]::new($false))
}

function Write-Utf8([string]$Path, [string]$Content) {
    $parent = Split-Path -Parent $Path
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        if ($PSCmdlet.ShouldProcess($parent, 'Create directory')) {
            New-Item -ItemType Directory -Path $parent -Force | Out-Null
        }
    }

    $existing = if (Test-Path -LiteralPath $Path) { Read-Utf8 $Path } else { $null }
    if ($existing -eq $Content) {
        return
    }

    if ($PSCmdlet.ShouldProcess($Path, 'Write file')) {
        [System.IO.File]::WriteAllText($Path, $Content, [System.Text.UTF8Encoding]::new($false))
    }
}

function Replace-Match([string]$Content, [System.Text.RegularExpressions.Match]$Match, [string]$Replacement) {
    return $Content.Substring(0, $Match.Index) + $Replacement + $Content.Substring($Match.Index + $Match.Length)
}

function Convert-WorkspaceText([string]$Content) {
    # single-pass para evitar substituicao em cascata caso os paths se sobreponham
    $pattern = [System.Text.RegularExpressions.Regex]::Escape('__WORKSPACE_ROOT__') + '|' +
               [System.Text.RegularExpressions.Regex]::Escape($sourceWorkspaceRootUnix)
    return [System.Text.RegularExpressions.Regex]::Replace($Content, $pattern, { $resolvedTargetRootUnix })
}

function Copy-FileFromSource([string]$RelativePath) {
    $sourcePath = Join-Path $sourceWorkspaceRoot $RelativePath
    $targetPath = Join-Path $resolvedTargetRoot $RelativePath

    if (-not (Test-Path -LiteralPath $sourcePath)) {
        throw "Arquivo fonte ausente: $sourcePath"
    }

    $parent = Split-Path -Parent $targetPath
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        if ($PSCmdlet.ShouldProcess($parent, 'Create directory')) {
            New-Item -ItemType Directory -Path $parent -Force | Out-Null
        }
    }

    if ($PSCmdlet.ShouldProcess($targetPath, 'Copy file from starter pack')) {
        Copy-Item -LiteralPath $sourcePath -Destination $targetPath -Force
    }

    $copiedFiles.Add($RelativePath) | Out-Null
}

function Get-RelativeFiles([string]$RelativeDirectory, [string]$Filter) {
    $absoluteDirectory = Join-Path $sourceWorkspaceRoot $RelativeDirectory
    if (-not (Test-Path -LiteralPath $absoluteDirectory)) {
        return @()
    }

    return Get-ChildItem -LiteralPath $absoluteDirectory -File -Filter $Filter |
        Sort-Object Name |
        ForEach-Object {
            $_.FullName.Substring($sourceWorkspaceRoot.Length).TrimStart('\')
        }
}

function Get-PermissionsArray([object]$JsonObject, [string]$PropertyName) {
    if ($null -eq $JsonObject) {
        return @()
    }

    if ($null -eq $JsonObject.permissions) {
        return @()
    }

    $value = $JsonObject.permissions.$PropertyName
    if ($null -eq $value) {
        return @()
    }

    return @($value) | Where-Object {
        $_ -is [string] -and -not [string]::IsNullOrWhiteSpace($_)
    }
}

function Merge-UniqueStrings([string[]]$Preferred, [string[]]$Additional) {
    $result = New-Object 'System.Collections.Generic.List[string]'
    foreach ($value in @($Preferred + $Additional)) {
        if ([string]::IsNullOrWhiteSpace($value)) {
            continue
        }

        $normalized = Convert-WorkspaceText $value.Trim()
        if (-not $result.Contains($normalized)) {
            $result.Add($normalized) | Out-Null
        }
    }

    return @($result)
}

function Merge-SettingsLocal() {
    $sourcePath = Join-Path $sourceWorkspaceRoot '.claude\settings.local.json'
    $targetPath = Join-Path $resolvedTargetRoot '.claude\settings.local.json'

    if ($SkipSettingsLocal) {
        return
    }

    if (-not (Test-Path -LiteralPath $sourcePath) -and -not (Test-Path -LiteralPath $targetPath)) {
        return
    }

    $sourceJson = if (Test-Path -LiteralPath $sourcePath) { (Read-Utf8 $sourcePath | ConvertFrom-Json) } else { $null }
    $targetJson = if (Test-Path -LiteralPath $targetPath) { (Read-Utf8 $targetPath | ConvertFrom-Json) } else { $null }

    $allow = Merge-UniqueStrings (Get-PermissionsArray $targetJson 'allow') (Get-PermissionsArray $sourceJson 'allow')
    $deny = Merge-UniqueStrings (Get-PermissionsArray $targetJson 'deny') (Get-PermissionsArray $sourceJson 'deny')

    $payload = [ordered]@{
        permissions = [ordered]@{
            allow = $allow
        }
    }

    if ($deny.Count -gt 0) {
        $payload.permissions.deny = $deny
    }

    $content = ($payload | ConvertTo-Json -Depth 6) + "`r`n"
    Write-Utf8 $targetPath $content
    $mergedFiles.Add('.claude\settings.local.json') | Out-Null
}

function Merge-Tools() {
    $sourcePath = Join-Path $sourceWorkspaceRoot 'TOOLS.md'
    $targetPath = Join-Path $resolvedTargetRoot 'TOOLS.md'
    $sourceContent = Convert-WorkspaceText (Read-Utf8 $sourcePath)

    if (-not (Test-Path -LiteralPath $targetPath)) {
        Write-Utf8 $targetPath $sourceContent
        $mergedFiles.Add('TOOLS.md') | Out-Null
        return
    }

    $targetContent = Read-Utf8 $targetPath
    $sectionPattern = '(?ms)^## Reposit.*?(?=^## Worktrees)'
    $sourceMatch = [System.Text.RegularExpressions.Regex]::Match($sourceContent, $sectionPattern)
    $targetMatch = [System.Text.RegularExpressions.Regex]::Match($targetContent, $sectionPattern)

    if ($sourceMatch.Success -and $targetMatch.Success) {
        $mergedContent = Replace-Match $sourceContent $sourceMatch $targetMatch.Value
    } elseif (-not $sourceMatch.Success) {
        $mergedContent = $sourceContent
    } else {
        # target nao tem a estrutura esperada (ex: ## Worktrees ausente) — preservar target
        $mergedContent = $targetContent
    }

    Write-Utf8 $targetPath $mergedContent
    $mergedFiles.Add('TOOLS.md') | Out-Null
}

function Merge-BulletSection(
    [string]$SourceContent,
    [string]$TargetContent,
    [string]$SourceHeading,
    [string]$TargetPattern
) {
    $sourcePattern = '(?ms)^## ' + [System.Text.RegularExpressions.Regex]::Escape($SourceHeading) + '\s*\r?\n(?<body>.*?)(?=^## |\z)'
    $sourceMatch = [System.Text.RegularExpressions.Regex]::Match($SourceContent, $sourcePattern)
    if (-not $sourceMatch.Success) {
        return $TargetContent
    }

    $targetMatch = [System.Text.RegularExpressions.Regex]::Match($TargetContent, $TargetPattern)
    if (-not $targetMatch.Success) {
        return $TargetContent
    }

    $sourceBullets = @(
        $sourceMatch.Groups['body'].Value -split "\r?\n" |
            Where-Object {
                $_ -match '^- ' -and $_ -notmatch '__[A-Z0-9_]+__'
            }
    )

    if ($sourceBullets.Count -eq 0) {
        return $TargetContent
    }

    $targetBody = $targetMatch.Groups['body'].Value.TrimEnd("`r", "`n")
    $missingBullets = @(
        $sourceBullets | Where-Object {
            -not $targetBody.Contains($_, [System.StringComparison]::OrdinalIgnoreCase)
        }
    )

    if ($missingBullets.Count -eq 0) {
        return $TargetContent
    }

    $newBody = $targetBody
    if ($newBody.Length -gt 0) {
        $newBody += "`r`n"
    }

    $newBody += ($missingBullets -join "`r`n")
    $headingText = if ($targetMatch.Groups['heading'].Success -and $targetMatch.Groups['heading'].Value) {
        $targetMatch.Groups['heading'].Value
    } else {
        $SourceHeading
    }
    $replacement = '## ' + $headingText + "`r`n`r`n" + $newBody + "`r`n"
    return Replace-Match $TargetContent $targetMatch $replacement
}

function Merge-User() {
    $sourcePath = Join-Path $sourceWorkspaceRoot 'USER.md'
    $targetPath = Join-Path $resolvedTargetRoot 'USER.md'
    $sourceContent = Read-Utf8 $sourcePath

    if (-not (Test-Path -LiteralPath $targetPath)) {
        Write-Utf8 $targetPath $sourceContent
        $mergedFiles.Add('USER.md') | Out-Null
        return
    }

    $targetContent = Read-Utf8 $targetPath
    $mergedContent = $targetContent

    $sectionRules = @(
        @{
            SourceHeading = 'Fluxo de trabalho'
            TargetPattern = '(?ms)^## (?<heading>Fluxo de trabalho)\s*\r?\n(?<body>.*?)(?=^## |\z)'
        },
        @{
            SourceHeading = 'Politica de worktrees'
            TargetPattern = '(?ms)^## (?<heading>Pol.*worktrees)\s*\r?\n(?<body>.*?)(?=^## |\z)'
        },
        @{
            SourceHeading = 'Testes'
            TargetPattern = '(?ms)^## (?<heading>Testes)\s*\r?\n(?<body>.*?)(?=^## |\z)'
        },
        @{
            SourceHeading = 'Preferencias do agente'
            TargetPattern = '(?ms)^## (?<heading>Prefer.*agente)\s*\r?\n(?<body>.*?)(?=^## |\z)'
        }
    )

    foreach ($rule in $sectionRules) {
        $mergedContent = Merge-BulletSection `
            -SourceContent $sourceContent `
            -TargetContent $mergedContent `
            -SourceHeading $rule.SourceHeading `
            -TargetPattern $rule.TargetPattern
    }

    Write-Utf8 $targetPath $mergedContent
    $mergedFiles.Add('USER.md') | Out-Null
}

function Merge-Memory() {
    $sourcePath = Join-Path $sourceWorkspaceRoot 'MEMORY.md'
    $targetPath = Join-Path $resolvedTargetRoot 'MEMORY.md'
    $sourceContent = Read-Utf8 $sourcePath

    if (-not (Test-Path -LiteralPath $targetPath)) {
        Write-Utf8 $targetPath $sourceContent
        $mergedFiles.Add('MEMORY.md') | Out-Null
        return
    }

    $targetContent = Read-Utf8 $targetPath
    $sourceBullets = @(
        $sourceContent -split "\r?\n" |
            Where-Object {
                $_ -match '^- ' -and $_ -notmatch '__[A-Z0-9_]+__'
            }
    )

    $missingBullets = @(
        $sourceBullets | Where-Object {
            -not $targetContent.Contains($_, [System.StringComparison]::OrdinalIgnoreCase)
        }
    )

    $mergedContent = $targetContent
    if ($missingBullets.Count -gt 0) {
        $mergedContent = $targetContent.TrimEnd() + "`r`n" + ($missingBullets -join "`r`n") + "`r`n"
    }

    Write-Utf8 $targetPath $mergedContent
    $mergedFiles.Add('MEMORY.md') | Out-Null
}

function Reset-RuntimeState() {
    $memoryDir = Join-Path $resolvedTargetRoot 'memory'
    if (Test-Path -LiteralPath $memoryDir) {
        Get-ChildItem -LiteralPath $memoryDir -Force -File |
            Where-Object { $_.Name -ne 'README.md' } |
            ForEach-Object {
                if ($PSCmdlet.ShouldProcess($_.FullName, 'Remove runtime memory file')) {
                    Remove-Item -LiteralPath $_.FullName -Force
                }
            }
    }

    $agentSessionsDir = Join-Path $resolvedTargetRoot 'Relatorios\agent-sessions'
    if (Test-Path -LiteralPath $agentSessionsDir) {
        Get-ChildItem -LiteralPath $agentSessionsDir -Force -File |
            Where-Object { $_.Name -ne 'README.md' } |
            ForEach-Object {
                if ($PSCmdlet.ShouldProcess($_.FullName, 'Remove agent session file')) {
                    Remove-Item -LiteralPath $_.FullName -Force
                }
            }
    }

    Copy-FileFromSource 'Relatorios\Swarm\supervisor-status.md'
    $resetItems.Add('memory/* (exceto README.md)') | Out-Null
    $resetItems.Add('Relatorios/agent-sessions/* (exceto README.md)') | Out-Null
    $resetItems.Add('Relatorios/Swarm/supervisor-status.md') | Out-Null
}

$filesToCopy = @(
    '.gitignore',
    'README.md',
    'CLAUDE.md',
    'HEARTBEAT.md',
    'SOUL.md',
    'repo\CLAUDE.md',
    'memory\README.md',
    'Relatorios\agent-sessions\README.md'
)

$filesToCopy += Get-RelativeFiles '.claude\agents' '*.md'
$filesToCopy += Get-RelativeFiles '.claude\commands' '*.md'
$filesToCopy += Get-RelativeFiles '.claude\hooks' '*.ps1'

foreach ($relativePath in ($filesToCopy | Sort-Object -Unique)) {
    Copy-FileFromSource $relativePath
}

$settingsJsonContent = Convert-WorkspaceText (Read-Utf8 (Join-Path $sourceWorkspaceRoot '.claude\settings.json'))
Write-Utf8 (Join-Path $resolvedTargetRoot '.claude\settings.json') $settingsJsonContent
$mergedFiles.Add('.claude\settings.json') | Out-Null

Merge-SettingsLocal
Merge-Tools
Merge-User
Merge-Memory

if ($ResetRuntimeState) {
    Reset-RuntimeState
}

[PSCustomObject]@{
    SourceWorkspaceRoot = $sourceWorkspaceRoot
    TargetWorkspaceRoot = $resolvedTargetRoot
    CopiedFiles = @($copiedFiles | Sort-Object -Unique)
    MergedFiles = @($mergedFiles | Sort-Object -Unique)
    RuntimeReset = @($resetItems | Sort-Object -Unique)
} | ConvertTo-Json -Depth 6
