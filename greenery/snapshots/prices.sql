{% snapshot prices_snapshot %}

{{
  config(
    target_database = target.database,
    target_schema = target.schema,
    strategy='check',
    unique_key='product_guid',
    check_cols=['price'],
   )
}}

with products as (

    select * from {{ source('postgres', 'products') }}

)

    select
        product_guid,
        price
    from products

{% endsnapshot %}