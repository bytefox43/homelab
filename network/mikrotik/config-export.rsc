# feb/18/2026 11:34:04 by RouterOS 6.49.19
# software id = 5B81-MZLT
#
# model = RB941-2nD
# serial number = HF9097FRJJE
/interface bridge
add name=bridge vlan-filtering=yes
/interface wireless
set [ find default-name=wlan1 ] band=2ghz-b/g/n channel-width=20/40mhz-XX \
    mode=ap-bridge ssid="Network 11145" wps-mode=disabled
/interface vlan
add comment=CISCO interface=bridge name=vlan1 vlan-id=1
add comment=Home-Lab interface=bridge name=vlan10 vlan-id=10
add comment=MikroTik2 interface=bridge name=vlan20 vlan-id=20
/interface ethernet switch
set 0 mirror-source=ether2 mirror-target=ether3
/interface list
add name=LAN
add name=WAN
/interface wireless security-profiles
set [ find default=yes ] authentication-types=wpa2-psk disable-pmkid=yes \
    mode=dynamic-keys supplicant-identity=MikroTik wpa2-pre-shared-key=\
    password_anonimized
/ip pool
add name=pool1 ranges=192.168.115.2-192.168.115.99
add name=pool_vlan20 ranges=192.168.102.2-192.168.102.99
add name=pool_vlan10 ranges=192.168.101.2-192.168.101.99
add name=pool_vlan1 ranges=192.168.110.2-192.168.110.99
/ip dhcp-server
add address-pool=pool_vlan20 disabled=no interface=vlan20 lease-time=1h name=\
    server_vlan20
add address-pool=pool_vlan10 disabled=no interface=vlan10 lease-time=1h name=\
    server_vlan10
add address-pool=pool_vlan1 disabled=no interface=vlan1 lease-time=1h name=\
    server_vlan1
/routing ospf instance
set [ find default=yes ] disabled=yes
/snmp community
set [ find default=yes ] addresses=192.168.101.0/24 name=MikroTik
/interface bridge port
add bridge=bridge interface=ether2
/interface bridge vlan
add bridge=bridge tagged=bridge untagged=ether2 vlan-ids=1
add bridge=bridge tagged=bridge,ether2 vlan-ids=10
add bridge=bridge tagged=bridge,ether2 vlan-ids=20
/interface list member
add interface=bridge list=LAN
add interface=ether1 list=WAN
add interface=vlan10 list=LAN
add interface=vlan20 list=LAN
add interface=vlan1 list=LAN
/interface wireless access-list
add mac-address=5C:BA:EF:0B:E1:C3
add interface=wlan1 mac-address=D4:9C:DD:37:7D:7A vlan-mode=no-tag
/ip address
add address=192.168.110.1/24 interface=vlan1 network=192.168.110.0
add address=192.168.100.250/24 interface=ether1 network=192.168.100.0
add address=192.168.102.1/24 interface=vlan20 network=192.168.102.0
add address=192.168.101.1/24 interface=vlan10 network=192.168.101.0
/ip dhcp-server network
add address=192.168.101.0/24 dns-server=192.168.101.1 gateway=192.168.101.1
add address=192.168.102.0/24 dns-server=192.168.102.1 gateway=192.168.102.1
add address=192.168.110.0/24 dns-server=192.168.110.1 gateway=192.168.110.1
add address=192.168.115.0/24 dns-server=192.168.115.1 gateway=192.168.115.1
/ip dns
set allow-remote-requests=yes servers=8.8.8.8
/ip firewall filter
add action=drop chain=forward comment="Block VLAN20 -> VLAN10" dst-address=\
    192.168.101.0/24 src-address=192.168.102.0/24
add action=drop chain=forward comment="Block VLAN20 -> VLAN1" dst-address=\
    192.168.110.0/24 src-address=192.168.102.0/24
add action=accept chain=input comment="Allow SNMP from LAN" dst-port=161 \
    protocol=udp src-address=192.168.101.0/24
add action=accept chain=input comment=\
    "Zezw\F3l na dost\EAp do MikroTik z tej podsieci" src-address=\
    192.168.100.0/24
add action=accept chain=input connection-state=established,related,untracked
add action=drop chain=input connection-state=invalid
add action=accept chain=input protocol=icmp
add action=accept chain=input dst-address=127.0.0.1
add action=drop chain=input in-interface-list=!LAN
add action=accept chain=forward ipsec-policy=in,ipsec
add action=accept chain=forward ipsec-policy=out,ipsec
add action=fasttrack-connection chain=forward connection-state=\
    established,related
add action=accept chain=forward connection-state=\
    established,related,untracked
add action=drop chain=forward connection-state=invalid
add action=drop chain=forward connection-nat-state=!dstnat connection-state=\
    new disabled=yes in-interface-list=WAN
/ip firewall nat
add action=masquerade chain=srcnat out-interface-list=WAN
/ip route
add distance=1 gateway=192.168.100.1
/ip service
set telnet disabled=yes
set ftp disabled=yes
set www disabled=yes
set ssh disabled=yes
set api disabled=yes
set api-ssl disabled=yes
/snmp
set contact=example@gmail.com enabled=yes location=Cracow trap-generators=\
    start-trap trap-interfaces=all trap-version=2
/system clock
set time-zone-name=Europe/Warsaw
