@echo off
REM Script para rodar Terraform via Docker
REM Certifique-se de ter as variaveis AWS configuradas antes de executar

echo ============================================
echo    Terraform Deploy Script via Docker
echo ============================================
echo.

REM Verificar se as variaveis AWS estao definidas
if "%AWS_ACCESS_KEY_ID%"=="" (
    echo [ERRO] AWS_ACCESS_KEY_ID nao esta definida!
    echo.
    echo Execute os comandos abaixo antes de rodar este script:
    echo   set AWS_ACCESS_KEY_ID=sua_access_key
    echo   set AWS_SECRET_ACCESS_KEY=sua_secret_key
    echo   set TF_VAR_docker_image=sua_imagem_docker
    echo   set TF_VAR_app_keys=suas_app_keys
    echo.
    pause
    exit /b 1
)

if "%AWS_SECRET_ACCESS_KEY%"=="" (
    echo [ERRO] AWS_SECRET_ACCESS_KEY nao esta definida!
    pause
    exit /b 1
)

if "%TF_VAR_docker_image%"=="" (
    echo [ERRO] TF_VAR_docker_image nao esta definida!
    echo Exemplo: set TF_VAR_docker_image=123456789.dkr.ecr.us-east-1.amazonaws.com/strapi-devops:latest
    pause
    exit /b 1
)

if "%TF_VAR_app_keys%"=="" (
    echo [ERRO] TF_VAR_app_keys nao esta definida!
    echo Exemplo: set TF_VAR_app_keys=chave1,chave2,chave3,chave4
    pause
    exit /b 1
)

echo [OK] Variaveis de ambiente verificadas!
echo.

REM Criar diretorio para cache do Terraform se nao existir
if not exist ".terraform-cache" mkdir .terraform-cache

echo [1/3] Inicializando Terraform...
echo.

docker run --rm -it ^
    -v "%cd%:/workspace" ^
    -v "%cd%\.terraform-cache:/workspace/.terraform" ^
    -w /workspace ^
    -e AWS_ACCESS_KEY_ID=%AWS_ACCESS_KEY_ID% ^
    -e AWS_SECRET_ACCESS_KEY=%AWS_SECRET_ACCESS_KEY% ^
    -e AWS_DEFAULT_REGION=us-east-1 ^
    -e TF_VAR_docker_image=%TF_VAR_docker_image% ^
    -e TF_VAR_app_keys=%TF_VAR_app_keys% ^
    hashicorp/terraform:latest init

if %ERRORLEVEL% neq 0 (
    echo [ERRO] Terraform init falhou!
    pause
    exit /b 1
)

echo.
echo [2/3] Executando Terraform Plan...
echo.

docker run --rm -it ^
    -v "%cd%:/workspace" ^
    -v "%cd%\.terraform-cache:/workspace/.terraform" ^
    -w /workspace ^
    -e AWS_ACCESS_KEY_ID=%AWS_ACCESS_KEY_ID% ^
    -e AWS_SECRET_ACCESS_KEY=%AWS_SECRET_ACCESS_KEY% ^
    -e AWS_DEFAULT_REGION=us-east-1 ^
    -e TF_VAR_docker_image=%TF_VAR_docker_image% ^
    -e TF_VAR_app_keys=%TF_VAR_app_keys% ^
    hashicorp/terraform:latest plan -out=tfplan

if %ERRORLEVEL% neq 0 (
    echo [ERRO] Terraform plan falhou!
    pause
    exit /b 1
)

echo.
echo ============================================
echo    Revise o plano acima antes de continuar
echo ============================================
echo.
set /p CONFIRM="Deseja aplicar as mudancas? (s/n): "

if /i "%CONFIRM%" neq "s" (
    echo Operacao cancelada pelo usuario.
    pause
    exit /b 0
)

echo.
echo [3/3] Aplicando Terraform...
echo.

docker run --rm -it ^
    -v "%cd%:/workspace" ^
    -v "%cd%\.terraform-cache:/workspace/.terraform" ^
    -w /workspace ^
    -e AWS_ACCESS_KEY_ID=%AWS_ACCESS_KEY_ID% ^
    -e AWS_SECRET_ACCESS_KEY=%AWS_SECRET_ACCESS_KEY% ^
    -e AWS_DEFAULT_REGION=us-east-1 ^
    -e TF_VAR_docker_image=%TF_VAR_docker_image% ^
    -e TF_VAR_app_keys=%TF_VAR_app_keys% ^
    hashicorp/terraform:latest apply -auto-approve tfplan

if %ERRORLEVEL% neq 0 (
    echo [ERRO] Terraform apply falhou!
    pause
    exit /b 1
)

echo.
echo ============================================
echo    Deploy concluido com sucesso!
echo ============================================
echo.

REM Mostrar outputs
docker run --rm ^
    -v "%cd%:/workspace" ^
    -v "%cd%\.terraform-cache:/workspace/.terraform" ^
    -w /workspace ^
    -e AWS_ACCESS_KEY_ID=%AWS_ACCESS_KEY_ID% ^
    -e AWS_SECRET_ACCESS_KEY=%AWS_SECRET_ACCESS_KEY% ^
    -e AWS_DEFAULT_REGION=us-east-1 ^
    hashicorp/terraform:latest output

echo.
pause

