{{
  config( materialized = 'table' )
}}

with orders as (

    select * from {{ ref("stg_postgres__orders") }}

),

users as (

    select * from {{ ref("dim_users") }}

),


user_orders as (

    select * from {{ ref("int_user_orders") }}

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
            user_orders.is_user_repeat as user__is_user_repeat,
            user_orders.first_order_date as user__first_order_date,
            user_orders.last_order_date as last_order_date,
            user_orders.orders_count as user__orders_count
    from orders
    inner join user_orders
            on orders.user_guid = user_orders.user_guid
    inner join users
            on orders.user_guid = users.user_guid
    inner join addresses
            on orders.address_guid = addresses.address_guid

)

select * from final