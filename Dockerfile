FROM node:20-alpine AS builder

WORKDIR /app
COPY package*.json .
RUN npm install

COPY . .
RUN npx prisma generate
RUN npx prisma db push

RUN npm run build

FROM node:20-alpine

RUN apk add --no-cache openssl

WORKDIR /app

COPY package*.json .
RUN npm install --omit=dev

COPY .env .
COPY --from=builder /app/dist ./dist

CMD [ "npm", "run", "start" ]
