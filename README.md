# Prueba Técnica: Business Intelligence & Analytics Engineer

Este repositorio contiene la solución completa al reto técnico de e-commerce, integrando un pipeline de transformación de datos con **dbt**, orquestación con **Airflow** y almacenamiento en **Google BigQuery**.

------------------------------------------------------------------------------------------

## Arquitectura del Proyecto

El proyecto transforma datos crudos (capa `raw`) con problemas de calidad (nulos, duplicados e inconsistencias) en modelos analíticos listos para el consumo de negocio.

*   **Data Warehouse:** Google BigQuery.
*   **Transformación:** dbt (Data Build Tool).
*   **Orquestación:** Apache Airflow.
*   **Configuración de Servicio** Docker & Docker Compose.

------------------------------------------------------------------------------------------

## Configuración e Instalación

### 1. Requisitos Previos
*   Docker y Docker Compose instalados.
*   Cuenta de Google Cloud con un proyecto activo.
*   Archivo de Service Account `gcp-creds.json` en la raíz (protegido por `.gitignore`).

### 2. Variables de Entorno
Crea un archivo `.env` en la raíz del proyecto con el contenido del archivo adjunto:

# ID del proyecto en Google Cloud (Obligatorio)
GCP_PROJECT_ID=stable-argon-178322
# Región de tus datos en BigQuery (ej. US o southamerica-east1)
GCP_LOCATION=US
# ID del dataset donde dbt creará las tablas (por defecto suele ser 'raw' o 'analytics')
GCP_DATASET_RAW=raw
# Esto ayuda a Airflow a identificar el usuario en sistemas Linux/Mac
AIRFLOW_UID=50000

### 3. Usuario gc
Crea un archivo llamado .env en la raiz del proyecto con el contenido del archivo adjunto:

id: a534d13c-17e2-49d5-ad5e-1d4a4908b800

### 3. Profiles 
Crea un archivo llamado profiles.yml en la raiz con el contenido del archivo adjunto:

### 4. Credenciales
Crea un archivo llamado gcp-creds.json con el contenido del archivo adjunto


# Construir e iniciar los contenedores
Dentro de la carpeta raiz con el servicio de docker inicializado, ejecutar el siguiente comando

docker-compose build --no-cache

docker-compose up -d

#### Acceso a Airflow

#Una vez inicializado airflow se generara un archivo en la carpeta raiz llamado 
standalone_admin_password.txt que contrendra la contraseña de airflow, en caso de no generarla usar el comando siguiente para obtener la contraseña y usuar los siguientes datos para acceder via web

docker exec -it biproject_orchestrator cat /opt/airflow/standalone_admin_password.txt

#Datos de Acceso:

USUARIO: admin
http://localhost:8080/


