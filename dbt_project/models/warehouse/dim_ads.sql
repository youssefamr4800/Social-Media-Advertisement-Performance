{{ config(
    materialized='table',
    post_hook=[
        "ALTER TABLE {{ this }} ADD CONSTRAINT pk_dim_ads PRIMARY KEY (ad_id)"
    ]
) }}

SELECT
    ad_id,
    campaign_id,
    ad_platform,
    ad_type,
    target_gender,
    target_age_group,
    target_interests
FROM {{ ref('stg_ads') }}