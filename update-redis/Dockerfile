FROM debian:10

RUN apt-get update && apt-get install -y openssh-client curl
RUN curl https://cli-assets.heroku.com/install.sh | sh

COPY entrypoint.sh /entrypoint.sh
#COPY test.sh /test.sh
RUN chmod +x /entrypoint.sh
#RUN chmod +x /test.sh
ENTRYPOINT [ "/entrypoint.sh" ]
#ENTRYPOINT [ "/test.sh" ]