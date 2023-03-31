{{
    config(
        materialized = 'table',
        tags=['finance']
    )
}}

with orders as (
    
    select * from {{ ref('stg_sample_data__orders') }} 

),
order_items as (
    
    select * from {{ ref('int_order_items') }}

),
order_items_summary as (

    select 
        order_key,
        sum(gross_item_sales_amount) as gross_item_sales_amount,
        sum(item_discount_amount) as item_discount_amount,
        sum(item_tax_amount) as item_tax_amount,
        sum(net_item_sales_amount) as net_item_sales_amount
    from order_items
    group by
        1
),
final as (

    select 

        orders.order_key, 
        orders.order_date,
        orders.customer_key,
        orders.status_code,
        orders.priority_code,

                
        1 as order_count,                
        order_items_summary.gross_item_sales_amount,
        order_items_summary.item_discount_amount,
        order_items_summary.item_tax_amount,
        order_items_summary.net_item_sales_amount
    from
        orders
        inner join order_items_summary
            on orders.order_key = order_items_summary.order_key
)
select 
    *
from
    final

order by
    order_date