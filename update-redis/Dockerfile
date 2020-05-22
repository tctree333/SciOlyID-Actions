FROM alpine:latest

RUN apk add --no-cache openssh-client curl && apk add --no-cache --upgrade bash
RUN curl https://cli-assets.heroku.com/install.sh | sh

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]