#!/usr/bin/env bash
# ==============================================================================
# Regras de Firewall (iptables) para Gateway Filial
# ==============================================================================
set -euo pipefail

echo "[+] Aplicando regras iptables no gateway-filial..."

# 1. Liberar portas de negociacao IKEv2 (UDP 500 e UDP 4500 NAT-T) e protocolo ESP
iptables -I INPUT -p udp --dport 500 -j ACCEPT
iptables -I INPUT -p udp --dport 4500 -j ACCEPT
iptables -I INPUT -p esp -j ACCEPT

# 2. Permitir pacotes protegidos por politica IPsec no INPUT e FORWARD
iptables -I INPUT -m policy --dir in --pol ipsec -j ACCEPT
iptables -I FORWARD -m policy --dir in --pol ipsec -j ACCEPT
iptables -I FORWARD -m policy --dir out --pol ipsec -j ACCEPT

# 3. Bypass de NAT / Masquerade para trafego IPsec (evita que a LAN seja mascarada)
iptables -t nat -I POSTROUTING 1 -m policy --dir out --pol ipsec -j ACCEPT

# 4. MSS Clamping para evitar fragmentacao de pacotes TCP sob o tunel IPsec
iptables -t mangle -I FORWARD -m policy --dir out --pol ipsec -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu

echo "[✓] Regras aplicadas com sucesso no gateway-filial."
