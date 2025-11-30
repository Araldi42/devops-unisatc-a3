@echo off
REM Script para limpar recursos orfaos da AWS via Docker
REM Util quando o terraform state nao esta sincronizado

echo ============================================
echo    AWS Cleanup Script via Docker
echo ============================================
echo.
echo Este script remove recursos orfaos do projeto strapi-devops
echo.

REM Verificar se as variaveis AWS estao definidas
if "%AWS_ACCESS_KEY_ID%"=="" (
    echo [ERRO] AWS_ACCESS_KEY_ID nao esta definida!
    echo.
    echo Execute os comandos abaixo antes de rodar este script:
    echo   set AWS_ACCESS_KEY_ID=sua_access_key
    echo   set AWS_SECRET_ACCESS_KEY=sua_secret_key
    echo.
    pause
    exit /b 1
)

if "%AWS_SECRET_ACCESS_KEY%"=="" (
    echo [ERRO] AWS_SECRET_ACCESS_KEY nao esta definida!
    pause
    exit /b 1
)

set /p CONFIRM="Deseja limpar recursos orfaos do strapi-devops? (s/n): "

if /i "%CONFIRM%" neq "s" (
    echo Operacao cancelada.
    pause
    exit /b 0
)

echo.
echo [1/5] Removendo CloudWatch Log Group...
docker run --rm ^
    -e AWS_ACCESS_KEY_ID=%AWS_ACCESS_KEY_ID% ^
    -e AWS_SECRET_ACCESS_KEY=%AWS_SECRET_ACCESS_KEY% ^
    -e AWS_DEFAULT_REGION=us-east-1 ^
    amazon/aws-cli logs delete-log-group --log-group-name /ecs/strapi-devops 2>nul
echo Done.

echo.
echo [2/5] Desanexando policies da IAM Role de execucao...
docker run --rm ^
    -e AWS_ACCESS_KEY_ID=%AWS_ACCESS_KEY_ID% ^
    -e AWS_SECRET_ACCESS_KEY=%AWS_SECRET_ACCESS_KEY% ^
    -e AWS_DEFAULT_REGION=us-east-1 ^
    amazon/aws-cli iam detach-role-policy --role-name strapi-devops-ecs-task-execution-role --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy 2>nul
echo Done.

echo.
echo [3/5] Removendo IAM Role de execucao...
docker run --rm ^
    -e AWS_ACCESS_KEY_ID=%AWS_ACCESS_KEY_ID% ^
    -e AWS_SECRET_ACCESS_KEY=%AWS_SECRET_ACCESS_KEY% ^
    -e AWS_DEFAULT_REGION=us-east-1 ^
    amazon/aws-cli iam delete-role --role-name strapi-devops-ecs-task-execution-role 2>nul
echo Done.

echo.
echo [4/5] Removendo IAM Role da task...
docker run --rm ^
    -e AWS_ACCESS_KEY_ID=%AWS_ACCESS_KEY_ID% ^
    -e AWS_SECRET_ACCESS_KEY=%AWS_SECRET_ACCESS_KEY% ^
    -e AWS_DEFAULT_REGION=us-east-1 ^
    amazon/aws-cli iam delete-role --role-name strapi-devops-ecs-task-role 2>nul
echo Done.

echo.
echo [5/5] Listando VPCs existentes...
echo.
docker run --rm ^
    -e AWS_ACCESS_KEY_ID=%AWS_ACCESS_KEY_ID% ^
    -e AWS_SECRET_ACCESS_KEY=%AWS_SECRET_ACCESS_KEY% ^
    -e AWS_DEFAULT_REGION=us-east-1 ^
    amazon/aws-cli ec2 describe-vpcs --query "Vpcs[*].{VpcId:VpcId,Name:Tags[?Key=='Name']|[0].Value,CidrBlock:CidrBlock}" --output table

echo.
echo ============================================
echo    Limpeza concluida!
echo ============================================
echo.
echo Se precisar deletar uma VPC, faca manualmente pelo console AWS
echo ou use: aws ec2 delete-vpc --vpc-id vpc-XXXXXXXX
echo.
echo Agora voce pode executar run-terraform.bat
echo.
pause

