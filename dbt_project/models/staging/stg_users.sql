{{ config(materialized='view') }}

SELECT DISTINCT ON (user_id)
  user_id,
  user_gender,
  user_age,
  age_group,
  country,
  location,
  interests
FROM raw.users
ORDER BY user_id, 1        -- adjust the tie‑breaker column if available