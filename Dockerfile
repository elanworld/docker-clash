FROM alpine:3.15
WORKDIR /app
RUN apk add iptables
ADD ./ .
RUN mkdir -p "/.config/clash"
RUN mkdir -p "/app/config"
RUN mv Country.mmdb /.config/clash
RUN chown -R 1001:1001 "/.config"
RUN chown -R 1001:1001 "/app"
RUN chmod -R +x /app
CMD /app/entrypoint.sh