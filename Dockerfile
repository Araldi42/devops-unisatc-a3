# Dockerfile para Aplicação Strapi
FROM node:22-alpine AS base

# Instalar dependências do sistema necessárias para o Strapi
RUN apk add --no-cache \
    build-base \
    gcc \
    autoconf \
    automake \
    libtool \
    python3 \
    py3-pip \
    vips-dev

WORKDIR /app

# Instalar pnpm globalmente
RUN npm install -g pnpm@latest-10

# ----- Build Stage -----
FROM base AS builder

# Copiar arquivos de dependências
COPY package.json pnpm-lock.yaml ./

# Instalar dependências
RUN pnpm install --frozen-lockfile

# Copiar código fonte
COPY . .

# Build da aplicação Strapi
RUN NODE_ENV=production pnpm build

# ----- Production Stage -----
FROM base AS runner

# Copiar dependências e build da etapa anterior
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/config ./config
COPY --from=builder /app/database ./database
COPY --from=builder /app/src ./src
COPY --from=builder /app/favicon.png ./

# Criar diretório para uploads
RUN mkdir -p /app/public/uploads

# Variáveis de ambiente
ENV NODE_ENV=production \
    HOST=0.0.0.0 \
    PORT=1337

# Expor porta
EXPOSE 1337

# Healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD node -e "require('http').get('http://localhost:1337/_health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Comando para iniciar a aplicação
CMD ["pnpm", "start"]

