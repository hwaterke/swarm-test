FROM node:alpine

WORKDIR /app
COPY package.json .
RUN yarn

COPY server.js .
COPY views views/

ENV NODE_ENV production
ENV MYWEB_VERSION 1

EXPOSE 3000

CMD yarn start
