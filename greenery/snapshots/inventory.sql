{% snapshot inventory_snapshot %}

{{
  config(
    target_database = target.database,
    target_schema = target.schema,
    strategy='check',
    unique_key='product_guid',
    check_cols=['inventory'],
   )
}}

with products as (

    select * from {{ source('postgres', 'products') }}

)

    select
        product_guid,
        inventory
    from products

{% endsnapshot %}