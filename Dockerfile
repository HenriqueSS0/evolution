FROM atendai/evolution-api:latest

EXPOSE 8080

CMD ["npm", "run", "start:prod"]
