if [ -n "$SUBNET" ]; then
    sh ip-gateway.sh
fi
chown clash:clash /app/config
su - clash -c "/app/clash -f /app/config/config.yaml"
