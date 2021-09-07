FROM node:12-alpine

WORKDIR /app
COPY ./ /app

RUN npm i

RUN ls
RUN ls front
RUN cp -rf front/node_modules/ node_modules/
RUN rm -rf front/node_modules

RUN npm run build

EXPOSE 3000

CMD npm run start:prod

