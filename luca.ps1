# Start Claude Code for one client:  .\luca.ps1 <client> [claude options]
# Loads clients\<client>.env into the environment so .mcp.json's ${LUCA_TOKEN}
# is that client's token, then launches Claude Code in this folder.
param(
    [Parameter(Position = 0)] [string] $Client,
    [Parameter(ValueFromRemainingArguments = $true)] [string[]] $Rest
)
Set-Location $PSScriptRoot

function List-Clients {
    $files = Get-ChildItem clients\*.env -ErrorAction SilentlyContinue | Where-Object { $_.BaseName -ne 'example' }
    if (-not $files) { Write-Host "  (none yet - copy clients\example.env to clients\<client>.env)"; return }
    $files | ForEach-Object { Write-Host "  $($_.BaseName)" }
}

if (-not $Client -or $Client -eq 'example') {
    Write-Host "Usage: .\luca.ps1 <client> [claude options]"
    Write-Host "Clients with a token file:"
    List-Clients
    exit 1
}

$file = "clients\$Client.env"
if (-not (Test-Path $file)) {
    Write-Host "No token file for '$Client'."
    Write-Host "Copy clients\example.env to $file and paste that client's token in."
    exit 1
}

Get-Content $file | Where-Object { $_ -match '^\s*[A-Za-z_][A-Za-z0-9_]*\s*=' } | ForEach-Object {
    $name, $value = $_ -split '=', 2
    Set-Item -Path "Env:$($name.Trim())" -Value $value.Trim().Trim('"').Trim("'")
}

if (-not $env:LUCA_MCP_URL) { $env:LUCA_MCP_URL = 'https://api.luca.pro/mcp' }

if (-not $env:LUCA_TOKEN -or $env:LUCA_TOKEN -eq 'paste-the-token-here') {
    Write-Host "$file has no token yet. Paste the token from Luca (Settings -> API Tokens) into it."
    exit 1
}

Write-Host "Luca client: $Client"
claude @Rest
