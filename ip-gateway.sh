# check
set -e
if [ -z "$SUBNET" ]; then
    echo SUBNET val not present
    exit 1
fi
if [ "$SUBNET" == "x.x.x.x/24" ]; then
    echo "ERROR: subnet error $SUBNET"
    exit 1
fi

if [ "$1" == "off" ]; then
  # delete
  iptables -t nat -D POSTROUTING -s "$SUBNET" -j MASQUERADE || echo not exists chain
  iptables -t nat -D PREROUTING -p tcp -j clash || echo not exists chain
  iptables -t nat -D OUTPUT -p tcp -m owner ! --uid-owner 1001 -j REDIRECT --to-ports 7892 || echo not exists chain
  iptables -t nat -F clash || echo not exists chain # clenr
  iptables -t nat -X clash || echo not exists chain # delete
fi

if [ "$1" == "on" ]; then
  # do network config
  sysctl -w net.ipv4.ip_forward=1
  echo add rule ...
  iptables -t nat -N clash # new
  iptables -t nat -A POSTROUTING -s "$SUBNET" -j MASQUERADE
  iptables -t nat -A PREROUTING -p tcp -j clash
  iptables -t nat -A OUTPUT -p tcp  -m owner ! --uid-owner 1001 -j REDIRECT --to-ports 7892 # proxy tcp,except 1000 uid clash user

  echo chain clash ...
  iptables -t nat -A clash -d 0.0.0.0/8 -j RETURN
  iptables -t nat -A clash -d 10.0.0.0/8 -j RETURN
  iptables -t nat -A clash -d 127.0.0.0/8 -j RETURN
  iptables -t nat -A clash -d 169.254.0.0/16 -j RETURN
  iptables -t nat -A clash -d 172.16.0.0/12 -j RETURN
  iptables -t nat -A clash -d 192.168.0.0/16 -j RETURN
  iptables -t nat -A clash -d 224.0.0.0/4 -j RETURN
  iptables -t nat -A clash -d 240.0.0.0/4 -j RETURN
  iptables -t nat -A clash -p tcp -j REDIRECT --to-ports 7892

  echo show result
  iptables -t nat -L
fi

if [ -z "$1" ]; then
    echo need param: on or off
fi
