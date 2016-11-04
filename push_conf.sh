adb push p2p_supplicant.conf  /data/misc/wifi
adb push wpa_supplicant.conf  /data/misc/wifi
adb push udhcpd.conf         /data/misc/wifi
adb push hostapd.conf        /data/misc/wifi
adb push hostapd.conf        /system/etc/wifi
adb push hostapd             /system/bin
adb push  busybox            /system/bin
