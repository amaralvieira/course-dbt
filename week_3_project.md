# Week 3 Project

### Q1: What is our overall conversion rate?

_Conversion rate is defined as the # of unique sessions with a purchase event / total number of unique sessions._

> A: 62.46%
>
> ```sql
> with page_views as (
> 
>     select * from dev_db.dbt_amaralvieira.fct_page_views
> 
> ),
> 
> sessions_agg as (
> 
>     select
>          session_guid,
>          max(checkout) as checkout
> 
>     from page_views
>     group by session_guid
> ),
> 
> final as (
> 
>     select round(avg(checkout) * 100, 2) as overall_conversion_rate
>       from sessions_agg
> 
> )
> 
> select * from final
> ```
>
> |overall_conversion_rate|
> |:-|
> |62.46|


### Q2: What is our conversion rate by product?

_Conversion rate by product is defined as the # of unique sessions with a purchase event of that product / total number of unique sessions that viewed that product._

> ```sql
> with sessions_agg as (
> 
>     select * from dev_db.dbt_amaralvieira.fct_page_views
> 
> ),
> 
> products as (
> 
>     select * from dev_db.dbt_amaralvieira.dim_products
> 
> ),
> 
> conversion_rates as (
> 
>     select
>          product_guid,
>          round(avg(checkout) * 100, 2) as conversion_rate
>     from sessions_agg
>     group by product_guid
> 
> ),
> 
> final as (
> 
>     select
>         products.name as product_name,
>         conversion_rates.conversion_rate
>     from
>         conversion_rates
>     inner join products
>             on conversion_rates.product_guid = products.product_guid
>     order by conversion_rates.conversion_rate desc
> )
> 
> select * from final
> ```
>
> |PRODUCT_NAME|CONVERSION_RATE|
> |:-|:-|
> |String of pearls|60.94|
> |Arrow Head|55.56|
> |Cactus|54.55|
> |ZZ Plant|53.97|
> |Bamboo|53.73|
> |Rubber Plant|51.85|
> |Monstera|51.02|
> |Calathea Makoyana|50.94|
> |Fiddle Leaf Fig|50|
> |Majesty Palm|49.25|
> |Aloe Vera|49.23|
> |Devil's Ivy|48.89|
> |Philodendron|48.39|
> |Jade Plant|47.83|
> |Pilea Peperomioides|47.46|
> |Spider Plant|47.46|
> |Dragon Tree|46.77|
> |Money Tree|46.43|
> |Orchid|45.33|
> |Bird of Paradise|45|
> |Ficus|42.65|
> |Birds Nest Fern|42.31|
> |Pink Anthurium|41.89|
> |Boston Fern|41.27|
> |Alocasia Polly|41.18|
> |Peace Lily|40.91|
> |Ponytail Palm|40|
> |Snake Plant|39.73|
> |Angel Wings Begonia|39.34|

### Q3: Which orders changed from week 2 to week 3?
> A: `'29d20dcd-d0c4-4bca-a52d-fc9363b5d7c6'`, `'c0873253-7827-4831-aa92-19c38372e58d'`, `'e2729b7d-e313-4a6f-9444-f7f65ae8db9a'`
>
> ```sql
> with orders as (
>
>    select * from dev_db.dbt_amaralvieira.orders_snapshot
>
>),
>
>final as (
>
>    select order_id
>      from orders
>    where dbt_valid_to between '2023-01-24' and '2023-01-31'
>
>)
>
>select * from final
> ```
> |order_id|
> |:-|
> |29d20dcd-d0c4-4bca-a52d-fc9363b5d7c6|
> |c0873253-7827-4831-aa92-19c38372e58d|
> |e2729b7d-e313-4a6f-9444-f7f65ae8db9a|