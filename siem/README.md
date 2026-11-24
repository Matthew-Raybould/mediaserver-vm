# Wazuh SIEM Server

A SIEM Server that utilizes Wazuh (used for Managing, Indexing, and access to a Dashboard) running on Ubuntu Server LTS ('siemserver-vm') over the same subnet.

## SIEM Specifications
- **OS:** Ubuntu Server LTS Version: 26.04.1
- **CPUs:** 2 vCPUs
- **RAM:** 4 GB of RAM
- **Storage:** 50 GB LVM

## Log Pathing
```text
[agent monitors -> 'auth.log', 'syslog', File Integrity, SCA]
[Jellyfin Application logs: 'jellyfin-agent-snippet.xml' -> '/var/log/jellyfin/jellyfin*.log']
```
