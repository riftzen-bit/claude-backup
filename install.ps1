# Claude Code Configuration Installer for Windows
# Run from PowerShell: .\install.ps1

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ConfigDir = Join-Path $ScriptDir "config"
$TargetDir = Join-Path $env:USERPROFILE ".claude"

Write-Host "Claude Code Configuration Installer (Windows)" -ForegroundColor Cyan
Write-Host "==============================================="
Write-Host ""
Write-Host "Source:  $ConfigDir"
Write-Host "Target:  $TargetDir"
Write-Host ""

if (Test-Path $TargetDir) {
    Write-Host "WARNING: $TargetDir already exists." -ForegroundColor Yellow
    Write-Host "This installer will MERGE files (existing files will be overwritten)."
    $confirm = Read-Host "Continue? (y/N)"
    if ($confirm -ne "y" -and $confirm -ne "Y") {
        Write-Host "Aborted."
        exit 0
    }
}

# Create directory structure
Write-Host "Creating directory structure..."
$dirs = @(
    "agents", "commands", "hooks", "skills",
    "rules\common", "rules\typescript",
    "state", "routing-logs"
)
foreach ($dir in $dirs) {
    New-Item -ItemType Directory -Path (Join-Path $TargetDir $dir) -Force | Out-Null
}

# Copy config files
Write-Host "Copying configuration files..."
Copy-Item (Join-Path $ConfigDir "CLAUDE.md") $TargetDir -Force
Copy-Item (Join-Path $ConfigDir "enforce.md") $TargetDir -Force
Copy-Item (Join-Path $ConfigDir "model-routing.json") $TargetDir -Force
Copy-Item (Join-Path $ConfigDir "gitignore") (Join-Path $TargetDir ".gitignore") -Force

# Copy settings.json with path replacement
Write-Host "Installing settings.json (replacing __HOME__)..."
$homePath = $env:USERPROFILE -replace '\\', '/'
$settingsContent = Get-Content (Join-Path $ConfigDir "settings.json") -Raw
$settingsContent = $settingsContent -replace '__HOME__', $homePath
Set-Content -Path (Join-Path $TargetDir "settings.json") -Value $settingsContent -NoNewline

# Copy agents
Write-Host "Installing agents..."
Copy-Item (Join-Path $ConfigDir "agents\*.md") (Join-Path $TargetDir "agents") -Force

# Copy commands
Write-Host "Installing commands..."
Copy-Item (Join-Path $ConfigDir "commands\*.md") (Join-Path $TargetDir "commands") -Force

# Copy hooks with path replacement
Write-Host "Installing hooks (replacing __HOME__)..."
Get-ChildItem (Join-Path $ConfigDir "hooks\*.sh") | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    $content = $content -replace '__HOME__', $homePath
    Set-Content -Path (Join-Path $TargetDir "hooks\$($_.Name)") -Value $content -NoNewline
}

# Copy rules
Write-Host "Installing rules..."
Copy-Item (Join-Path $ConfigDir "rules\common\*.md") (Join-Path $TargetDir "rules\common") -Force
Copy-Item (Join-Path $ConfigDir "rules\typescript\*.md") (Join-Path $TargetDir "rules\typescript") -Force

# Copy skills
Write-Host "Installing skills..."
Get-ChildItem (Join-Path $ConfigDir "skills") -Directory | ForEach-Object {
    $destSkill = Join-Path $TargetDir "skills\$($_.Name)"
    New-Item -ItemType Directory -Path $destSkill -Force | Out-Null
    Copy-Item "$($_.FullName)\*" $destSkill -Recurse -Force
}

Write-Host ""
Write-Host "Installation complete!" -ForegroundColor Green
Write-Host ""
Write-Host "IMPORTANT: Claude Code on Windows requires WSL or Git Bash."
Write-Host "The hook scripts (.sh) run via bash, not PowerShell."
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Edit $TargetDir\CLAUDE.md - set your name and language"
Write-Host "  2. Ensure WSL or Git Bash is installed"
Write-Host "  3. Run 'claude' from WSL or Git Bash"
