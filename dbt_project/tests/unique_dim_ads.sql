-- Fail if any ad_id is duplicated
SELECT
    ad_id,
    COUNT(*) AS cnt
FROM {{ ref('dim_ads') }}
GROUP BY ad_id
HAVING COUNT(*) > 1