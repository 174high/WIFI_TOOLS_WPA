一、WIFI connect测试（STA）
1.wpa_supplicant -d -Dnl80211 -c/data/misc/wifi/wpa_supplicant.conf -iwlan0 -B

2.wpa_cli -p /data/misc/wifi/wlan0
ps:因为wpa_supplicant.conf中的ctrl_interface=/data/misc/wifi/wlan0。

3.连接AP
add_network (assume returns 2)
>set_network 2 ssid  ""
>set_network 2 psk  ""（AP有设密码）
>set_network 2 key_mgmt  NONE（AP没有无密码）
>select_network 2
>enable_network 2

4.设置IP与网关
1>动态获取IP
dhpad wlan0
2>静态设置IP
ifconfig wlan0 192.168.100.200
ifconfig eth0 192.168.120.56 
ifconfig eth0 192.168.120.56 netmask 255.255.255.0 
ifconfig eth0 192.168.120.56 netmask 255.255.255.0 broadcast 192.168.120.255
route add default gw 192.168.0.1
PS：获取IP的方式取一种测试即可

二、softAP测试（链接：http://blog.sina.com.cn/s/blog_a000da9d01014m5e.html）
1.config softAP
hostapd -B /data/misc/wifi/hostapd.conf

2.config ip address
ifconfig wlan0 192.168.43.1  netmask 255.255.255.0 
 
3.config iptables
echo 1 > /proc/sys/net/ipv4/ip_forward
cat /proc/sys/net/ipv4/ip_forward
 
4.create share net chain
iptables -A FORWARD -i eth0 -o wlan0 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
 
5.config dnsmasq
dnsmasq --no-daemon --no-resolv --no-poll --dhcp-range=192.168.43.100,192.168.43.200,100h

三、P2P测试
iw phy `ls /sys/class/ieee80211/` interface add p2p0 type managed

ifconfig p2p0 192.168.43.3 netmask 255.255.255.0 up

wpa_supplicant  -ip2p0 -Dnl80211 -c/data/misc/wifi/p2p_supplicant.conf &

wpa_cli -p /data/misc/wifi/p2p0

p2p_connect 8a:e3:ab:cb:4e:a4  pbc

1.type it  p2p_connect  9a:0c:82:4d:3d:d8  pbc  on our platform

2. connect our network on mobile 

3.dhcpcd  p2p-p2p0-0 























