FROM node:current-alpine

RUN apk add --no-cache openssh-client && apk add --no-cache --upgrade bash
RUN npm install -g heroku

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]