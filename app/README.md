ToDo API
========

API de lista de tarefas.  

### requisitos
- git
- docker
- docker-compose

### Ambiente Desenvolvimento

***todos os comandos devem ser neste diretório da aplicação.**

- Utilizar `docker-compose` para criar o ambiente:  
```sh
docker-compose up
```
você pode usar o argumento `-d` para deixar executando em background.  

- executar `composer` instalação das dependencias:  
```sh
bin/exec composer install
```

**depois do ambiente e dependencias já é possivel acessar:** 
[http://localhost/](http://localhost/)  


- para executar qualquer comando dentro do ambiente php:  
```sh
bin/exec seu-comando
```

- para executar os testes:
```sh
bin/exec bin/test
```

**banco de dados:**  
o banco em dev pode ser acessado pelo adminer: [http://localhost:8080/](http://localhost:8080/)  
o usuário e senha estão no `docker-compose.yml`  

### Deploy para produção

**simples:**  
- basta adicionar as alterações na branch `master` que o CI/CD faz o build e deploy da applicação.  

**por baixo dos panos:**  
- build da aplicação com o Dockerfile
- criado imagem docker da aplicação (pacote de entrega)
- atualiza a imagem no registry para publicação e download
- cria/atualiza serviço em execução no **docker swarm**


### Rotas e métodos API
**subpath:** /v1  

- **GET /list** listagem de todos TODOs.
- **GET /list?status=done** listagem TODOs completados.
- **GET /list?status=pending** listagem TODOs pendentes.
- **GET /list/{id}** vizualiza TODOs com id={id}

- **POST /list** criaçao TODO. parametros: title, description
- **POST /list/{id}/done** marca TODO id={id} como feito
- **POST /list/{id}/pending** marca TODO id={id} como pendente

- **PUT /list/{id}** atualiza TODO. parametros: title, description, status

- **DELETE /list/{id}** deleta TODO.  

**exemplo:** [http://localhost/v1/list](http://localhost/v1/list)  
