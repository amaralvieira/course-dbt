{% set event_types = ["page_view", "add_to_cart"] %}

with events as (

    select *
    from {{ ref("stg_postgres__events") }}
    where event_type != 'package_shipped'
      and product_guid is not null

),

session_stats as (

    select * from {{ ref("int_session_stats") }}

),

events_pivot as (

    select
        session_guid,
        product_guid,
        user_guid,
        {% for event_type in event_types %}
        sum(
            case when event_type = '{{ event_type }}'
                    then 1
                 else 0
             end
            ) as {{ event_type }}{{ "," if not loop.last else "" }}
        {% endfor %}
   from events
   group by session_guid,
            product_guid,
            user_guid
),

final as (
    select
        events_pivot.session_guid,
        events_pivot.product_guid,
        events_pivot.user_guid,
        trunc(session_stats.session_start_at_utc, 'DD') as session_date,
        session_stats.session_duration_minutes,
        {%- for event_type in event_types %}
        events_pivot.{{ event_type }},
        {%- endfor %}
        least(session_stats.checkout, events_pivot.add_to_cart) as checkout
   from events_pivot
   inner join session_stats
           on events_pivot.session_guid = session_stats.session_guid

)

select * from final