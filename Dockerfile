FROM debian:10-slim

RUN apt-get update && apt-get install -y openssh-client git
RUN curl -sL https://sentry.io/get-cli/ | bash
RUN curl https://cli-assets.heroku.com/install.sh | sh

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]