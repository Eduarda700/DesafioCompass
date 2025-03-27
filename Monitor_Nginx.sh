#!/bin/bash

# Token do Bot do Telegram e chat ID
BOT_TOKEN="Bot token"
CHAT_ID="chat id"

# Função para enviar a mensagem para o Telegram
send_telegram_message() {
    local message=$1
    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
        -d chat_id="$CHAT_ID" \
        -d text="$message"
}

# Verificar se o Nginx está ativo
if ! systemctl is-active --quiet nginx; then
    send_telegram_message "❌ Nginx não está rodando!"
    exit 1
fi

# Local do arquivo error.log do Nginx
error_log="/var/log/nginx/error.log"

# Verificar se houve erros recentes no log
recent_errors=$(tail -n 20 "$error_log" | grep -i "error")

if [[ -n "$recent_errors" ]]; then
    message="🚨 Erros encontrados no log de erros do Nginx:\n$recent_errors"
    send_telegram_message "$message"
    exit 1
fi

# Local do arquivo access.log do Nginx
access_log="/var/log/nginx/access.log"

# Verificar acessos no último minuto
recent_access=$(tail -n 50 "$access_log" | grep -i "GET")

if [[ -z "$recent_access" ]]; then
    # Se não houver acessos recentes, você pode decidir notificar aqui.
    echo "❗ Nenhum acesso recente detectado."
else
    # Caso haja acessos recentes, você pode decidir não fazer nada ou apenas registrar no log.
    echo "🔹 Acessos recentes detectados no Nginx."
fi
