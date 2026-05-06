{{
    config(
        materialized='table'
    )
}}

SELECT
    DATE(e.timestamp) AS event_date,
    e.ad_id,
    a.campaign_id,
    e.event_type,
    COUNT(*) AS event_count,
    COUNT(DISTINCT e.user_id) AS unique_users
FROM {{ ref('fact_ad_events') }} e
LEFT JOIN {{ ref('dim_ads') }} a ON e.ad_id = a.ad_id
GROUP BY 1, 2, 3, 4