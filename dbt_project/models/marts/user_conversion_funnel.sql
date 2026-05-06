{{
    config(
        materialized='table'
    )
}}

WITH user_events AS (
    SELECT
        user_id,
        event_type,
        COUNT(*) AS event_count
    FROM {{ ref('fact_ad_events') }}
    GROUP BY 1, 2
)
SELECT
    u.user_id,
    u.age_group,
    u.country,
    COALESCE(MAX(CASE WHEN ue.event_type = 'impression' THEN ue.event_count END), 0) AS impressions,
    COALESCE(MAX(CASE WHEN ue.event_type = 'click' THEN ue.event_count END), 0) AS clicks,
    COALESCE(MAX(CASE WHEN ue.event_type = 'conversion' THEN ue.event_count END), 0) AS conversions
FROM {{ ref('dim_users') }} u
LEFT JOIN user_events ue ON u.user_id = ue.user_id
GROUP BY 1, 2, 3