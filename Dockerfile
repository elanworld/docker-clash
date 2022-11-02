FROM alpine:3.15
WORKDIR /app
RUN apk add iptables
RUN wget https://github.com/Dreamacro/clash/releases/download/v1.11.8/clash-linux-amd64-v1.11.8.gz
RUN wget https://github.com/Dreamacro/maxmind-geoip/releases/latest/download/Country.mmdb
RUN gunzip -c clash-linux-amd64-v1.11.8.gz > clash
ADD ./ .
RUN mkdir -p "/.config/clash"
RUN mkdir -p "/app/config"
RUN mv Country.mmdb /.config/clash
RUN chown -R 1001:1001 "/.config"
RUN chown -R 1001:1001 "/app"
RUN chmod -R +x /app
RUN adduser -h / -u 1001 -g 1001 -D clash
CMD sh /app/entrypoint.sh
