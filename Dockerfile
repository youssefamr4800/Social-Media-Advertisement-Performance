FROM apache/airflow:3.0.0

USER root

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    gcc \
    python3-dev \
    libpq-dev \
    && apt-get clean

USER airflow

# Install dbt
RUN pip install --no-cache-dir dbt-postgres==1.7.0

# (Optional but recommended)
RUN pip install --no-cache-dir psycopg2-binary