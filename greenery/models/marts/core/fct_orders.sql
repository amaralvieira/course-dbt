{{
  config( materialized = 'table' )
}}

with orders as (

    select * from {{ ref("stg_postgres__orders") }}

),

users as (

    select * from {{ ref("dim_users") }}

),

addresses as (

    select * from {{ ref("dim_addresses") }}

),

final as (

    select
            orders.order_guid,
            orders.user_guid,
            users.zipcode as user__zipcode,
            users.state as user__state,
            orders.address_guid,
            addresses.zipcode as address__zip_code,
            addresses.state as address__state,
            orders.created_at_utc,
            orders.order_cost,
            orders.shipping_cost,
            orders.order_total
    from orders
    inner join users
            on orders.user_guid = users.user_guid
    inner join addresses
            on orders.address_guid = addresses.address_guid

)

select * from final