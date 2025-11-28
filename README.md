# Pipeline CI/CD DevOps - Strapi

Este projeto implementa uma pipeline completa de CI/CD para uma aplicação Strapi usando GitHub Actions, Docker e Terraform.

## 🚀 Getting started with Strapi

Strapi comes with a full featured [Command Line Interface](https://docs.strapi.io/dev-docs/cli) (CLI) which lets you scaffold and manage your project in seconds.

### `pnpm` 

Instal pnpm. [Learn more](https://pnpm.io/installation#using-npm) 

```bash
npm install -g pnpm@latest-10
```

### `develop`

Start your Strapi application with autoReload enabled. [Learn more](https://docs.strapi.io/dev-docs/cli#strapi-develop)

```bash
pnpm dev
```

### `start`

Start your Strapi application with autoReload disabled. [Learn more](https://docs.strapi.io/dev-docs/cli#strapi-start)

```bash
pnpm start
```

### `build`

Build your admin panel. [Learn more](https://docs.strapi.io/dev-docs/cli#strapi-build)

```bash
pnpm build
```

---

## 🔄 Pipeline CI/CD

### Etapas Implementadas

✅ **1. Fork do projeto**
✅ **2. Testes com Playwright**
- Testes E2E automatizados para Autores e Categorias
- Executados em cada PR e push para master

✅ **3. Collection 1 & 2**
- Collection de Autores (`CriarAutor.spec.ts`)
- Collection de Categorias (`CriarCategoria.spec.ts`)

✅ **4. GitHub Actions em PRs**
- Workflow `e2e-tests.yml` executa automaticamente em PRs

✅ **5. Docker Build & Push**
- Build automatizado da imagem Docker
- Push para Docker Hub
- Cache otimizado para builds rápidas

✅ **6. Deploy com Terraform**
- Infraestrutura como código (IaC)
- Deploy automatizado para AWS ECS Fargate
- Application Load Balancer configurado

✅ **7. Pipeline Completa**
- Fluxo: Testes → Docker Build → Deploy
- Integração completa e automatizada

### Arquitetura da Pipeline

```
┌─────────────────┐
│   Pull Request  │
│   ou Push       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  🧪 Testes E2E  │ ◄── Playwright
│   (Obrigatório) │
└────────┬────────┘
         │
         ▼
    ┌────────┐
    │ Passou? │
    └───┬────┘
        │ Sim (apenas master)
        ▼
┌─────────────────┐
│ 🐳 Docker Build │ ◄── Build & Push
│   & Push        │     Docker Hub
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ ☁️  Deploy AWS  │ ◄── Terraform
│   ECS Fargate   │     Infrastructure
└─────────────────┘
```

## 🐳 Docker

### Build Local

```bash
docker build -t strapi-devops .
```

### Run Local

```bash
docker run -p 1337:1337 \
  -e APP_KEYS="sua-chave-1,sua-chave-2,sua-chave-3,sua-chave-4" \
  strapi-devops
```

### Push para Docker Hub

```bash
docker tag strapi-devops seu-usuario/strapi-devops:latest
docker push seu-usuario/strapi-devops:latest
```

## ☁️ Infraestrutura AWS (Terraform)

### Recursos Criados

- **VPC** com 2 subnets públicas
- **Application Load Balancer** (ALB)
- **ECS Cluster** com Fargate
- **ECS Service** rodando a aplicação
- **CloudWatch Logs** para monitoramento
- **Security Groups** configurados

### Deploy Manual

```bash
cd terraform

# Inicializar Terraform
terraform init

# Planejar mudanças
terraform plan \
  -var="docker_image=seu-usuario/strapi-devops:latest" \
  -var="app_keys=suas-chaves-strapi"

# Aplicar infraestrutura
terraform apply \
  -var="docker_image=seu-usuario/strapi-devops:latest" \
  -var="app_keys=suas-chaves-strapi"

# Ver outputs (URLs)
terraform output
```

### Destruir Infraestrutura

```bash
cd terraform
terraform destroy
```

## 🔐 Secrets Necessários

Configure os seguintes secrets no GitHub (Settings → Secrets and variables → Actions):

### Docker Hub
- `DOCKER_USERNAME`: Seu username do Docker Hub
- `DOCKER_PASSWORD`: Seu token/password do Docker Hub

### AWS
- `AWS_ACCESS_KEY_ID`: Access Key ID da AWS
- `AWS_SECRET_ACCESS_KEY`: Secret Access Key da AWS
- `AWS_REGION`: Região AWS (ex: `us-east-1`)

### Strapi
- `STRAPI_APP_KEYS`: Chaves de aplicação do Strapi (separadas por vírgula)

## 📋 Workflows

### 1. `e2e-tests.yml`
Executa testes E2E em todos os PRs e pushes

### 2. `docker-build.yml`
Build e push da imagem Docker (apenas master)

### 3. `deploy.yml`
Deploy com Terraform para AWS ECS (após docker-build)

### 4. `pipeline.yml`
**Pipeline completa integrada** - Executa tudo em sequência:
1. Testes
2. Docker (se testes passarem)
3. Deploy (se docker build passar)

## 🧪 Testando a Pipeline

### Criar PR que PASSA

```bash
git checkout -b feature/test-pass
echo "# Test" >> test.txt
git add test.txt
git commit -m "test: adiciona arquivo de teste"
git push origin feature/test-pass
```

Crie o PR no GitHub → ✅ Testes passarão

### Criar PR que FALHA

```bash
git checkout -b feature/test-fail
# Alterar config.yml para porta errada
sed -i 's/1337/9999/g' src/support/fixtures/config.yml
git add src/support/fixtures/config.yml
git commit -m "test: força erro nos testes"
git push origin feature/test-fail
```

Crie o PR no GitHub → ❌ Testes falharão

## 📊 Monitoramento

- **GitHub Actions**: Veja logs de execução em Actions
- **Docker Hub**: Verifique imagens em https://hub.docker.com
- **AWS CloudWatch**: Logs da aplicação ECS
- **AWS Console**: Monitore recursos no console AWS

## 🛠️ Tecnologias Utilizadas

- **Strapi 5.12.3**: CMS Headless
- **Playwright**: Testes E2E
- **Docker**: Containerização
- **Terraform**: Infrastructure as Code
- **AWS ECS Fargate**: Container orchestration
- **GitHub Actions**: CI/CD
- **Node.js 22**: Runtime

## 📝 Estrutura do Projeto

```
.
├── .github/
│   └── workflows/
│       ├── e2e-tests.yml      # Testes E2E
│       ├── docker-build.yml   # Build Docker
│       ├── deploy.yml         # Deploy AWS
│       └── pipeline.yml       # Pipeline completa
├── terraform/
│   ├── main.tf               # Config principal
│   ├── variables.tf          # Variáveis
│   ├── network.tf           # VPC e networking
│   ├── ecs.tf              # ECS cluster e service
│   └── outputs.tf          # Outputs (URLs)
├── src/
│   ├── scenarios/          # Testes Playwright
│   └── support/           # Page Objects
├── Dockerfile            # Imagem Docker
├── .dockerignore        # Arquivos ignorados
└── package.json        # Dependências Node.js
```

## 📚 Recursos Adicionais

- [Documentação Strapi](https://docs.strapi.io)
- [Playwright Docs](https://playwright.dev)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [GitHub Actions Docs](https://docs.github.com/en/actions)

---

<sub>🤫 Psst! [Strapi is hiring](https://strapi.io/careers).</sub>
