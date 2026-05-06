-- Fail if any event_id is NULL in the staging view
SELECT *
FROM {{ ref('stg_ad_events') }}
WHERE event_id IS NULL