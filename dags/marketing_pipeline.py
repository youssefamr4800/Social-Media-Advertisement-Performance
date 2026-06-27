from airflow.sdk import dag, task
from airflow.operators.bash import BashOperator
import requests

NIFI_URL = "http://nifi:8080/nifi-api"


@dag
def marketing_pipeline():

    @task
    def start_nifi_flow():
        process_group_id = "13b1cb29-019e-1000-0f73-b0d8b4c6688a"
        url = f"{NIFI_URL}/flow/process-groups/{process_group_id}"
        payload = {
            "id": process_group_id,
            "state": "RUNNING"
        }
        response = requests.put(url, json=payload)
        print(response.status_code)
        print(response.text)


    dbt_seed = BashOperator(
        task_id = 'dbt_seed',
        bash_command = 'cd /opt/airflow/dbt_project/ && dbt seed'
    )

    dbt_snapshot = BashOperator(
        task_id = 'dbt_snapshot',
        bash_command = 'cd /opt/airflow/dbt_project/ && dbt snapshot'
    )

    dbt_run = BashOperator(
        task_id = 'dbt_run',
        bash_command = 'cd /opt/airflow/dbt_project/ && dbt run'
    )

    dbt_test = BashOperator(
        task_id = 'dbt_test',
        bash_command = 'cd /opt/airflow/dbt_project/ && dbt test'
    )


    start_nifi_flow() >> dbt_seed >> dbt_snapshot >> dbt_run >> dbt_test

marketing_pipeline()

# cd /opt/airflow/dbt_project/ && dbt docs generate && dbt docs serve --port 8082 --no-browser