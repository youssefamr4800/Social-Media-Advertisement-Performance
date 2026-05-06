{{ config(
    materialized='table',
    post_hook=[
        "ALTER TABLE {{ this }} ADD CONSTRAINT pk_dim_campaigns PRIMARY KEY (campaign_id)"
    ]
) }}

SELECT
    campaign_id,
    name,
    start_date,
    end_date,
    duration_days,
    total_budget
FROM {{ ref('stg_campaigns') }}