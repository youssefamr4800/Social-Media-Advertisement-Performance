-- Fail if any user_id in fact_ad_events does not exist in dim_users
SELECT f.user_id
FROM {{ ref('fact_ad_events') }} f
LEFT JOIN {{ ref('dim_users') }} d ON f.user_id = d.user_id
WHERE d.user_id IS NULL