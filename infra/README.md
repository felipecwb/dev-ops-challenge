INFRA SetUp
===========

é necessário utilizar `docker` e `docker-machine`.  

**pastas:**  
- **machines/** temos o arquivos para criação dos swarm nodes.
- **stacks/** temos o arquivos de definição das stacks e serviços.

### Machines:

no diretório `machines`.  
você precisa copiar o `.env.example` para `.env` e alterar as variaveis conforme precisar.
e depois executar `bash create.sh`:  
**exemplo:**
```sh
cd machines/
cp .env.example .env
# modifica .env
bash create.sh
```

Depois de um certo tempo verifique se não houve algum erro e se todos os nós que foram criados e configurados corretamente.

para utilizar swarm remoto só usar:
```sh
eval $(docker-machine env $leader_node_name) # exemplo: prod-manager-01
# se conectado poderá utilizar esses comandos:
docker ps
docker node ls
docker stack ls
docker service ls
```

**adicionar node de ci:**
label do node que vai executar o jenkins jobs:
```sh
docker node update --label-add ci=true $leader_node_name # exemplo: prod-worker-02
```

### stacks:

no diretório `stacks`.  
você precisa copiar o `.env.example` para `.env` e alterar as variaveis conforme precisar.
e depois executar `bash deploy.sh all`: para fazer deploy de todas as stack bases.
**exemplo:**
```sh
cd stacks/
cp .env.example .env
# modifica .env
# utilizando o manager
eval $(docker-machine env $leader_node_name) # exemplo: prod-manager-01
bash deploy.sh all
```

Agora só configurar:
- jenkins.$DOMAIN

variaveis no Jenkins: DOMAIN, DOCKER_MANAGER_HOST  
configuração das credenciais: dockerhub
para esse projeto precisei alterar: 'app/Jenkinsfile' no projeto.
