with events as (

    select *
    from {{ ref("stg_postgres__events") }}
    where event_type != 'package_shipped'

),

final as (

    select session_guid,
           min(created_at_utc) as session_start_at_utc,
           max(created_at_utc) as session_end_at_utc,
           datediff(
               'minute', session_start_at_utc, session_end_at_utc
           ) as session_duration_minutes,
           max(case event_type when 'checkout' then 1 else 0 end) as checkout

    from events
    group by session_guid

)

select * from final