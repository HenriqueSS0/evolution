FROM node:20-alpine

# Instala somente o necessário e com menos camadas
RUN apk add --no-cache git ffmpeg bash openssl tzdata && \
    cp /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && \
    echo "America/Sao_Paulo" > /etc/timezone

ENV TZ=America/Sao_Paulo
ENV DOCKER_ENV=true

WORKDIR /evolution

# Copia os arquivos necessários
COPY ./package.json ./tsconfig.json ./
RUN npm install

COPY ./src ./src
COPY ./public ./public
COPY ./prisma ./prisma
COPY ./manager ./manager
COPY ./.env.example ./.env
COPY ./runWithProvider.js ./
COPY ./tsup.config.ts ./
COPY ./Docker ./Docker

# Corrige permissões e linhas de script
RUN chmod +x ./Docker/scripts/* && \
    apk add --no-cache dos2unix && \
    dos2unix ./Docker/scripts/* && \
    ./Docker/scripts/generate_database.sh

RUN npm run build

EXPOSE 8080

ENTRYPOINT ["/bin/bash", "-c", ". ./Docker/scripts/deploy_database.sh && npm run start:prod"]
