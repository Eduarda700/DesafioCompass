# Server-Monitoramento-Web

Este é um projeto prático para Linux e AWS. O objetivo é criar uma instância na AWS e configurá-la para monitorar a disponibilidade de um site HTML hospedado no servidor Nginx. Caso a aplicação fique indisponível, um webhook enviará notificações via Telegram.

---

## 📌 Índice
1. [Configuração do Ambiente](#etapa-1-configuração-do-ambiente)
2. [Configuração do Servidor Web](#etapa-2-configuração-do-servidor-web)
3. [Script de Monitoramento + Webhook](#etapa-3-script-de-monitoramento--webhook)
4. [Testes e Documentação](#etapa-4-testes-e-documentação)
5. [Conclusão](#conclusão)

---

## 🔧 Etapa 1: Configuração do Ambiente

### 1️⃣ Criação da VPC  
- Criei uma **VPC** com duas sub-redes públicas para acesso externo e duas sub-redes privadas para futuras expansões.  
  ![VPC](https://github.com/user-attachments/assets/aa0728eb-19d5-47b4-875b-24cad890cf3f)

### 2️⃣ Configuração do Security Group  
- Defini regras no **Security Group** para permitir acesso via **SSH** (porta 22) e tráfego **HTTP** (porta 80).  
  ![Configuração do Security Group](https://github.com/user-attachments/assets/4c3c3a66-3ecd-4c27-ab93-d4fe84a7f5de)

### 3️⃣ Criação da Instância EC2  
- Configurei uma instância EC2 na AWS com as seguintes configurações:
  - **Tags:**  
    ![Tags da Instância](https://github.com/user-attachments/assets/8efe5b90-2694-4bb4-900f-bb3373605f55)
  - **Escolha da AMI:**  
    - Utilizei a AMI **Ubuntu**.  
    ![AMI Ubuntu](https://github.com/user-attachments/assets/fe2b718f-2ed1-4003-b833-2bd31e19bb81)
  - **Configuração da VPC e IP Público:**  
    - Selecionei a VPC e habilitei o IP público.  
    ![Configuração da VPC e IP Público](https://github.com/user-attachments/assets/2a910dff-8626-4625-82be-1a4c2291ebb8)
  - **Criação da Chave SSH:**  
    - Gerei uma chave para acessar a instância via SSH pelo **WSL Ubuntu**.
  - **Associação do Security Group:**  
    - Vinculei o Security Group à instância criado anteriormente.  
    ![WhatsApp Image 2025-03-26 at 17 06 43](https://github.com/user-attachments/assets/1a3c649e-bddd-4ca7-9529-7042570c8649)


---

## 🌐 Etapa 2: Configuração do Servidor Web

### 1️⃣ Atualização do Sistema  
```bash
sudo apt-get update
sudo apt-get upgrade
```

### 2️⃣ Instalação e Configuração do Nginx  
```bash
sudo apt-get install nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```
- Verifiquei a instalação acessando: `/var/www/html/index.nginx-debian.html`  
  ![inst_debian11_nginx_1-1-624x191](https://github.com/user-attachments/assets/b3bf26f8-75ce-4096-a2df-99c0f26ac16d)

### 3️⃣ Edição da Página HTML Padrão  
```bash
cd /var/www/html
sudo vi index.nginx-debian.html
```

---

## 📡 Etapa 3: Script de Monitoramento + Webhook

- Criei um **script** para verificar se o site está disponível a cada **1 minuto**. Se houver falhas, uma **notificação será enviada via Telegram**.

### 1️⃣ Criação do Script  
```bash
cd /usr/local/bin
sudo vi monitor_nginx.sh
```

### 2️⃣ Função para Envio de Mensagem no Telegram  
```bash
#!/bin/bash

# Token do Bot do Telegram e chat ID
BOT_TOKEN="id do bot"
CHAT_ID="id do chat"

# Função para enviar mensagem para o Telegram
send_telegram_message() {
    local message=$1
    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
        -d chat_id="$CHAT_ID" \
        -d text="$message"
}
```

### 3️⃣ Verificação do Status do Nginx  
```bash
# Verificar se o Nginx está ativo
if ! systemctl is-active --quiet nginx; then
    send_telegram_message "❌ Nginx não está rodando!"
    exit 1
fi
```

### 4️⃣ Monitoramento de Erros no Log  
```bash
# Local do arquivo error.log do Nginx
error_log="/var/log/nginx/error.log"

# Verificar erros recentes
recent_errors=$(tail -n 20 "$error_log" | grep -i "error")

if [[ -n "$recent_errors" ]]; then
    message="🚨 Erros encontrados no log:\n$recent_errors"
    send_telegram_message "$message"
    exit 1
fi
```

### 5️⃣ Monitoramento de Acessos  
```bash
# Local do arquivo access.log do Nginx
access_log="/var/log/nginx/access.log"

# Verificar acessos no último minuto
recent_access=$(tail -n 50 "$access_log" | grep -i "GET")

if [[ -z "$recent_access" ]]; then
    echo "❗ Nenhum acesso recente detectado."
else
    echo "🔹 Acessos recentes detectados no Nginx."
fi
```

### 6️⃣ Criação de um Arquivo de Log  
```bash
cd /var/log
sudo cat monitor.log
```

### 7️⃣ Agendamento com Crontab  
```bash
crontab -e
* * * * * /usr/local/bin/monitor_nginx.sh >> /var/log/log_web.log 2>&1
sudo systemctl start cron
sudo systemctl enable cron
```

---

## 🛠️ Etapa 4: Testes e Documentação  

- Para validar o script, **parei o serviço do Nginx**:  
  ```bash
  sudo systemctl stop nginx
  ```
- O alerta foi enviado com sucesso:  
  ![WhatsApp Image 2025-03-26 at 21 19 31](https://github.com/user-attachments/assets/5acd66a4-b574-41ed-bc2a-e0250d9d1823)

---

## ✅ Conclusão  

Este projeto demonstra como **automatizar o monitoramento de um servidor web** utilizando **Linux, AWS e Telegram Webhook**. Com essa configuração, conseguimos garantir que qualquer falha no servidor **seja rapidamente detectada** e que um alerta seja **imediatamente enviado**.  

Esse processo pode ser expandido para **outras aplicações** e **diferentes serviços de alerta**, proporcionando um **monitoramento eficiente** e **proativo** para ambientes de produção.  

🚀 **Próximos passos? Implementar melhorias, como métricas mais avançadas e integração com Grafana!**  
