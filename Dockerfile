# Use official Node.js image as base
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

EXPOSE 84

HEALTHCHECK --interval=10s --timeout=2s --start-period=15s \  
    CMD node healthcheck.cjs

CMD ["node", ".output/server/index.mjs"]
