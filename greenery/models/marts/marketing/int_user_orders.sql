with orders as (

    select * from {{ ref("stg_postgres__orders") }}

),

final as (

    select
         user_guid,
         min(trunc(created_at_utc, 'DD')) as first_order_date,
         max(trunc(created_at_utc, 'DD')) as last_order_date,
         count(*) as orders_count,
         case when orders_count > 1 then 1 else 0 end as is_user_repeat,
         sum(order_cost) as orders_total_amount,
         avg(order_cost) as orders_avg_amount

    from orders
    group by user_guid
)

select * from final
