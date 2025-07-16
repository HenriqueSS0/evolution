FROM node:20-slim

# Atualiza e instala dependências
RUN apt-get update && \
    apt-get install -y git ffmpeg bash openssl tzdata dos2unix && \
    cp /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && \
    echo "America/Sao_Paulo" > /etc/timezone && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV TZ=America/Sao_Paulo
ENV DOCKER_ENV=true

WORKDIR /evolution

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

RUN chmod +x ./Docker/scripts/* && \
    dos2unix ./Docker/scripts/* && \
    ./Docker/scripts/generate_database.sh

RUN npm run build

EXPOSE 8080

ENTRYPOINT ["/bin/bash", "-c", ". ./Docker/scripts/deploy_database.sh && npm run start:prod"]
