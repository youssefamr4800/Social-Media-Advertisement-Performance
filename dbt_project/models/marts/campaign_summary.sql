{{
    config(
        materialized='table'
    )
}}

SELECT
    c.campaign_id,
    c.name,
    c.start_date,
    c.end_date,
    c.total_budget,
    COUNT(DISTINCT f.event_id) AS total_events,
    COUNT(DISTINCT f.user_id) AS reach_users,
    COUNT(DISTINCT CASE WHEN f.event_type = 'click' THEN f.event_id END) AS clicks,
    COUNT(DISTINCT CASE WHEN f.event_type = 'conversion' THEN f.event_id END) AS conversions
FROM {{ ref('dim_campaigns') }} c
LEFT JOIN {{ ref('fact_ad_events') }} f ON c.campaign_id = f.campaign_id
GROUP BY 1, 2, 3, 4, 5