{{
  config( materialized = 'table' )
}}

with events as (

    select *
    from {{ ref("stg_postgres__events") }}
    where event_type != 'package_shipped'

),

session_stats as (
    
    select * from {{ ref("int_session_stats") }}

),

final as (

    select
        events.session_guid,
        events.product_guid,
        session_stats.session_duration_minutes,
        session_stats.checkout,
        sum(
            case events.event_type when 'page_view' then 1 else 0 end
        ) as page_view,
        sum(
            case events.event_type when 'add_to_cart' then 1 else 0 end
        ) as add_to_cart

    from events
    inner join session_stats
            on events.session_guid = session_stats.session_guid 
    group by events.session_guid,
             events.product_guid,
             session_stats.session_duration_minutes,
             session_stats.checkout
)

select * from final
where page_view > 1
      or add_to_cart > 1
