FROM alpine:3.15
WORKDIR /app
RUN apk add iptables
RUN  if [ "aarch64" == $(uname -m) ]; then echo aarch64;wget https://github.com/Kuingsmile/clash-core/releases/download/1.18/clash-linux-arm64-v1.18.0.gz -O clash.gz; else if [ "x86_64" == $(uname -m) ]; then echo x86_64;wget https://github.com/Kuingsmile/clash-core/releases/download/1.18/clash-linux-amd64-v1.18.0.gz -O clash.gz; fi; fi
RUN wget https://github.com/Dreamacro/maxmind-geoip/releases/latest/download/Country.mmdb
RUN gunzip -c clash.gz > clash && rm -f clash.gz
ADD ./ .
RUN mkdir -p "/.config/clash"
RUN mkdir -p "/app/config"
RUN mv Country.mmdb /.config/clash
RUN chown -R 1001:1001 "/.config"
RUN chown -R 1001:1001 "/app"
RUN chmod -R +x /app
RUN adduser -h / -u 1001 -g 1001 -D clash
CMD sh /app/entrypoint.sh
# docker buildx build --platform linux/amd64,linux/arm64/v8  -t alanwoods/clash --push  .
