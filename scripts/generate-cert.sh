#!/bin/bash
set -e

HOSTNAME=$(grep HOSTNAME .env | cut -d '=' -f2)
mkdir -p ssl

echo "🧾 Gerando certificado para $HOSTNAME ..."

openssl req -x509 -nodes -days 730 -newkey rsa:2048 \
  -keyout ssl/${HOSTNAME}.key -out ssl/${HOSTNAME}.crt \
  -subj "/C=BR/ST=Local/L=Home/O=GitLab/OU=DevOps/CN=${HOSTNAME}"

echo "✅ Certificado gerado em ssl/${HOSTNAME}.crt"
