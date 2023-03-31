with 

source as (

  select * from {{ source('snowflake_sample_data', 'orders') }}

),

transformed as (

  select 
    o_orderkey as order_key,
    o_custkey as customer_key,
    o_totalprice as cost,
    o_orderdate as order_date,
    o_orderpriority as priority_code,
    o_orderstatus as status_code


  from source

)

select * from transformed