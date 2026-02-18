# MikroTik RB941-2nD – Dokumentacja Konfiguracji

## 🖥 Informacje o urządzeniu

- Model: RB941-2nD (hAP lite)
- RouterOS: 6.49.19
- Rola: Router brzegowy + VLAN Router + DHCP + Firewall + SNMP
- Lokalizacja: Home Lab
- Strefa czasowa: Europe/Warsaw

---

# Architektura sieci

Router realizuje:
- routing między VLAN
- NAT do Internetu
- firewall między segmentami
- DHCP dla każdej podsieci
- SNMP dla systemu monitoringu

---

# VLAN i segmentacja

## Skonfigurowane VLAN

| VLAN ID | Nazwa logiczna | Adresacja | Przeznaczenie |
|----------|---------------|------------|----------------|
| 1 | vlan1 | 192.168.110.0/24 | Native VLAN |
| 10 | vlan10 | 192.168.101.0/24 | Home-Lab |
| 20 | vlan20 | 192.168.102.0/24 | Sieć izolowana |

Bridge działa z włączonym `vlan-filtering=yes`.

### Konfiguracja trunk/access:

- ether2:
  - untagged: VLAN 1
  - tagged: VLAN 10, 20
- bridge: tagged dla VLAN 1,10,20

Router realizuje inter-VLAN routing.

---

# Adresacja IP

| Interfejs | IP | Funkcja |
|-----------|----|----------|
| ether1 | 192.168.100.250/24 | WAN |
| vlan1 | 192.168.110.1/24 | Gateway VLAN1 |
| vlan10 | 192.168.101.1/24 | Gateway VLAN10 |
| vlan20 | 192.168.102.1/24 | Gateway VLAN20 |


---

# DHCP

Oddzielny DHCP server dla każdego VLAN.

| VLAN | Zakres DHCP |
|------|-------------|
| VLAN1 | 192.168.110.2-99 |
| VLAN10 | 192.168.101.2-99 |
| VLAN20 | 192.168.102.2-99 |

Lease time: 1h

DNS:
- Lokalny router jako DNS
- Forward do 8.8.8.8

---

# Wireless

- Tryb: AP-Bridge
- Pasmo: 2.4GHz b/g/n
- SSID: skonfigurowany
- WPA2-PSK
- WPS: wyłączone
- Access-list z kontrolą MAC

---

# Firewall

## Izolacja VLAN

Blokada ruchu:
- VLAN20 → VLAN10
- VLAN20 → VLAN1

Zapewnia separację sieci izolowanej od reszty infrastruktury.

---

## Chain INPUT (ochrona routera)

Zasady:

1. Allow established/related
2. Drop invalid
3. Allow ICMP
4. Allow SNMP z VLAN10 (192.168.101.0/24)
5. Allow dostęp administracyjny z 192.168.100.0/24
6. Drop wszystko spoza LAN

Model bezpieczeństwa: **Default Deny**

---

## Chain FORWARD

- FastTrack dla established/related
- Drop invalid
- NAT kontrolowany
- Reguła blokująca ruch nieautoryzowany między VLAN

---

# NAT

Cały ruch wychodzący do Internetu translacjonowany.

---

# SNMP

- SNMPv2
- Community: ograniczone do 192.168.101.0/24
- Trap: start-trap
- Monitoring w Zabbix

Monitorowane:
- CPU
- RAM
- Interfejsy
- Uptime

---

# Wyłączone usługi

- Telnet
- FTP
- WWW
- SSH
- API
- API-SSL

Zmniejszenie powierzchni ataku.

---

# Port Mirroring

- ether2 → mirror-source
- ether3 → mirror-target

Używane do analizy ruchu (np. Wireshark).

---

# Podsumowanie

Zastosowano:

- Segmentację VLAN
- Izolację ruchu przez firewall
- Default deny dla INPUT
- Ograniczenie SNMP do dedykowanej podsieci
- Wyłączenie zbędnych usług

Konfiguracja zapewnia:
- separację środowisk
- podstawowe bezpieczeństwo warstwy 3
- możliwość centralnego monitoringu

---

# Diagram logiczny

```mermaid
flowchart TD

ISP --> WAN[ether1 - WAN]

WAN --> Router[MikroTik RB941]

Router --> VLAN1[192.168.110.0/24]
Router --> VLAN10[192.168.101.0/24]
Router --> VLAN20[192.168.102.0/24]

VLAN20 -. BLOCKED .-> VLAN10
VLAN20 -. BLOCKED .-> VLAN1
