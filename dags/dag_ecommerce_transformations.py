from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta

# Rutas validadas en el contenedor
DBT_PROJECT_DIR = "/opt/airflow/dbt-project" 
DBT_PROFILES_DIR = "/opt/airflow"            

default_args = {
    'owner': 'data_engineering',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    'dag_ecommerce_dbt_transformation',
    default_args=default_args,
    description='Pipeline optimizado: Freshness > Staging > Test > Marts > Test',
    schedule_interval='0 2 * * *', 
    start_date=datetime(2026, 4, 1),
    catchup=False,
    tags=['bi', 'dbt', 'ecommerce', 'production'],
) as dag:

    # 1. VERIFICACIÓN DE FRESCURA (Gatekeeper 1)
    # Si los datos en BigQuery son más viejos de lo definido en tu source.yml, el DAG se detiene.
    check_freshness = BashOperator(
        task_id='dbt_source_freshness',
        bash_command=f'cd {DBT_PROJECT_DIR} && dbt source freshness --profiles-dir {DBT_PROFILES_DIR}'
    )

    # 2. RUN & TEST STAGING (Gatekeeper 2)
    # Limpiamos los datos crudos y validamos inmediatamente NULOS y UNICIDAD.
    # Si el test falla, no se gasta procesamiento en modelos pesados de Marts.
    run_test_staging = BashOperator(
        task_id='dbt_run_test_staging',
        bash_command=(
            f'cd {DBT_PROJECT_DIR} && '
            f'dbt run --select staging --profiles-dir {DBT_PROFILES_DIR} && '
            f'dbt test --select staging --profiles-dir {DBT_PROFILES_DIR}'
        )
    )

    # 3. RUN TRANSFORMATION (Core Logic)
    # Ejecuta modelos Intermediate y Marts. dbt maneja las dependencias internas.
    run_marts = BashOperator(
        task_id='dbt_run_marts',
        bash_command=f'cd {DBT_PROJECT_DIR} && dbt run --select intermediate marts --profiles-dir {DBT_PROFILES_DIR}'
    )

    # 4. TEST BUSINESS LOGIC (Final Guard)
    # Ejecuta tus tests singulares (como assert_revenue_is_positive.sql) y validaciones de Marts.
    test_marts = BashOperator(
        task_id='dbt_test_business_logic',
        bash_command=f'cd {DBT_PROJECT_DIR} && dbt test --select marts --profiles-dir {DBT_PROFILES_DIR}'
    )

    # 5. DOCUMENTACIÓN (Metadata)
    # Genera el catálogo y el manifest.json final para el Lineage.
    generate_docs = BashOperator(
        task_id='dbt_generate_docs',
        bash_command=f'cd {DBT_PROJECT_DIR} && dbt docs generate --profiles-dir {DBT_PROFILES_DIR}'
    )

    # Orden de ejecución lógica
    check_freshness >> run_test_staging >> run_marts >> test_marts >> generate_docs