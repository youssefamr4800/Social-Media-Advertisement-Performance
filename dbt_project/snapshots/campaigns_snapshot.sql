{% snapshot campaigns_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='campaign_id',
      strategy='check',
      check_cols=[
        'name',
        'start_date',
        'end_date',
        'duration_days',
        'total_budget'
      ]
    )
}}

SELECT *
FROM {{ source('raw', 'campaigns') }}

{% endsnapshot %}