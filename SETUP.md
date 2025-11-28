# Guia de Configuração - Pipeline CI/CD

Este guia explica como configurar e usar a pipeline CI/CD completa do projeto.

## 📋 Pré-requisitos

1. Conta no [Docker Hub](https://hub.docker.com)
2. Conta na [AWS](https://aws.amazon.com)
3. Repositório GitHub com permissões de administrador

## 🔧 Configuração Inicial

### 1. Docker Hub

1. Acesse [Docker Hub](https://hub.docker.com)
2. Faça login ou crie uma conta
3. Vá em **Account Settings** → **Security** → **New Access Token**
4. Crie um token com permissões de **Read, Write, Delete**
5. Copie o token (você não poderá vê-lo novamente!)

### 2. AWS

#### Criar Usuário IAM

1. Acesse o [AWS Console](https://console.aws.amazon.com)
2. Vá para **IAM** → **Users** → **Create user**
3. Nome: `github-actions-user`
4. Anexe as políticas:
   - `AmazonECS_FullAccess`
   - `AmazonEC2ContainerRegistryFullAccess`
   - `AmazonVPCFullAccess`
   - `IAMFullAccess`
   - `CloudWatchLogsFullAccess`
   - `ElasticLoadBalancingFullAccess`

5. Vá em **Security credentials** → **Create access key**
6. Escolha **Third-party service**
7. Copie o **Access Key ID** e **Secret Access Key**

### 3. Configurar GitHub Secrets

1. Vá no seu repositório GitHub
2. **Settings** → **Secrets and variables** → **Actions**
3. Clique em **New repository secret**

Configure os seguintes secrets:

#### Docker Hub
```
DOCKER_USERNAME: seu-usuario-dockerhub
DOCKER_PASSWORD: seu-token-dockerhub
```

#### AWS
```
AWS_ACCESS_KEY_ID: AKIA...
AWS_SECRET_ACCESS_KEY: sua-secret-key
AWS_REGION: us-east-1
```

#### Strapi
```
STRAPI_APP_KEYS: chave1,chave2,chave3,chave4
```

**Gerar APP_KEYS:**
```bash
node -e "console.log(require('crypto').randomBytes(16).toString('base64'))"
```
Execute 4 vezes e junte com vírgulas.

## 🚀 Usar a Pipeline

### Fluxo Automático (Recomendado)

A pipeline **`pipeline.yml`** executa tudo automaticamente:

1. **Em Pull Request:**
   - ✅ Executa testes E2E
   - ❌ Não faz build/deploy

2. **Em Push para Master:**
   - ✅ Executa testes
   - ✅ Build e push Docker (se testes passarem)
   - ✅ Deploy AWS (se build passar)

### Workflows Individuais

#### 1. Apenas Testes
```bash
# Executado automaticamente em PRs
```

#### 2. Build Docker
```bash
# Em GitHub: Actions → Docker Build and Push → Run workflow
```

#### 3. Deploy AWS
```bash
# Em GitHub: Actions → Deploy to AWS ECS → Run workflow
```

## 📝 Testando a Pipeline

### PR que PASSA ✅

```bash
git checkout -b feature/nova-feature
# Faça suas alterações
git add .
git commit -m "feat: adiciona nova funcionalidade"
git push origin feature/nova-feature
```

Crie o PR no GitHub → Testes vão passar → ✅

### PR que FALHA ❌

```bash
git checkout -b feature/test-error

# Quebrar os testes alterando a porta
echo 'application:
  strapi_admin: "http://localhost:9999/admin"' > src/support/fixtures/config.yml

git add src/support/fixtures/config.yml
git commit -m "test: força erro nos testes"
git push origin feature/test-error
```

Crie o PR no GitHub → Testes vão falhar → ❌

## 🔍 Verificar Resultados

### GitHub Actions
- Vá em **Actions** no GitHub
- Veja os workflows em execução
- Clique em um workflow para ver logs detalhados

### Docker Hub
- Acesse https://hub.docker.com
- Vá no seu repositório `strapi-devops`
- Veja as tags das imagens

### AWS Console
- Acesse o [AWS Console](https://console.aws.amazon.com)
- **ECS** → **Clusters** → `strapi-devops-cluster`
- **EC2** → **Load Balancers** → Copie o DNS do ALB
- Acesse: `http://[ALB-DNS]/admin`

### CloudWatch Logs
- **CloudWatch** → **Log groups** → `/ecs/strapi-devops`
- Veja logs em tempo real da aplicação

## 🛑 Destruir Infraestrutura

Para economizar custos quando não estiver usando:

```bash
cd terraform
terraform destroy \
  -var="docker_image=seu-usuario/strapi-devops:latest" \
  -var="app_keys=suas-chaves"
```

Ou via GitHub Actions:
1. Crie um workflow manual
2. Execute `terraform destroy`

## 💰 Custos Estimados (AWS)

### Free Tier (12 meses)
- **ECS Fargate**: 25 GB-mês grátis
- **ALB**: 750 horas/mês (1 ALB grátis)

### Após Free Tier
- **ECS Fargate**: ~$15-30/mês (dependendo do uso)
- **ALB**: ~$20/mês
- **Data Transfer**: Variável

**Total estimado:** $35-50/mês

## 🔒 Segurança

### Boas Práticas

1. **Nunca commite secrets** no código
2. **Rotacione credenciais** regularmente
3. **Use IAM roles** com permissões mínimas
4. **Habilite MFA** na AWS
5. **Monitore custos** no AWS Billing

### Auditoria
- **CloudTrail**: Registra todas as ações AWS
- **GitHub Actions Logs**: Auditoria de deployments

## 🆘 Troubleshooting

### Erro: "Docker login failed"
- Verifique `DOCKER_USERNAME` e `DOCKER_PASSWORD`
- Gere um novo access token no Docker Hub

### Erro: "AWS credentials not found"
- Verifique secrets: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`
- Confirme que o usuário IAM tem as permissões corretas

### Erro: "Terraform apply failed"
- Verifique quotas da AWS (limits)
- Confirme que a região está correta
- Veja logs no CloudWatch

### Aplicação não responde
- Verifique logs no CloudWatch
- Confirme que o health check está passando
- Verifique Security Groups

## 📞 Suporte

- **Strapi**: https://strapi.io/support
- **AWS Support**: https://aws.amazon.com/support
- **GitHub Issues**: Abra um issue no repositório

## 🎓 Recursos de Aprendizado

- [AWS ECS Tutorial](https://aws.amazon.com/ecs/getting-started/)
- [Terraform Learn](https://learn.hashicorp.com/terraform)
- [GitHub Actions Tutorial](https://docs.github.com/en/actions/learn-github-actions)
- [Docker Tutorial](https://docs.docker.com/get-started/)

