{{ config(materialized='table') }}

SELECT
  campaign_id,
  name,
  start_date,
  end_date,
  duration_days,
  total_budget
FROM {{ ref('stg_campaigns') }}
