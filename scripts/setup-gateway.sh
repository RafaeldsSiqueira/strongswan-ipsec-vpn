#!/usr/bin/env bash
# ==============================================================================
# Script de Provisionamento do SO para Gateways IPsec (Rocky Linux 9+)
# ==============================================================================
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
   echo "[-] Este script deve ser executado como root (sudo)."
   exit 1
fi

echo "[1/4] Habilitando repasse de pacotes IPv4 no Kernel..."
echo "net.ipv4.ip_forward = 1" > /etc/sysctl.d/99-ipforward.conf
sysctl -p /etc/sysctl.d/99-ipforward.conf

echo "[2/4] Ajustando servicos de firewall (desativando firewalld para uso de iptables)..."
if systemctl is-active --quiet firewalld; then
    systemctl stop firewalld
    systemctl disable firewalld
fi

echo "[3/4] Instalando dependencias (EPEL, strongSwan e iptables-services)..."
dnf install -y epel-release
dnf install -y strongswan iptables-services

echo "[4/4] Ativando servicos no boot..."
systemctl enable --now iptables
systemctl enable --now strongswan

echo "[✓] Ambiente base provisionado com sucesso!"
echo "    Proximo passo: copiar os arquivos de configuracao em /etc/strongswan/swanctl/conf.d/ e aplicar regras iptables."
