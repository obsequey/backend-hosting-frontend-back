FROM node:12-alpine

WORKDIR /app
COPY ./package.json /app

RUN npm i
COPY ./ /app

RUN npm run build
RUN cp ./front-repo/node_modules/ /app/node_modules
RUN rm -rf front-repo

EXPOSE 3000

CMD npm run start:prod

