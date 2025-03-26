# Server-Monitoramento-Web

Esse é um projeto de linux e aws pratico, o objetivo é criar uma instancia na aws e programa-la para monitorar a disponabilidade de um site HTML no sever Nginx 

## Etapa 1: Configuração do Ambiente

Criei da VPC com duas sub-redes públicas para acesso externo e duas sub-redes privadas para futuras expansões.

![VPC](https://github.com/user-attachments/assets/aa0728eb-19d5-47b4-875b-24cad890cf3f)

- Criei um Security group para permitir acesso a o SSH, e configurei para permitir tráfego HTTP (porta 80) e SHH (porta 22)

![IMG-20250326-WA0012.jpg](https://github.com/user-attachments/assets/4c3c3a66-3ecd-4c27-ab93-d4fe84a7f5de)


Criei uma instância EC2 na AWS, e fiz as seguintes configurações:

- Adicionei Tags 

![IMG-20250326-WA0014.jpg](https://github.com/user-attachments/assets/8efe5b90-2694-4bb4-900f-bb3373605f55)

- Escolhi uma AMI, dentro as opções sugeridas eu escolhi AMI Ubuntu

![IMG-20250326-WA0010.jpg](https://github.com/user-attachments/assets/fe2b718f-2ed1-4003-b833-2bd31e19bb81)


- Selecionei a VPC selecionada anteriormente, instalei na sub-rede pública criada anteriormente e ativei a opçāo enable para ativar ip publico.

![IMG-20250326-WA0013.jpg](https://github.com/user-attachments/assets/2a910dff-8626-4625-82be-1a4c2291ebb8)

- Criei uma chave para conectar a instancia com o seu terminal via SSH, no meu caso realizei o projeto usando WSL ubuntu.
- Associei um Security Group criado anteriormente.

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
