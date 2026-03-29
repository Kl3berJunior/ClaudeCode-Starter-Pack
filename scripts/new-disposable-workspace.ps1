[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$Name = 'claudeCode-workspace-temp',
    [string]$TargetWorkspaceRoot,
    [switch]$ForceRecreate,
    [switch]$IncludeSettingsLocal
)

$ErrorActionPreference = 'Stop'

$starterPackRoot = Split-Path -Parent $PSScriptRoot
$tmpRoot = Join-Path $starterPackRoot '.tmp'
$syncScript = Join-Path $PSScriptRoot 'sync-starter-pack-to-workspace.ps1'

if (-not (Test-Path -LiteralPath $syncScript)) {
    throw "Script de sincronizacao nao encontrado: $syncScript"
}

if ([string]::IsNullOrWhiteSpace($TargetWorkspaceRoot)) {
    $TargetWorkspaceRoot = Join-Path $tmpRoot $Name
}

$resolvedTmpRoot = [System.IO.Path]::GetFullPath($tmpRoot)
$resolvedTargetRoot = [System.IO.Path]::GetFullPath($TargetWorkspaceRoot)

$comparison = [System.StringComparison]::OrdinalIgnoreCase
if ($resolvedTargetRoot.Equals($resolvedTmpRoot, $comparison)) {
    throw 'Escolha um subdiretorio dentro de .tmp/, nao a raiz de .tmp/.'
}

$tmpRootPrefix = $resolvedTmpRoot.TrimEnd('\') + '\'
if (-not $resolvedTargetRoot.StartsWith($tmpRootPrefix, $comparison)) {
    throw "O workspace descartavel deve viver dentro de $resolvedTmpRoot"
}

if (-not (Test-Path -LiteralPath $tmpRoot)) {
    if ($PSCmdlet.ShouldProcess($tmpRoot, 'Create .tmp root')) {
        New-Item -ItemType Directory -Path $tmpRoot -Force | Out-Null
    }
}

if (Test-Path -LiteralPath $resolvedTargetRoot) {
    if (-not $ForceRecreate) {
        throw "O destino ja existe: $resolvedTargetRoot. Use -ForceRecreate para recriar."
    }

    if ($PSCmdlet.ShouldProcess($resolvedTargetRoot, 'Remove existing disposable workspace')) {
        Remove-Item -LiteralPath $resolvedTargetRoot -Recurse -Force
    }
}

if (-not (Test-Path -LiteralPath $resolvedTargetRoot)) {
    if ($PSCmdlet.ShouldProcess($resolvedTargetRoot, 'Create disposable workspace root')) {
        New-Item -ItemType Directory -Path $resolvedTargetRoot -Force | Out-Null
    }
}

$syncParams = @{
    TargetWorkspaceRoot = $resolvedTargetRoot
    ResetRuntimeState   = $true
}

if ($IncludeSettingsLocal) {
    $syncParams.MergeSourceSettingsLocal = $true
}

$syncResult = & $syncScript @syncParams | ConvertFrom-Json

[pscustomobject][ordered]@{
    TempWorkspaceRoot   = $resolvedTargetRoot
    ResetRuntimeState   = $true
    SettingsLocalCopied = [bool]$IncludeSettingsLocal
    SyncResult          = $syncResult
    NextSteps           = @(
        "Abra o Claude Code em $resolvedTargetRoot",
        'Use o sandbox para testar sem gerar runtime no template principal',
        'Use -ForceRecreate para zerar o sandbox e repetir os testes'
    )
} | ConvertTo-Json -Depth 8
