{{ config(materialized='view') }}

SELECT
  campaign_id,
  name,
  start_date,
  end_date,
  duration_days,
  total_budget
FROM raw.campaigns
