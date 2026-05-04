FROM apache/airflow:2.7.2-python3.9

USER root

# Instalamos dependencias del sistema
RUN apt-get update && \
    apt-get install -y git && \
    apt-get clean

# Limpieza profunda de librerías conflictivas antes de instalar las nuevas
RUN rm -rf /home/airflow/.local/lib/python3.9/site-packages/google* && \
    rm -rf /home/airflow/.local/lib/python3.9/site-packages/typing_extensions*

USER airflow

# Instalación limpia y forzada de dbt y Google Cloud
RUN pip install --no-cache-dir --user --force-reinstall \
    typing-extensions==4.12.2 \
    google-auth==2.29.0 \
    dbt-bigquery==1.8.2 \
    google-cloud-bigquery \
    google-cloud-secret-manager