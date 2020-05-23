FROM python:3.7-alpine

RUN apk add --no-cache curl gcc musl-dev libffi-dev openssl-dev python3-dev zlib-dev

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]