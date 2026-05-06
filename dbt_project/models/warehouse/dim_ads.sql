{{ config(materialized='table') }}

SELECT
  ad_id,
  campaign_id,
  ad_platform,
  ad_type,
  target_gender,
  target_age_group,
  target_interests
FROM {{ ref('stg_ads') }}
