# Server-Monitoramento-Web

Esse é um projeto prático para Linux e AWS. O objetivo é criar uma instância na AWS e programá-la para monitorar a disponibilidade de um site HTML no servidor Nginx.

## Etapa 1: Configuração do Ambiente

1. **Criação da VPC**
   - Criei uma VPC com duas sub-redes públicas para acesso externo e duas sub-redes privadas para futuras expansões.
   
   ![VPC](https://github.com/user-attachments/assets/aa0728eb-19d5-47b4-875b-24cad890cf3f)

2. **Configuração do Security Group**
   - Criei um Security Group para permitir acesso SSH e configurei para permitir tráfego HTTP (porta 80) e SSH (porta 22).

   ![Configuração do Security Group](https://github.com/user-attachments/assets/4c3c3a66-3ecd-4c27-ab93-d4fe84a7f5de)

3. **Criação da Instância EC2**
   - Criei uma instância EC2 na AWS com as seguintes configurações:
   
   - **Tags:**
     ![Tags da Instância](https://github.com/user-attachments/assets/8efe5b90-2694-4bb4-900f-bb3373605f55)
   
   - **Escolha da AMI:**
     - Escolhi a AMI Ubuntu.
     ![AMI Ubuntu](https://github.com/user-attachments/assets/fe2b718f-2ed1-4003-b833-2bd31e19bb81)
   
   - **Configuração da VPC e IP Público:**
     - Selecionei a VPC criada anteriormente, instalei na sub-rede pública e ativei a opção para obter um IP público.
     ![Configuração da VPC e IP Público](https://github.com/user-attachments/assets/2a910dff-8626-4625-82be-1a4c2291ebb8)

   - **Criação da Chave SSH:**
     - Criei uma chave para conectar à instância via SSH. No meu caso, utilizei o WSL Ubuntu.
   
   - **Associação do Security Group:**
     - Associei o Security Group criado anteriormente à instância.
     ![Security Group](https://github.com/user-attachments/assets/42e962da-12cd-4e8c-9e53-a7db3c22eb16)

Após finalizar as configurações de ambiente, segui para o próximo passo.

## Etapa 2: Configuração do Servidor Web

1. **Atualização do Sistema**  
   - Realizei a busca por atualizações e as apliquei, seguindo boas práticas:

   ```bash
   sudo apt-get update
   sudo apt-get upgrade
   ```

2. **Instalação e Configuração do Nginx**  
   - Fiz a instalação do Nginx, iniciei e testei para verificar se a instalação foi bem-sucedida:

   ```bash
   sudo apt-get install nginx
   sudo systemctl start nginx
   sudo systemctl enable nginx
   ```

   - Verifiquei a instalação acessando o arquivo padrão:  
     `/var/www/html/index.nginx-debian.html`

   ![inst_debian11_nginx_1-1-624x191](https://github.com/user-attachments/assets/b3bf26f8-75ce-4096-a2df-99c0f26ac16d)

3. **Edição da Página HTML Padrão**  
   - Editei a página HTML padrão para incluir uma descrição do projeto:

   ```bash
   cd /var/www/html
   sudo vi index.nginx-debian.html
   ```


### Etapa 3: Script de Monitoramento + Webhook

- Criei um script que verifica a cada 1 minuto se o site está disponível, ou seja, se ele está rodando normalmente. Caso a aplicação não esteja funcionando, o script enviará uma notificação via Telegram informando a indisponibilidade do serviço.

   ```bash
   cd ~
   cd /usr/local/bin
   sudo vi monitor_nginx.sh
   ```

- Programei uma função para enviar mensagens usando os tokens informados:

   ```bash
   #!/bin/bash

   # Token do Bot do Telegram e chat ID
   BOT_TOKEN="id do chat bot do telegram"
   CHAT_ID="id do chat do telegram"

   # Função para enviar a mensagem para o Telegram
   send_telegram_message() {
       local message=$1
       curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
           -d chat_id="$CHAT_ID" \
           -d text="$message"
   }
   ```

- Também programei para verificar se o Nginx está ativo. Caso não esteja, a função de envio de mensagem será acionada:

   ```bash
   # Verificar se o Nginx está ativo
   if ! systemctl is-active --quiet nginx; then
       send_telegram_message "❌ Nginx não está rodando!"
       exit 1
   fi
   ```

- Programei para localizar o arquivo de log de erros do Nginx e verificar os erros mais recentes. Se encontrados, a função de envio de mensagem será executada:

   ```bash
   # Local do arquivo error.log do Nginx
   error_log="/var/log/nginx/error.log"

   # Verificar se houve erros recentes no log
   recent_errors=$(tail -n 20 "$error_log" | grep -i "error")

   if [[ -n "$recent_errors" ]]; then
       message="🚨 Erros encontrados no log de erros do Nginx:\n$recent_errors"
       send_telegram_message "$message"
       exit 1
   fi
   ```

- Programei para localizar o arquivo de log de acessos do Nginx. Se nenhum acesso for encontrado ou se houver acessos recentes, ambos serão registrados:

   ```bash
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
   ```

- Criei um arquivo de log no servidor local para o script armazenar logs da sua execução:

   ```bash
   cd /var/log
   sudo cat monitor.log
   ```

- Configurei o cron para que o script `monitor_nginx.sh` seja executado a cada 1 minuto e registre sua execução no arquivo de log anteriormente criado:

   ```bash
   crontab -e
   
   * * * * * /usr/local/bin/monitor_nginx.sh >> /var/log/log_web.log 2>&1
   ```




### Etapa 4: Testes e Documentação

- Testar a implementação.
- Fazer a documentação explicando o processo de instalação do Linux no Github.
- Cuidado com dados que podem comprometer a segurança.

### Desafios Bônus:

- A configuração da EC2 com o Nginx, página html e scripts de monitoramento são
injetados automaticamente via User Data, para inicializarem junto com a máquina.
- Criar um arquivo Cloudformation que inicialize todo o ambiente.
