-- Fail if any campaign_id in fact_ad_events does not exist in dim_campaigns
SELECT f.campaign_id
FROM {{ ref('fact_ad_events') }} f
LEFT JOIN {{ ref('dim_campaigns') }} d ON f.campaign_id = d.campaign_id
WHERE d.campaign_id IS NULL