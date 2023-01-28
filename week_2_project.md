# Week 2 Project

### Q: What is our user repeat rate?

Repeat Rate = Users who purchased 2 or more times / users who purchased

> A: 80%
>
> ```sql
> with orders as (
> 
>      select * from {{ ref("stg_postgres__orders") }}
> 
> ),
> 
> users as (
> 
>     select
>         user_guid,
>         count(*) as orders_count
>     from orders
>     group by user_guid
> 
> ),
> 
> final as (
> 
>     select
>         count(*) as user_count,
>         sum(case when orders_count > 1 then 1 end) as user_repeat_count,
>         round(div0(user_repeat_count, user_count) * 100) as user_repeat_rate
> 
>     from users
> 
> )
> 
> select * from final
> ```
> |user_count|user_repeat_count|user_repeat_rate
> |:-|:-|:-|
> |124|99|80|

### Q: Which orders changed from week 1 to week 2? 

> A: `'265f9aae-561a-4232-a78a-7052466e46b7'`, `'e42ba9a9-986a-4f00-8dd2-5cf8462c74ea'`, `'b4eec587-6bca-4b2a-b3d3-ef2db72c4a4f'`
>
> ```sql
> with orders as (
> 
>     select * from {{ ref("orders_snapshot") }}
> 
> ),
> 
> final as (
> 
>     select order_id
>       from orders
>     where dbt_valid_to is not null
> 
> )
> 
> select * from final
> ```
> |order_id|
> |:-|
> |265f9aae-561a-4232-a78a-7052466e46b7|
> |e42ba9a9-986a-4f00-8dd2-5cf8462c74ea|
> |b4eec587-6bca-4b2a-b3d3-ef2db72c4a4f|