if [ -z "$SUBNET" ]; then
    SUMNET=192.168.1.0/24
fi

# 网关
iptables -t nat -F clash #删除链
iptables -t nat -X clash
iptables -t nat -N clash
iptables -t nat -A POSTROUTING -s "$SUBNET" -j MASQUERADE
iptables -t nat -A PREROUTING -p tcp -j clash
iptables -t nat -A OUTPUT -p tcp  -m owner ! --uid-owner 1001 -j REDIRECT --to-ports 7892 # 代理本地，除了1000 uid clash用户
# 排除本地连接
iptables -t nat -A clash -d 0.0.0.0/8 -j RETURN
iptables -t nat -A clash -d 10.0.0.0/8 -j RETURN
iptables -t nat -A clash -d 127.0.0.0/8 -j RETURN
iptables -t nat -A clash -d 169.254.0.0/16 -j RETURN
iptables -t nat -A clash -d 172.16.0.0/12 -j RETURN
iptables -t nat -A clash -d 192.168.0.0/16 -j RETURN
iptables -t nat -A clash -d 224.0.0.0/4 -j RETURN
iptables -t nat -A clash -d 240.0.0.0/4 -j RETURN
#透明代理重定向
iptables -t nat -A clash -p tcp -j REDIRECT --to-ports 7892
