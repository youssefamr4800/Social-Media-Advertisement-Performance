{{
    config(
        materialized='table'
    )
}}

SELECT
    ad_id,
    SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END) AS impressions,
    SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) AS clicks,
    SUM(CASE WHEN event_type = 'conversion' THEN 1 ELSE 0 END) AS conversions
FROM {{ ref('fact_ad_events') }}
GROUP BY ad_id