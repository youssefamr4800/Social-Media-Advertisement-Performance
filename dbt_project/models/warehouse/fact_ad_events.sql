{{ config(materialized='table') }}

SELECT
  e.event_id,
  e.timestamp,
  e.day_of_week,
  e.time_of_day,
  e.event_type,
  e.ad_id,
  a.campaign_id,
  e.user_id
FROM {{ ref('stg_ad_events') }} e
LEFT JOIN {{ ref('dim_ads') }} a ON e.ad_id = a.ad_id
