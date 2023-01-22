{{
  config( materialized = 'table' )
}}

with users as (

    select * from {{ ref("stg_postgres__users") }}

),

addresses as (

    select * from {{ ref("stg_postgres__addresses") }}

),

final as (
    select
        users.user_guid,
        addresses.zipcode,
        addresses.state

    from users
    inner join addresses
    on users.address_guid = addresses.address_guid

)

select * from final