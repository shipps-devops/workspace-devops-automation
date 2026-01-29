# 🛡️ Java API DevSecOps Pipeline

![Java](https://img.shields.io/badge/Java-17-orange)
![Spring Boot](https://img.shields.io/badge/Spring_Boot-3-green)
![Azure](https://img.shields.io/badge/Azure-Cloud-blue)
![Docker](https://img.shields.io/badge/Docker-Container-blue)
![Security](https://img.shields.io/badge/Trivy-Vulnerability_Scan-red)
![CI/CD](https://img.shields.io/badge/GitHub_Actions-Automated-2088FF)

A fully automated **DevSecOps pipeline** for a Java API. This project demonstrates a production-grade workflow focusing on immutable infrastructure, automated security scanning, and seamless cloud integration using **GitHub Actions** and **Azure Container Registry (ACR)**.

## 📋 Project Highlights

The goal of this repository is to establish a "Shift-Left" security approach, ensuring that every code change is verified and secure before it ever reaches a deployment environment.

### 🏗 Architecture & Pipeline Flow

The pipeline defined in `.github/workflows/01-build-container.yaml` executes the following automated stages:

1.  **Build & Quality Assurance:**
    * Sets up a clean Java 17 environment.
    * Compiles the application with Maven.
    * **Unit Testing:** Executes `mvn test` to validate code integrity.
2.  **Optimized Containerization:**
    * Builds a Docker image using **Multi-stage builds**. This ensures the final image contains *only* the compiled artifact and the JRE, significantly reducing the attack surface and image size.
3.  **DevSecOps (Vulnerability Scanning):**
    * **Trivy Integration:** Before pushing to the cloud, the image is scanned for High/Critical CVEs (Common Vulnerabilities and Exposures).
    * *Policy:* The pipeline is configured to **fail automatically** if a critical vulnerability is detected, preventing insecure code from shipping.
4.  **Cloud Delivery:**
    * Secure authentication via Azure Service Principal.
    * Artifact versioning using GitHub SHA (Immutable tags).
    * Push to **Azure Container Registry (ACR)**, ready for deployment (AKS/App Service).

## 🛠 Tech Stack

* **Application:** Java 17 / Spring Boot
* **Build Automation:** Maven
* **Container Engine:** Docker (Alpine based for minimal footprint)
* **Cloud Provider:** Microsoft Azure
* **Artifact Registry:** Azure ACR
* **Security Scanner:** Aqua Security Trivy
* **CI/CD Orchestrator:** GitHub Actions

## ⚙️ Configuration & Secrets

To replicate this secure pipeline, configure the following Github Secrets:

| Secret Name | Description |
| :--- | :--- |
| `AZURE_CREDENTIALS` | The JSON output from Azure Service Principal (RBAC contributor). |
| `AZURE_REGISTRY_NAME` | The unique name of your Azure Container Registry. |
| `RESOURCE_GROUP` | The target Azure Resource Group. |

## 🚀 How to Run Locally

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/your-username/workspace-devops-automation.git](https://github.com/your-username/workspace-devops-automation.git)
    cd workspace-devops-automation
    ```

2.  **Build the Docker image:**
    ```bash
    docker build -t java-api:local .
    ```

3.  **Run the container:**
    ```bash
    docker run -p 8080:8080 java-api:local
    ```