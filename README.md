# homelab
Home Lab – DevOps / SysOps learning environment



## Cel projektu
Home Lab służy do nauki oraz praktycznego rozwijania umiejętności z obszaru:
- DevOps
- SysOps
- administracji systemami Linux
- sieci i monitoringu

---

## Technologie i narzędzia
- Proxmox (VM)
- MikroTik
- Zabbix (SNMP)
- Linux
- Bash
- Git / GitHub
- Visual Studio Code

---

## Architektura
- Serwer Proxmox jako hypervisor
- Maszyny wirtualne oraz kontenery LXC
- Segmentacja sieci (VLAN)
- Monitoring infrastruktury z użyciem Zabbix + SNMP

*(diagram do dodania)*

---

## Monitoring
- Monitoring urządzeń sieciowych (MikroTik) przez SNMP
- Monitoring VM i LXC
- Alerty i wizualizacja metryk w Zabbix

---

## Automatyzacja
- Skrypty Bash do:
  - backupów
  - zadań administracyjnych
- (Planowane) Ansible do automatyzacji konfiguracji

---

## Struktura repozytorium
```text
network/     - konfiguracja sieci
monitoring/  - Zabbix, SNMP, monitoring
proxmox/     - VM, LXC, architektura
automation/  - skrypty i automatyzacja
docs/        - dokumentacja techniczna


Roadmap

1. Repozytorium GitHub

2. Dokumentacja Markdown

3. Proxmox + VM/LXC

4. Zabbix + SNMP

5. Ansible

6. CI/CD (GitHub Actions)

7. Infrastructure as Code