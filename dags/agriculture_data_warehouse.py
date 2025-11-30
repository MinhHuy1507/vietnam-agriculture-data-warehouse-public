import os

# airflow
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from datetime import datetime, timedelta

# cosmos
from cosmos import DbtTaskGroup, ProjectConfig, ProfileConfig, ExecutionConfig, RenderConfig, TestBehavior, LoadMode
from cosmos.profiles import PostgresUserPasswordProfileMapping

DBT_PROJECT_PATH = "/opt/airflow/dbt"

profile_config = ProfileConfig(
    profile_name="vietnam_agriculture_dwh",
    target_name="dev",
    profile_mapping=PostgresUserPasswordProfileMapping(
        conn_id="agri_dwh_conn",
        profile_args={"schema": "public"},
    ),
)

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2025, 1, 1),
    'retries': 3,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    dag_id='vietnam_agri_data_warehouse',
    description='A DAG for Vietnam Agricultural Data Warehouse',
    default_args=default_args,
    schedule='@daily',
    catchup=False,
    template_searchpath=['/opt/airflow'],
    tags=['agriculture', 'data_warehouse']
) as dag:
    # ==============================
    # Stage 1: Create Raw Schema and Ingest Data
    # ==============================
    # Task: Create raw schema and tables
    create_raw_schemas_and_tables = SQLExecuteQueryOperator(
        task_id='create_raw_schemas_and_tables',
        conn_id='agri_dwh_conn',
        sql="sql/raw/ddl_raw.sql",
    )

    # Ingestion Tasks
    ingest_data_to_raw_schema = SQLExecuteQueryOperator(
        task_id='ingest_data_to_raw_schema',
        conn_id='agri_dwh_conn',
        sql="sql/raw/dml_raw.sql",
    )

    # =================================
    # Stage 2: DBT Transformations
    # =================================
    dbt_transform_group = DbtTaskGroup(
        group_id="dbt_transformation",
        project_config=ProjectConfig(DBT_PROJECT_PATH),
        profile_config=profile_config,
        execution_config=ExecutionConfig(
            dbt_executable_path="dbt"
        ),
        render_config=RenderConfig(
            test_behavior=TestBehavior.AFTER_EACH, 
            
            # Hiển thị Document
            # load_method=LoadMode.DBT_LS, 
            
            # 3. Chọn lọc: Nếu chỉ muốn hiện các folder chính (tránh hiện file rác)
            # select=["path:models"] 
        ),
        operator_args={
            "install_deps": True,
            "full_refresh": False
        }
    )

    # =================================
    # DAG Dependencies
    # =================================
    create_raw_schemas_and_tables >> ingest_data_to_raw_schema >> dbt_transform_group
