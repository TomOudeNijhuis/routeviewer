# Use official Node.js image as base
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

EXPOSE 84

CMD ["node", ".output/server/index.mjs"]
