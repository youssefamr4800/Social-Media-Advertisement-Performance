-- Fail if any campaign_id is duplicated
SELECT
    campaign_id,
    COUNT(*) AS cnt
FROM {{ ref('dim_campaigns') }}
GROUP BY campaign_id
HAVING COUNT(*) > 1