# Ingatlan Marketplace Terraform Infrastruktúra

Ez a projekt egy egyszerű Kubernetes-alapú infrastruktúrát hoz létre az Azure felhőben egy ingatlan-piac platform számára. Az infrastruktúra a következő komponensekből áll:

- Azure AKS (Azure Kubernetes Service) klaszter
- Azure SQL adatbázis
- .NET Backend alkalmazás
- React Frontend alkalmazás
- Nginx Ingress Gateway a forgalom irányításához

## Előfeltételek

- [Terraform](https://www.terraform.io/downloads.html) (min. 1.0.0 verzió)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Azure előfizetés és megfelelő jogosultságok

## Projekt struktúra

```
.
├── main.tf                    # Terraform root konfig
├── variables.tf               # Root változók
├── terraform.tfvars           # Input változók
├── output.tf
├── app/                       # Kubernetes deployment manifests
│   ├── backend-deployment.yaml
│   ├── backend-service.yaml
│   ├── frontend-deployment.yaml
│   ├── frontend-service.yaml
│   └── db-connection-secret.yaml
├── modules/
│   ├── aks/                   # AKS klaszter modul
│   │   ├── main.tf
│   │   └── variables.tf 
│   ├── sql/                   # Azure SQL adatbázis modul
│   │   ├── main.tf            # SQL szerver és DB konfig
│   │   └── variables.tf
│   └── nginx-ingress/         # Nginx Ingress gateway module
│       ├── main.tf
│       └── variables.tf
├── app/                       # Kubernetes deployment manifests
│   ├── backend.yaml
│   ├── frontend.yaml
│   └── db-secret.yaml
├── pipeline/
|   ├── backend/
|   |   └── Dockerfile         # .NET Backend Dockerfile
|   ├── frontend/
    |   └── Dockerfile         # React Frontend Dockerfile
|   └── azure-pipelines.yml    # Azure DevOps CI/CD pipeline
```

## Használati útmutató

### 1. Távoli state tárhely létrehozása

Mielőtt futtatná a Terraform kódot, létre kell hozni egy Azure Storage fiókot a távoli state tárolásához:

```bash
# Jelentkezzen be az Azure-ba
az login

# Hozzon létre egy erőforráscsoportot a state-hez
az group create --name terraform-state-rg --location westeurope

# Hozzon létre egy storage fiókot
az storage account create --resource-group terraform-state-rg --name realestateterraformstate --sku Standard_LRS --encryption-services blob

# Hozzon létre egy container-t
az storage container create --name tfstate --account-name realestateterraformstate
```

### 2. Változók konfigurálása

A `terraform.tfvars` file szolgál a változók értékeinek megadására. Minden változó érték terraform szabályok alapján felüldefiniálható itt az adott modul variables.tf filejában lévő default értékhez képest (amennyiben van ilyen).

### 3. Terraform inicializálása és futtatása

```bash
# Inicializálja a Terraform-ot
terraform init

# Ellenőrizze a végrehajtandó változtatásokat
terraform plan

# Alkalmazza a konfigurációt
terraform apply
```

### 4. Hozzáférés a klaszterhez

A Terraform futtatása után a következő paranccsal konfigurálhatja a kubectl-t a klaszterhez való hozzáféréshez:

```bash
# Töltse le a konfigurációt
az aks get-credentials --resource-group realestate-marketplace-rg --name realestate-marketplace-aks
```

## Elérhetőség

Az alkalmazás a következő URL-en lesz elérhető a telepítés után:

```
http://<nginx_gateway_external_ip>/
```

Az API végpontok a következő URL-en lesznek elérhetők:

```
http://<nginx_gateway_external_ip>/api/
```


## Bővítési lehetőségek

- Secret kezelés Hashicorp Vault vagy Azure KeyVault használatával
- Több node hozzáadása a skálázáshoz
- Monitoring és naplózás hozzáadása
- SSL/TLS konfiguráció az HTTPS-hez
- Service mesh implementálása
- Horizontális Pod Autoscaler (HPA) konfigurálása


## Megjegyzés:

- Teszt alkalmazás build és deploy nem volt futtatva. (Csak leszettem egy GitHub publikus repo-ból)
- Az Azure pipeline variables szakaszban lévő értékek és az azure-credentials csoport definiálható illetve biztonságosan tárolható a projekt beállításai alatt a "Library" -ben. Íly módon az Azure-hoz való kapcsolódáshoz szükséges hitelesítési adatokat, például:

    * Service Principal ID
    * Service Principal titkos kulcsa
    * Tenant ID
    * Subscription ID
    * Egyéb Azure-specifikus beállítások
