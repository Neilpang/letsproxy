FROM neilpang/nginx-proxy-base

RUN apt-get update \
 && apt-get install -y -q --no-install-recommends \
    cron curl \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*

ENV ACME_BUILD_DATE=2019-07-02
ENV AUTO_UPGRADE=1
ENV LE_WORKING_DIR=/acme.sh
ENV LE_CONFIG_HOME=/acmecerts
RUN curl https://get.acme.sh | sh && crontab -l | sed 's#> /dev/null##' | crontab -

VOLUME ["/acmecerts"]
EXPOSE 443

COPY nginx.tmpl /app/
COPY Procfile /app/
COPY updatessl.sh /app/

RUN chmod +x /app/updatessl.sh

RUN mkdir -p /etc/nginx/stream.d && echo "stream { \
include /etc/nginx/stream.d/*.conf; \
}" >> /etc/nginx/nginx.conf

VOLUME ["/etc/nginx/stream.d"]

