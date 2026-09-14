# Publica o site de vendas (versao single-file) no Netlify.
#
#   .\publicar.ps1                 -> primeira vez: cria o site e publica
#   .\publicar.ps1 -Nome outro     -> escolhe outro subdominio (.netlify.app)
#
# Se nao estiver logado, abre a aba do Netlify e espera voce clicar em Authorize.
# A janela expira em ~3 minutos, entao clique assim que ela abrir.

param(
  [string]$Nome = "nutriobjetivo-venda"
)

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

$cli = "netlify-cli@latest"

Write-Host "`n== Conferindo o login do Netlify ==" -ForegroundColor Cyan
$status = npx --yes $cli status 2>&1 | Out-String

if ($status -match "Not logged in") {
  Write-Host "Voce ainda nao esta logado." -ForegroundColor Yellow
  Write-Host "Vai abrir uma aba do Netlify: clique em Authorize. A janela expira em ~3 minutos.`n"
  npx --yes $cli login
  $status = npx --yes $cli status 2>&1 | Out-String
  if ($status -match "Not logged in") {
    Write-Host "`nO login nao foi concluido. Rode de novo quando puder autorizar na hora." -ForegroundColor Red
    exit 1
  }
}

Write-Host "`n== Site ==" -ForegroundColor Cyan
if (Test-Path ".netlify\state.json") {
  Write-Host "Ja existe um site vinculado a esta pasta. Publicando por cima."
} else {
  Write-Host "Criando o site '$Nome'..."
  npx --yes $cli sites:create --name $Nome --disable-linking
  npx --yes $cli link --name $Nome
}

Write-Host "`n== Publicando ==" -ForegroundColor Cyan
npx --yes $cli deploy --prod --dir "." --no-build

Write-Host "`nPronto. O endereco aparece acima, em 'Website URL'." -ForegroundColor Green
Write-Host "Falta preencher em NUTRI_SALES_CONFIG (dentro do index.html):" -ForegroundColor Yellow
Write-Host "  whatsapp        -> hoje vazio: o botao so rola ate o formulario" -ForegroundColor Yellow
Write-Host "  contactEndpoint -> hoje vazio: o formulario NAO envia nada" -ForegroundColor Yellow
