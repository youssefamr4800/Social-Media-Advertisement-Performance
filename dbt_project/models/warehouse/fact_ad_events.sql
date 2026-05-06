{{ config(
    materialized='table',
    post_hook=[
        "ALTER TABLE {{ this }} ADD CONSTRAINT pk_fact_events PRIMARY KEY (event_id)",
        "ALTER TABLE {{ this }} ADD CONSTRAINT fk_fact_ad FOREIGN KEY (ad_id) REFERENCES {{ ref('dim_ads') }} (ad_id)",
        "ALTER TABLE {{ this }} ADD CONSTRAINT fk_fact_campaign FOREIGN KEY (campaign_id) REFERENCES {{ ref('dim_campaigns') }} (campaign_id)",
        "ALTER TABLE {{ this }} ADD CONSTRAINT fk_fact_user FOREIGN KEY (user_id) REFERENCES {{ ref('dim_users') }} (user_id)"
    ]
) }}

SELECT
    e.event_id,
    e.timestamp,
    e.day_of_week,
    e.time_of_day,
    e.event_type,
    e.ad_id,
    a.campaign_id,   -- from join
    e.user_id
FROM {{ ref('stg_ad_events') }} e
LEFT JOIN {{ ref('dim_ads') }} a ON e.ad_id = a.ad_id