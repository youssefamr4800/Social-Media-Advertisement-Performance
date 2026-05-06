-- Fail if any user_id appears more than once in dim_users
SELECT
    user_id,
    COUNT(*) AS cnt
FROM {{ ref('dim_users') }}
GROUP BY user_id
HAVING COUNT(*) > 1