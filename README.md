# Marketing Data Warehouse

An end-to-end data engineering project that ingests advertising data, models it into a star-schema warehouse, and prepares analytics-ready marts for dashboards.

**Pipeline:** CSV files → **NiFi** (ingestion) → **PostgreSQL** (raw) → **dbt** (transform + test) → **Grafana** (visualization), all orchestrated by **Airflow**.

---

## Architecture

```
 data/*.csv ──► Apache NiFi ──► PostgreSQL (raw schema)
                                      │
                                      ▼
                          dbt (seed → snapshot → run → test)
                                      │
                      ┌───────────────┼────────────────┐
                      ▼               ▼                ▼
                staging (views)  warehouse (tables)  marts (tables)
                                      │
                                      ▼
                                   Grafana

              Airflow DAG `marketing_pipeline` orchestrates every step
```

## Tech Stack

| Tool | Version | Role |
|------|---------|------|
| Apache NiFi | 1.23.2 | Loads CSV files into PostgreSQL |
| PostgreSQL | 15 | Data warehouse (`marketing_dw`) |
| Apache Airflow | 3.0.0 | Orchestration |
| dbt (dbt-postgres) | 1.7.0 | Transformations, tests, snapshots |
| Grafana | 10.4.2 | Dashboards |
| Docker Compose | – | Runs everything locally |

## Source Data (`data/`)

| File | Description |
|------|-------------|
| `users.csv` | User demographics (gender, age, country, interests) |
| `ads.csv` | Ad metadata (platform, type, targeting) |
| `campaigns.csv` | Campaign details (dates, duration, budget) |
| `ad_events.csv` | Ad interactions (event type, timestamp, user, ad) |

## Data Model

dbt builds three layers, each in its own schema:

| Layer | Schema | Materialization | Models |
|-------|--------|-----------------|--------|
| Staging | `raw` | view | `stg_users`, `stg_ads`, `stg_campaigns`, `stg_ad_events` (deduplicated source data) |
| Warehouse | `analytics` | table | `dim_users`, `dim_ads`, `dim_campaigns`, `fact_ad_events` (with primary and foreign key constraints) |
| Marts | `marts` | table | `daily_ad_performance`, `campaign_summary`, `ad_events_by_type`, `user_conversion_funnel` |

Additional schemas:
- `reference`: dbt seeds (`country_regions`, `platform_dictionary`, `event_type_dictionary`)
- `snapshots`: history tracking (SCD Type 2) for `users` and `campaigns`

**Star schema:** `fact_ad_events` links to `dim_users`, `dim_ads`, and `dim_campaigns`.

## Data Quality

- **Source tests** (`sources.yml`): `not_null` and `unique` on key columns.
- **Custom tests** (`dbt_project/tests/`): uniqueness of every dimension and the fact table, foreign-key integrity from the fact table to each dimension, and no duplicates or null IDs in staging.

## Orchestration

The Airflow DAG `marketing_pipeline` runs these tasks in order:

```
start_nifi_flow → dbt_seed → dbt_snapshot → dbt_run → dbt_test
```

1. `start_nifi_flow`: starts the NiFi process group through the NiFi REST API.
2. `dbt_seed`: loads the reference CSVs.
3. `dbt_snapshot`: captures changes in users and campaigns.
4. `dbt_run`: builds staging, warehouse, and mart models.
5. `dbt_test`: validates the results.

## Getting Started

### Prerequisites
- Docker and Docker Compose

### Run

```bash
docker compose up -d --build
```

Then:
1. Open **NiFi** and make sure the ingestion flow (CSV → PostgreSQL `raw` schema) exists. Update `process_group_id` in `dags/marketing_pipeline.py` if your flow has a different ID.
2. Open **Airflow**, unpause `marketing_pipeline`, and trigger it.
3. Open **Grafana**, add PostgreSQL as a data source, and build dashboards on the `marts` schema.

### Services and Ports

| Service | URL / Port | Default login |
|---------|-----------|---------------|
| Airflow UI/API | http://localhost:8081 | `airflow` / `airflow` |
| NiFi | http://localhost:8080/nifi | – |
| Grafana | http://localhost:3000 | `admin` / `admin` |
| PostgreSQL (warehouse) | `localhost:5432` | `postgres` / `postgres` |
| PostgreSQL (Airflow metadata) | `localhost:5433` | `airflow` / `airflow` |
| dbt docs (optional) | http://localhost:8082 | – |

> ⚠️ These credentials are for local development only. Change them before any real deployment.

### Useful dbt Commands

Run inside the Airflow container:

```bash
cd /opt/airflow/dbt_project
dbt seed && dbt snapshot && dbt run && dbt test

# Generate and serve documentation
dbt docs generate && dbt docs serve --port 8082 --no-browser
```

## Project Structure

```
.
├── dags/                  # Airflow DAG (marketing_pipeline.py)
├── dbt_project/
│   ├── models/            # staging, warehouse, marts + sources.yml
│   ├── seeds/             # reference CSVs
│   ├── snapshots/         # users and campaigns history
│   ├── tests/             # custom data tests
│   ├── macros/            # generate_schema_name override
│   └── profiles/          # dbt connection profile
├── data/                  # source CSV files
├── drivers/               # PostgreSQL JDBC driver for NiFi
├── config/                # airflow.cfg
├── docker-compose.yml     # all services
└── Dockerfile             # Airflow image with dbt installed
```

## Notes

- The `event_type_dictionary` seed lists `view`, `purchase`, `like`, and `share`, while the marts count `impression`, `click`, and `conversion`. Align these with the real values in `ad_events.csv`.
- The NiFi flow itself is configured in the NiFi UI and is not stored in this repo. Exporting it as a template or flow definition would make the project fully reproducible.
