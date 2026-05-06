-- Fail if any event_id is duplicated in fact_ad_events
SELECT
    event_id,
    COUNT(*) AS cnt
FROM {{ ref('fact_ad_events') }}
GROUP BY event_id
HAVING COUNT(*) > 1