with orders as (
    
    select * from {{ ref('stg_sample_data__orders') }}

),

line_items as (

    select * from {{ ref('stg_sample_data__line_items') }}

),

final as (
    select 


        orders.order_key,
        orders.customer_key,
        line_items.part_key,
        line_items.supplier_key,
        orders.order_date,
        orders.status_code as order_status_code,
        
        
        
        
        line_items.line_number,
        line_items.status_code as order_item_status_code,
        line_items.ship_date,
        line_items.commit_date,
        line_items.receipt_date,
        line_items.ship_mode,
        line_items.extended_price,
        line_items.quantity,
        
        -- extended_price is actually the line item total,
        -- so we back out the extended price per item
        (line_items.extended_price/nullif(line_items.quantity, 0)) as base_price,
        line_items.discount_percentage,
        (base_price * (1 - line_items.discount_percentage)) as discounted_price,

        line_items.extended_price as gross_item_sales_amount,
        (line_items.extended_price * (1 - line_items.discount_percentage)) as discounted_item_sales_amount,
        -- We model discounts as negative amounts
        (-1 * line_items.extended_price * line_items.discount_percentage)as item_discount_amount,
        line_items.tax_rate,
        ((gross_item_sales_amount + item_discount_amount) * line_items.tax_rate) as item_tax_amount,
        (
            gross_item_sales_amount + 
            item_discount_amount + 
            item_tax_amount
        ) as net_item_sales_amount

    from
        orders
    inner join line_items
            on orders.order_key = line_items.order_key
    order by
        orders.order_date

)

select *
from final