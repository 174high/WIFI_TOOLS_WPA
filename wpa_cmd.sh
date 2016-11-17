================================================================================================================================================================

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
dhcpcd wlan0
2>静态设置IP
ifconfig wlan0 192.168.100.200
ifconfig eth0 192.168.120.56 
ifconfig eth0 192.168.120.56 netmask 255.255.255.0 
ifconfig eth0 192.168.120.56 netmask 255.255.255.0 broadcast 192.168.120.255
route add default gw 192.168.0.1
PS：
a>.获取IP的方式取一种测试即可
b>.常用的wpa_sullicant命令
-------------------------------------------------------------------------------------------------------------------------------------------------------
 Full command         Short command                    Description
  status                 stat            displays the current connection status
  disconnect             disc            prevents wpa_supplicant from connecting to any access point
  quit                   q               exits wpa_cli
  terminate              term            kills wpa_supplicant
  reconfigure            recon           reloads wpa_supplicant with the configuration file supplied (-c parameter)
  scan                   scan            scans for available access points (only scans it, doesn‘t display anything)
  scan_result            scan_r          displays the results of the last scan
  list_networks          list_n          displays a list of configured networks and their status (active or not, enabled or disabled)
  select_network         select_n        select a network among those defined to initiate a connection (ie select_network 0)
  enable_network         enable_n        makes a configured network available for selection (ie enable_network 0)
  disable_network        disable_n       makes a configured network unavailable for selection (ie disable_network 0)
  remove_network         remove_n        removes a network and its configuration from the list (ie remove_network 0)
  add_network            add_n           adds a new network to the list. Its id will be created automatically
  set_network            set_n           shows a very short list of available options to configure a network when supplied with no parameters.
                                         See next section for a list of extremely useful parameters to be used with set_network and get_network.
  get_network            get_n           displays the required parameter for the specified network. See next section for a list of parameters
  save_config            save_c          saves the configuration
-------------------------------------------------------------------------------------------------------------------------------------------------------

================================================================================================================================================================

二、softAP测试（链接：http://blog.sina.com.cn/s/blog_a000da9d01014m5e.html）
1.config softAP
hostapd -B /data/misc/wifi/hostapd.conf
ps：
a>.hostapd.conf配置文件得自己编写
b>.调试softAP功能前，需要先将hostapd可执行文件编译出来
c>.如果STA与AP功能的firmwire不为同一个时，在调试STA前需要重新载入wifi模块，并且指定AP firmwire的路径

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

================================================================================================================================================================

三、P2P测试
iw phy `ls /sys/class/ieee80211/` interface add p2p0 type managed

ifconfig p2p0 192.168.43.3 netmask 255.255.255.0 up

wpa_supplicant  -ip2p0 -Dnl80211 -c/data/misc/wifi/p2p_supplicant.conf &

wpa_cli -p /data/misc/wifi/p2p0

p2p_connect 8a:e3:ab:cb:4e:a4  pbc

1.type it  p2p_connect  9a:0c:82:4d:3d:d8  pbc  on our platform

2. connect our network on mobile 

3.dhcpcd  p2p-p2p0-0 























