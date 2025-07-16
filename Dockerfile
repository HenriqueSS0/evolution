FROM node:20-alpine

RUN apk update && apk add --no-cache git bash ffmpeg openssl

RUN git clone https://github.com/EvolutionAPI/evolution-api.git /evolution-api

WORKDIR /evolution-api
RUN npm install

# REMOVA a linha de prisma migrate/generate, pois está faltando schema.prisma
# RUN npx prisma migrate deploy
# RUN npx prisma generate

RUN npm run build

EXPOSE 8080

CMD ["npm", "run", "start:prod"]
