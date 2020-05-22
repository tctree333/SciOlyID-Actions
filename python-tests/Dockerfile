FROM python:3.7-alpine

RUN apk add --no-cache curl gcc musl-dev

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]