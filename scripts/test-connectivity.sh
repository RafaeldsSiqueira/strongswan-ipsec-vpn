#!/usr/bin/env bash
# ==============================================================================
# Script de Validacao de Tunel e Conectividade IPsec
# ==============================================================================
set -euo pipefail

echo "============================================================"
echo " [1/3] Verificando Security Associations (swanctl --list-sas)"
echo "============================================================"
swanctl --list-sas || true

echo ""
echo "============================================================"
echo " [2/3] Verificando Politicas e Estados XFRM no Kernel"
echo "============================================================"
ip -s xfrm state || true

echo ""
echo "============================================================"
echo " [3/3] Resumo das Conexoes Configuradas"
echo "============================================================"
swanctl --list-conns || true
