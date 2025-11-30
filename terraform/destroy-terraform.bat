@echo off
REM Script para destruir recursos Terraform via Docker

echo ============================================
echo    Terraform DESTROY Script via Docker
echo ============================================
echo.
echo [ATENCAO] Este script ira DESTRUIR todos os recursos!
echo.

REM Verificar se as variaveis AWS estao definidas
if "%AWS_ACCESS_KEY_ID%"=="" (
    echo [ERRO] AWS_ACCESS_KEY_ID nao esta definida!
    pause
    exit /b 1
)

if "%AWS_SECRET_ACCESS_KEY%"=="" (
    echo [ERRO] AWS_SECRET_ACCESS_KEY nao esta definida!
    pause
    exit /b 1
)

set /p CONFIRM="Tem certeza que deseja DESTRUIR todos os recursos? (digite 'sim' para confirmar): "

if /i "%CONFIRM%" neq "sim" (
    echo Operacao cancelada.
    pause
    exit /b 0
)

echo.
echo [1/2] Inicializando Terraform...
echo.

docker run --rm -it ^
    -v "%cd%:/workspace" ^
    -v "%cd%\.terraform-cache:/workspace/.terraform" ^
    -w /workspace ^
    -e AWS_ACCESS_KEY_ID=%AWS_ACCESS_KEY_ID% ^
    -e AWS_SECRET_ACCESS_KEY=%AWS_SECRET_ACCESS_KEY% ^
    -e AWS_DEFAULT_REGION=us-east-1 ^
    -e TF_VAR_docker_image=placeholder ^
    -e TF_VAR_app_keys=placeholder ^
    hashicorp/terraform:latest init

echo.
echo [2/2] Destruindo recursos...
echo.

docker run --rm -it ^
    -v "%cd%:/workspace" ^
    -v "%cd%\.terraform-cache:/workspace/.terraform" ^
    -w /workspace ^
    -e AWS_ACCESS_KEY_ID=%AWS_ACCESS_KEY_ID% ^
    -e AWS_SECRET_ACCESS_KEY=%AWS_SECRET_ACCESS_KEY% ^
    -e AWS_DEFAULT_REGION=us-east-1 ^
    -e TF_VAR_docker_image=placeholder ^
    -e TF_VAR_app_keys=placeholder ^
    hashicorp/terraform:latest destroy -auto-approve

echo.
echo ============================================
echo    Recursos destruidos!
echo ============================================
echo.
pause

