# Teste DevOps

### Objetivo
Mostrar sua maturidade como Analista DevOps em aspectos como desenvolvimento e deploy de aplicações.

### O que:
Seu projeto deve possuir uma aplicação, a documentação e uma pipeline de CI/CD. 

**Aplicação**  
Criar uma API de lista de tarefas (To Do List). O usuário deve poder:
 - Adicionar um item a lista;
 - Editar um item da lista;
 - Marcar um item como feito;
 - Remover um item da lista;
 - Filtrar por: mostrar todos, apenas marcados como feito e apenas não marcados como feito.

- [**pasta app/**](app)

**Documentação**  
Uma boa documentação deve descrever todos os passos necessários para colocar a aplicação em produção, ou seja, em um estado em que a aplicação esteja gerando valor para o cliente.
Além disso, e não menos importante, a documentação também deve descrever todos os passos necessários para que outros desenvolvedores sejam capazes de subir o ambiente em modo de desenvolvimento.

- **Estão nos README.md**

**Pipeline**  
Criar uma pipeline de CI/CD para possibilitar o deploy contínuo da aplicação em produção. A pipeline deve conter no mínimo os stages de:
 - Build;
 - Testes;
 - Deploy.

- [**pasta app/Jenkinsfile**](app/Jenkinsfile)

### Como:
Faça um pull request para este repositório com o seu código.

### Observações:
 - **Aplicação:** Podem ser utilizadas as linguagens: Python, PHP ou Javascript;
 - **Pipeline:** Utilizar uma das seguintes plataformas para criar a pipeline: Travis, Jenkins, CircleCI ou GitlabCI;
 - **Deploy:** É necessário utilizar Docker.

- [**pasta infra**](infra)
