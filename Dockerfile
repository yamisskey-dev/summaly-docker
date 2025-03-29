FROM node:20.17.0

RUN mkdir app

WORKDIR /app
COPY ./app /app

RUN yarn install
RUN yarn build

EXPOSE 3030

CMD ["yarn","server"]