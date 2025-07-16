FROM node:20-alpine

# Instala dependências
RUN apk update && apk add --no-cache git bash ffmpeg openssl

# Clona Evolution API
RUN git clone https://github.com/EvolutionAPI/evolution-api.git /evolution-api

# Instala dependências
WORKDIR /evolution-api
RUN npm install

# Executa a migração do banco com Prisma
RUN npx prisma migrate deploy

# Compila o projeto
RUN npm run build

# Expõe porta da API
EXPOSE 8080

# Inicia o serviço
CMD ["npm", "run", "start:prod"]
