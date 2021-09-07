FROM node:12-alpine

WORKDIR /app
COPY ./ /app

RUN npm i

RUN cp -rf /app/front-repo/node_modules/ /app/node_modules
RUN rm -rf front-repo
RUN npm run build

EXPOSE 3000

CMD npm run start:prod

