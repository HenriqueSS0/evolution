FROM node:20-alpine

# Instala dependências
RUN apk update && apk add --no-cache git bash ffmpeg openssl

# Clona Evolution API
RUN git clone https://github.com/EvolutionAPI/evolution-api.git /evolution-api

# Instala dependências
WORKDIR /evolution-api
RUN npm install

# Compila
RUN npm run build

# Expõe porta
EXPOSE 8080

# Inicia app
CMD ["npm", "run", "start:prod"]
