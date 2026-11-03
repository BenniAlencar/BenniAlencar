<#
.SYNOPSIS
    Script de publicação da Vitrine GitHub Profile (BenniAlencar/BenniAlencar)
.DESCRIPTION
    Inicializa o repositório git local, cria o branch main, adiciona o remote oficial
    e faz o push para https://github.com/BenniAlencar/BenniAlencar.git.
#>

param(
    [string]$RemoteUrl = "https://github.com/BenniAlencar/BenniAlencar.git",
    [string]$Branch = "main"
)

$ErrorActionPreference = "Stop"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   PUBLICADOR DA VITRINE GITHUB // BENNI ALENCAR         " -ForegroundColor Cyan
Write-Host "   Repositorio: BenniAlencar/BenniAlencar (Profile README)" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$CurrentDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $CurrentDir

# 1. Verifica se git ja esta inicializado
if (-not (Test-Path ".git")) {
    Write-Host "[+] Inicializando repositorio git..." -ForegroundColor Green
    git init -b $Branch
} else {
    Write-Host "[i] Repositorio git ja inicializado." -ForegroundColor Yellow
}

# 2. Configura remote
$remotes = git remote
if ($remotes -contains "origin") {
    Write-Host "[i] Remote 'origin' ja configurado. Atualizando URL..." -ForegroundColor Yellow
    git remote set-url origin $RemoteUrl
} else {
    Write-Host "[+] Adicionando remote 'origin': $RemoteUrl" -ForegroundColor Green
    git remote add origin $RemoteUrl
}

# 3. Adiciona arquivos e commita
Write-Host "[+] Adicionando README.md e artefatos..." -ForegroundColor Green
git add README.md

$status = git status --porcelain
if ($status) {
    Write-Host "[+] Criando commit de autoridade..." -ForegroundColor Green
    git commit -m "feat(vitrine): launch tier-1 showcase profile for Benni Alencar and Benni OS ecosystem"
} else {
    Write-Host "[i] Nenhum arquivo alterado para commitar." -ForegroundColor Yellow
}

# 4. Push para o GitHub
Write-Host "[+] Enviando para o GitHub ($RemoteUrl)..." -ForegroundColor Cyan
try {
    git push -u origin $Branch --force
    Write-Host "`n[SUCESSO] Repositorio vitrine publicado com sucesso!" -ForegroundColor Green
    Write-Host "Confira em: https://github.com/BenniAlencar" -ForegroundColor Green
} catch {
    Write-Host "`n[AVISO] Nao foi possivel dar push automatico (requer autenticacao)." -ForegroundColor Yellow
    Write-Host "Para autenticar e enviar manualmente, execute:" -ForegroundColor White
    Write-Host "   gh auth login" -ForegroundColor Cyan
    Write-Host "   ou" -ForegroundColor White
    Write-Host "   git push -u origin $Branch" -ForegroundColor Cyan
}
