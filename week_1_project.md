# Week 1 Project

### Q: How many users do we have?
> A: 130 users
>
> ```sql
> select count(*) as active_users
>  from dev_db.dbt_amaralvieira.stg_postgres__users
> ```
> |active_users|
> |:-|
> |130|

### Q: On average, how many orders do we receive per hour?
> A: 7.52 orders per hour, on average.
>
> ```sql
> with cte_hourly as 
> (
>     select trunc(created_at, 'hour') as created_at_hour,
>            count(*) as num_orders 
>       from dev_db.dbt_amaralvieira.stg_postgres__orders
>      group by 1
> ),
> cte_final as
> (
>     select round(avg(num_orders),2) as avg_orders_per_hour
>     from cte_hourly
> )
> select * from cte_final
> ```
> |avg_orders_per_hour|
> |:-|
> |7.52|

### Q: On average, how long does an order take from being placed to being delivered?
> A: For the orders with a registered delivery, the average is 3.9 days. There is a high number of orders without delivery time, though. At the time of the last registered delivery, those orders average a total of 7.3 days without update. Should they be pending deliveries, this would bring the total average to 4.4 days to deliver (and counting).
>
> ```sql
> with cte_raw as 
> (
>     select created_at,
>            delivered_at,
>            max(delivered_at) over ()  as last_delivery
>       from dev_db.dbt_amaralvieira.stg_postgres__orders
> ),
> cte_diff as
> (
>     select trunc(created_at, 'DD') as created_at,
>            case when delivered_at is not null
>                 then datediff(day,created_at, delivered_at) 
>             end as days_to_deliver,
>            case when delivered_at is null
>                 then datediff(day,created_at, last_delivery) 
>             end as days_pending_delivery
>       from cte_raw
> ),
> cte_final as
> (
>     select round(avg(days_to_deliver),1) as avg_days_to_deliver,
>            round(avg(days_pending_delivery),1) as > avg_days_pending_delivery,
>            round((sum(days_to_deliver)+sum(days_pending_delivery))
>             / count(*),1) as global_avg
>     from cte_diff  
> )
> select * from cte_final
> ```
> |avg_days_to_deliver|avg_days_pending_delivery|global_avg|
> |:-|:-|:-|
> |3.9|7.3|4.4|


### Q: How many users have only made one purchase? Two purchases? Three+ purchases?
> A: 25 users placed only 1 order and 28 have placed exactly 2 orders. The remanining 71 users have placed 3 or more orders.
>
> ```sql
>with cte_stg as (
>     select
>          user_id,
>          count(distinct order_id) as num_orders,
>          count(distinct user_id) over () as total_users
>     from dev_db.dbt_amaralvieira.stg_postgres__orders
>     group by 1 ),
>     cte_final as
>(
>     select
>          case when num_orders < 3
>               then cast(num_orders as string)
>               else '3+'
>          end num_orders,
>          count(*) as cnt_users,
>          CONCAT(round(count(*) * 100 / max(total_users),0), '%') as pct_users
>     from cte_stg
>     group by 1
>     order by 1 asc
>)
>select * from cte_final
> ````
> |NUM_ORDERS|CNT_USERS|PCT_USERS|
> |:-|:-|:-|
> |1 |25|20%|
> |2 |28|23%|
> |3+|71|57%|



### Q: On average, how many unique sessions do we have per hour?
A: On average we have 12.5 sessions per hour.

_As the events table has every shipment (`event_type = 'package_shipped'`) associated with the original session id, this is an event we can exclude, as it shouldn't relate to website traffic._

> ```sql
> with cte_ref as (
> 
>         select session_id,
>                created_at
>           from dev_db.dbt_amaralvieira.stg_postgres__events
>          where event_type != 'package_shipped'
> 
>     ),
>     cte_sessions as (
> 
>         select distinct session_id,
>                trunc(created_at,'hour') as created_at_hour
>           from cte_ref
>     ),
>     cte_hours as (
>         select created_at_hour,
>                count(*) as cnt_sessions
>          from cte_sessions
>         group by created_at_hour
>     ),
>     cte_final as (
>         
>         select round(avg(cnt_sessions),1) as session_hourly_avg
>           from cte_hours
> 
>     )
>     select * from cte_final
> ```
> |session_hourly_avg|
> |:-|
> |12.5|
