{{ config(materialized='view') }}

SELECT DISTINCT
  campaign_id,
  name,
  start_date,
  end_date,
  duration_days,
  total_budget
FROM {{ source('raw', 'campaigns') }}
