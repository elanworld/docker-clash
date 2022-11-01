adduser -h / -u 1001 -g 1001 -D clash
sh ip-gateway.sh
chown clash:clash /app/config
su - clash -c "/app/clash -f /app/config/config.yaml"
