-- Fail if any ad_id in fact_ad_events does not exist in dim_ads
SELECT f.ad_id
FROM {{ ref('fact_ad_events') }} f
LEFT JOIN {{ ref('dim_ads') }} d ON f.ad_id = d.ad_id
WHERE d.ad_id IS NULL