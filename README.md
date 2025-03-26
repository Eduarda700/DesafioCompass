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

   **Fiz a instalação do Nginx, iniciei e testei para verificar se a instalação foi sucessivel:**
   
   ```bash
   sudo apt-get install ngnix
   sudo systemctl start ngnix
   sudo systemctl enable ngnix 
    /var/www/html/index.nginx-debian.html
   
![inst_debian11_nginx_1-1-624x191](https://github.com/user-attachments/assets/b3bf26f8-75ce-4096-a2df-99c0f26ac16d)

- Editei a pagina HTML padrão para ema com a descrição do projeto
- 
  cd /var/wwww/html/index.nginx-debian.html
  sudo vi /index.nginx-debian.html


### Etapa 3: Script de Monitoramento + Webhook


- Criar um script que verifique a cada 1 minutos se o site está disponível, ou seja se
ele está rodando normalmente, caso a aplicação não esteja funcionando, o script
deve envio uma notificação via algum desses canais, Discord, Telegram ou Slack,
informando da indisponibilidade do serviço.
- O script deve armazenar os logs da sua execução em um local no servidor, por
exemplo: /var/log/meu_script.log

### Etapa 4: Testes e Documentação

- Testar a implementação.
- Fazer a documentação explicando o processo de instalação do Linux no Github.
- Cuidado com dados que podem comprometer a segurança.

### Desafios Bônus:

- A configuração da EC2 com o Nginx, página html e scripts de monitoramento são
injetados automaticamente via User Data, para inicializarem junto com a máquina.
- Criar um arquivo Cloudformation que inicialize todo o ambiente.
