with source as (

    select *
    from {{ source('postgres', 'addresses') }}

),

final as (

    select address_id,
           address,
           zipcode,
           state,
           country
      from source

)

select * from final