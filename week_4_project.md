# Week 4 Project

### Q1: Which orders changed from week 3 to week 4?
> A: `'0e9b8ee9-ad0a-42f4-a778-e1dd3e6f6c51'`, `'841074bf-571a-43a6-963c-ba7cbdb26c85'`, `'df91aa85-bfc7-4c31-93ef-4cee8d00a343'`
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
>    where dbt_valid_to between '2023-01-30' and '2023-02-05'
>
>)
>
>select * from final
> ```
> |order_id|
> |:-|
> |0e9b8ee9-ad0a-42f4-a778-e1dd3e6f6c51|
> |841074bf-571a-43a6-963c-ba7cbdb26c85|
> |df91aa85-bfc7-4c31-93ef-4cee8d00a343|

### Q2: How are our users moving through the product funnel? Which steps in the funnel have largest drop off points?

[Product funnel in Sigma](https://app.sigmacomputing.com/corise-dbt/workbook/workbook-2UyO1g8HdIn9eoRgWBBoVD)

### Q3A. dbt next steps for you
If your organization is thinking about using dbt, how would you pitch the value of dbt/analytics engineering to a decision maker at your organization?

> I'm planning to deliver a short presentation on dbt to other data practicioners, followed by a hand-on session.
I believe it is worth it to highlight how dbt allows us to apply software development best practices to data modeling and analysis using SQL, and how you can monitor data quality in your database and throughout your data pipelines. Most importantly, I intend to showcase how me and my team will be using dbt and the value we'll be getting out of it.
