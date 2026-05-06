{{ config(materialized='table') }}

SELECT
  user_id,
  user_gender,
  user_age,
  age_group,
  country,
  location,
  interests
FROM {{ ref('stg_users') }}
