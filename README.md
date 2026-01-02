flowchart LR
  %% Nimbus Infrastructure — Azure DevOps Project Architecture

  Dev[Developer\n(local machine)] -->|Push code| GH[(GitHub Repo\nNimbus-infra)]

  %% =========================
  %% CI/CD (GitHub Actions)
  %% =========================
  subgraph CICD[GitHub Actions — CI/CD Pipeline\n.github/workflows/build.yaml]
    GA1[Build Docker image\n(Dockerfile / .dockerignore)]
    GA2[Authenticate to Azure\n(Azure login / service principal)]
    GA3[Push image to ACR\n(tag + push)]
    GA4[Deploy to AKS\n(kubectl apply -f k8s/)]
    GA1 --> GA2 --> GA3 --> GA4
  end

  GH -->|Trigger workflow on push| CICD

  %% =========================
  %% Azure (Provisioned by Terraform)
  %% =========================
  subgraph AZ[Azure Subscription]
    RG[Resource Group]

    subgraph TFSTATE[Terraform Remote State]
      SA[(Storage Account)]
      BLOB[(Blob Container\nTerraform state)]
      SA --> BLOB
    end

    KV[(Azure Key Vault\nsecrets/keys)]
    ACR[(Azure Container Registry)]
    AKS[(AKS Cluster)]

    RG --> SA
    RG --> KV
    RG --> ACR
    RG --> AKS

    RBAC[RBAC / Identity\nAKS ↔ ACR & Key Vault access]
    AKS --- RBAC
    ACR --- RBAC
    KV --- RBAC

    %% Workloads on AKS
    subgraph K8S[Kubernetes Workloads\n/k8s]
      DEP[Deployment\nNimbus app pods]
      SVC[Service\nExpose app internally/externally]
      DEP --> SVC
    end

    AKS --> K8S
  end

  %% IaC path (manual, as per your deploy steps)
  Dev -->|terraform init/plan/apply\n(terraform/ *.tf)| RG
  Dev -->|Store state| TFSTATE

  %% Delivery path
  GA3 -->|Image stored| ACR
  AKS -->|Pull image| ACR
  GA4 -->|Apply manifests| AKS

  %% =========================
  %% Observability (in AKS)
  %% =========================
  subgraph OBS[Monitoring & Observability\n/monitoring/setup-monitoring.sh]
    PROM[Prometheus\n(metrics scrape)]
    GRAF[Grafana\n(dashboards)]
    PROM --> GRAF
  end

  AKS --> OBS
  DEP -->|App/cluster metrics| PROM

  %% =========================
  %% End Users
  %% =========================
  Users[Users / Browser] -->|HTTP(S) to service endpoint| SVC

🌩️ Nimbus Infrastructure – End-to-End Cloud DevOps Project (My Full Build)
<p align="center"> A complete cloud-native DevOps pipeline that I designed and implemented — from Infrastructure as Code to containerization, Kubernetes deployment, automated CI/CD, and real-time monitoring. </p> <p align="center"> 🔗 <strong>Repository:</strong> <a href="https://github.com/seyiabello/Nimbus-infra">github.com/seyiabello/Nimbus-infra</a> </p>
🚀 What This Project Is

This project demonstrates my ability to build a full production-grade DevOps environment on Azure using:

Terraform

Docker

Azure Kubernetes Service (AKS)

GitHub Actions CI/CD

Prometheus & Grafana

It mirrors the real workflows used by Cloud Engineers, DevOps Engineers, and SRE teams.

🧱 What I Built — End-to-End Breakdown
1. Infrastructure with Terraform (IaC)

I wrote a fully modular Terraform codebase to deploy the entire Azure environment.

✔ Resource Group
✔ Azure Kubernetes Service (AKS)
✔ Azure Container Registry (ACR)
✔ Azure Key Vault
✔ Storage Account + Blob Container (Terraform Remote State)
✔ RBAC (AKS → ACR & AKV Access)

➡️ Terraform folder:
🔗 <a href="https://github.com/seyiabello/Nimbus-infra/tree/master/terraform">/terraform</a>

Key files inside:

<a href="https://github.com/seyiabello/Nimbus-infra/blob/master/terraform/provider.tf">provider.tf</a>

<a href="https://github.com/seyiabello/Nimbus-infra/blob/master/terraform/AKS.tf">AKS.tf</a>

<a href="https://github.com/seyiabello/Nimbus-infra/blob/master/terraform/ACR.tf">ACR.tf</a>

