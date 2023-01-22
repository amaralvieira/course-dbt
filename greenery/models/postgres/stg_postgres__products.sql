with source as (

    select * from {{ source('postgres', 'products') }}

),

renamed as (

    select
        product_id as product_guid,
        name,
        price,
        inventory

    from source

)

select * from renamed
