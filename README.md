# 🚀 Projeto Terraform com AWS ECS Fargate

Este projeto provisiona uma infraestrutura na AWS utilizando Terraform, com foco em execução de containers via **ECS Fargate**. Também está integrado ao **GitHub Actions** para realizar o build e deploy automático da aplicação.

---

## 🧱 Recursos Criados

- **VPC** com duas subnets públicas (em zonas de disponibilidade diferentes)
- **Internet Gateway** e **Tabela de Rotas**
- **Security Group** permitindo tráfego nas portas `443` e `8080`
- **Repositório ECR** para armazenar imagens Docker
- **Cluster ECS (Fargate)** para orquestração dos containers
- **Task Definition** com container rodando na porta `8080`
- **Serviço ECS** com deploy automático via pipeline CI/CD
- **Arquivo td.json** modelo base do Task Definition, utilizado no GitHub Actions para registrar novas definições de tarefa a cada deploy com a imagem atualizada

---

## ⚙️ Pré-requisitos

- Conta AWS com permissões adequadas (IAM)
- Chaves de acesso configuradas (`AWS_ACCESS_KEY_ID` e `AWS_SECRET_ACCESS_KEY`)
- Terraform instalado (`>=1.0.0`)
- Docker instalado
- GitHub Secrets configurados no repositório:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`

---

## ✅ Como usar

### 1. Inicialize o Terraform

```bash
  terraform init
```

### 2. Faça o *plan* da infraestrutura

```bash
  terraform plan
```

### 3. Provisione os recursos

```bash
  terraform apply -auto-approve
```

### 4. Realize o deploy (CI/CD)

O deploy da aplicação é feito automaticamente ao dar **push na branch `main`**. O GitHub Actions cuidará de:

- Build da imagem Docker
- Push para o Amazon ECR
- Atualização da Task Definition
- Deploy no ECS

### 5. Destruir a infra

```bash
  terraform destroy -auto-approve
```