{% snapshot users_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='user_id',
      strategy='check',
      check_cols=[
        'user_gender',
        'user_age',
        'age_group',
        'country',
        'location',
        'interests'
      ]
    )
}}

SELECT *
FROM {{ source('raw', 'users') }}

{% endsnapshot %}