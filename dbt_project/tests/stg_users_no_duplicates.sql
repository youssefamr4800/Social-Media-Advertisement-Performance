-- Ensure that the source view (after deduplication) still has unique user_id
SELECT
    user_id,
    COUNT(*) AS cnt
FROM {{ ref('stg_users') }}
GROUP BY user_id
HAVING COUNT(*) > 1