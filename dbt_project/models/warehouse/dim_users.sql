{{ config(
    materialized='table',
    post_hook=[
        "ALTER TABLE {{ this }} ADD CONSTRAINT pk_dim_users PRIMARY KEY (user_id)"
    ]
) }}

SELECT
    user_id,
    user_gender,
    user_age,
    age_group,
    country,
    location,
    interests
FROM {{ ref('stg_users') }}