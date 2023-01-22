{{
  config( materialized = 'table' )
}}

with products as (

    select * from {{ ref("stg_postgres__products") }}

),

final as (

    select
        product_guid,
        name
    from products

)

select * from final