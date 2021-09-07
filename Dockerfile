FROM node:12-alpine

COPY ./ /app
WORKDIR /app

RUN npm i
COPY ./front-repo/node_modules/ /app/node_modules
RUN npm run build

EXPOSE 3000

CMD npm run start:prod

