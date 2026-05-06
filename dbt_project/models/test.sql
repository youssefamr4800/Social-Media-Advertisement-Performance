{{ config(materialized='view') }}


SELECT * FROM raw.ads;