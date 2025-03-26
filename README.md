# Server-Monitoramento-Web

Esse é um projeto de linux e aws pratico, o objetivo é criar uma instancia na aws e programa-la para monitorar a disponabilidade de um site HTML no sever Nginx 

## Etapa 1: Configuração do Ambiente

Criei da VPC com duas sub-redes públicas para acesso externo e duas sub-redes privadas para futuras expansões.

![VPC](https://github.com/user-attachments/assets/aa0728eb-19d5-47b4-875b-24cad890cf3f)

Criei uma instância EC2 na AWS, e fiz as seguintes configurações:

- Escolhi uma AMI, dentro as opções sugeridas eu escolhi AMI Ubuntu
- Instalei na sub-rede pública criada anteriormente.
- Criei uma chave para conectar a instancia com o seu terminal via SSH, no meu caso realizei o projeto usando WSL ubuntu.
- Associei um Security Group criado anteriormente, que permite tráfego HTTP (porta 80) e SSH (porta 22, opcional).

## Etapa 2: Configuração do Servidor Web

- Subir um servidor Nginx na EC2;
- Criar uma página simples em html que será exibida dentro do servidor Nginx.


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
