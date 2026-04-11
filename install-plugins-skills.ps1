# Claude Code Plugins & Skills Installer
# Run this script on Windows to install plugins and skills to your Claude Code directories.
# Usage: Right-click > "Run with PowerShell" or run from an elevated PowerShell terminal.

$ClaudeDir    = "$env:USERPROFILE\.claude"
$PluginsDir   = "$ClaudeDir\plugins"
$SkillsDir    = "$ClaudeDir\skills"
$ScriptDir    = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Ensure target directories exist
New-Item -ItemType Directory -Force -Path $PluginsDir | Out-Null
New-Item -ItemType Directory -Force -Path $SkillsDir  | Out-Null

Write-Host "Installing plugins to: $PluginsDir"
Write-Host "Installing skills  to: $SkillsDir"
Write-Host ""

# ---------------------------------------------------------------------------
# PLUGINS
# ---------------------------------------------------------------------------

# 1. playwright-cli plugin
$src = Join-Path $ScriptDir "plugins\playwright-cli"
$dst = Join-Path $PluginsDir "playwright-cli"
Write-Host "[Plugin] playwright-cli -> $dst"
if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
Copy-Item -Recurse -Force $src $dst

# 2. RAG-Anything plugin
$src = Join-Path $ScriptDir "plugins\RAG-Anything"
$dst = Join-Path $PluginsDir "RAG-Anything"
Write-Host "[Plugin] RAG-Anything  -> $dst"
if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
Copy-Item -Recurse -Force $src $dst

# 3. autoresearch (clone from GitHub - repo requires access)
$dst = Join-Path $PluginsDir "autoresearch"
Write-Host "[Plugin] autoresearch  -> $dst (cloning from GitHub)"
if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
$cloneResult = git clone --depth 1 https://github.com/uditgoenka/autoresearch__ $dst 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Warning "Could not clone autoresearch__ (repo may be private or unavailable). Skipping."
} else {
    Remove-Item -Recurse -Force (Join-Path $dst ".git")
    Write-Host "  autoresearch cloned successfully."
}

Write-Host ""

# ---------------------------------------------------------------------------
# SKILLS
# ---------------------------------------------------------------------------

# playwright-cli skill (SKILL.md + references)
$src = Join-Path $ScriptDir "skills\playwright-cli"
$dst = Join-Path $SkillsDir "playwright-cli"
Write-Host "[Skill ] playwright-cli -> $dst"
if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
Copy-Item -Recurse -Force $src $dst

Write-Host ""
Write-Host "Done. Restart Claude Code to pick up the new plugins and skills."
