if [ -n "$SUBNET" ]; then
    sh ip-gateway.sh on 
fi
chown clash:clash /app/config
# 设置一个信号处理函数来处理 SIGINT 信号
cleanup() {
    echo "接收到 SIGINT 信号，执行清理操作..."
    if [ -n "$SUBNET" ]; then
        sh ip-gateway.sh off 
    fi
    exit 0
}

# 将 cleanup 函数与 SIGINT 信号关联
trap cleanup SIGINT

su - clash -c "/app/clash -f /app/config/config.yaml"
