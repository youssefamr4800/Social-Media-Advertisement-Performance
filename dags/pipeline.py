from airflow.sdk import dag, task
from airflow.operators.bash import BashOperator



@dag
def dbt_pipeline():

    dbt_run = BashOperator(
        task_id = 'dbt_run',
        bash_command = 'cd /opt/airflow/dbt_project/ && dbt run'
    )


    dbt_test = BashOperator(
        task_id = 'dbt_test',
        bash_command = 'cd /opt/airflow/dbt_project/ && dbt test'
    )


    dbt_server = BashOperator(
        task_id = 'dbt_server',
        bash_command = 'cd /opt/airflow/dbt_project/ && dbt docs generate && dbt docs serve --port 8082 --no-browser'
    )

    dbt_run >> dbt_test >> dbt_server

dbt_pipeline()