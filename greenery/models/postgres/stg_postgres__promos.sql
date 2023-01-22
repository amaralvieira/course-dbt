with source as (

    select * from {{ source('postgres', 'promos') }}

),

renamed as (

    select
        lower(promo_id) as promo_type, {# -- noqa: L034 #}
        discount,
        status

    from source

)

select * from renamed
