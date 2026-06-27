{{ config(materialized='view') }}

SELECT DISTINCT
  event_id,
  ad_id,
  user_id,
  timestamp,
  day_of_week,
  time_of_day,
  event_type
FROM {{ source('raw', 'ad_events') }}