<a href="https://github.com/seyiabello/Nimbus-infra/blob/master/terraform/Keyvault.tf">Keyvault.tf</a>

<a href="https://github.com/seyiabello/Nimbus-infra/blob/master/terraform/storage.tf">storage.tf</a>

<a href="https://github.com/seyiabello/Nimbus-infra/blob/master/terraform/rbac.tf">rbac.tf</a>

<a href="https://github.com/seyiabello/Nimbus-infra/blob/master/terraform/backend.tf">backend.tf</a>

<a href="https://github.com/seyiabello/Nimbus-infra/blob/master/terraform/variables.tf">variables.tf</a>

<a href="https://github.com/seyiabello/Nimbus-infra/blob/master/terraform/output.tf">output.tf</a>

2. Containerization with Docker

I dockerized the Nimbus application by writing a production-ready Dockerfile and pushing images to ACR.

➡️ Key files:

<a href="https://github.com/seyiabello/Nimbus-infra/blob/master/dockerfile">dockerfile</a>

<a href="https://github.com/seyiabello/Nimbus-infra/blob/master/.dockerignore">.dockerignore</a>

Application source:

<a href="https://github.com/seyiabello/Nimbus-infra/blob/master/app.js">app.js</a>

<a href="https://github.com/seyiabello/Nimbus-infra/tree/master/nimbus-site">/nimbus-site (HTML, CSS, NGINX config)</a>

3. Kubernetes Deployment to AKS

I wrote Kubernetes manifests to deploy and expose the application on AKS.

➡️ Kubernetes folder:
🔗 <a href="https://github.com/seyiabello/Nimbus-infra/tree/master/k8s">/k8s</a>

Files:

<a href="https://github.com/seyiabello/Nimbus-infra/blob/master/k8s/deployment.yaml">deployment.yaml</a>

<a href="https://github.com/seyiabello/Nimbus-infra/blob/master/k8s/service.yaml">service.yaml</a>

4. Automated CI/CD Pipeline (GitHub Actions)

I built a full pipeline that automates:

Docker build

ACR push

AKS deployment

Workflow file:
🔗 <a href="https://github.com/seyiabello/Nimbus-infra/blob/master/.github/workflows/build.yaml">.github/workflows/build.yaml</a>

5. Monitoring with Prometheus & Grafana

I deployed Prometheus and Grafana into AKS for real-time monitoring.

➡️ Monitoring folder:
🔗 <a href="https://github.com/seyiabello/Nimbus-infra/tree/master/monitoring">/monitoring</a>

Setup script:

<a href="https://github.com/seyiabello/Nimbus-infra/blob/master/monitoring/setup-monitoring.sh">setup-monitoring.sh</a>

📂 Repository Structure
NIMBUS-INFRA
│
├── .github/workflows/
│   └── build.yaml
│
├── k8s/
│   ├── deployment.yaml
│   └── service.yaml
│
├── monitoring/
│   └── setup-monitoring.sh
│
├── nimbus-site/
│   ├── index.html
│   ├── styles.css
│   └── nginx.conf
│
├── app.js
├── dockerfile
├── .dockerignore
│
├── terraform/
│   ├── *.tf (AKS, ACR, Key Vault, Storage, RBAC, Variables, Backend)
│
└── README.md

🔧 How to Deploy Everything
1️⃣ Deploy the Infrastructure
cd terraform
terraform init
terraform plan
terraform apply -auto-approve

2️⃣ Build and Push Docker Image
docker build -t nimbusapp:v1 .
az acr login --name <yourACR>
docker tag nimbusapp:v1 <yourACR>.azurecr.io/nimbusapp:v1
docker push <yourACR>.azurecr.io/nimbusapp:v1

3️⃣ Deploy to AKS
kubectl apply -f k8s/

4️⃣ Install Monitoring Stack
chmod +x monitoring/setup-monitoring.sh
./monitoring/setup-monitoring.sh

🎯 What This Project Demonstrates About My Skills

✔ Cloud Infrastructure Engineering
✔ Terraform IaC (modular, production-level structure)
✔ Docker containerization
✔ Kubernetes deployment
✔ GitHub Actions CI/CD
✔ Azure AAD authentication + RBAC
✔ Monitoring & Observability tooling
✔ Secure secret management using Key Vault
✔ Clean code structure and real DevOps workflows

This project shows my ability to design, automate, and deploy scalable cloud-native systems end-to-end.
