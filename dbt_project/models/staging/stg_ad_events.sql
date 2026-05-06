{{ config(materialized='view') }}

SELECT
  event_id,
  ad_id,
  user_id,
  timestamp,
  day_of_week,
  time_of_day,
  event_type
FROM raw.ad_events
