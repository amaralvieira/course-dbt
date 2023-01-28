with addresses as (

    select * from {{ ref('stg_postgres__addresses') }}

),

final as (

    select
        address_guid,
        zipcode,
        state

    from addresses
)

select * from final