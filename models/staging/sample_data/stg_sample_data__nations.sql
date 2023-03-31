with 

source as (

  select * from {{ source('snowflake_sample_data', 'nation') }}

),

transformed as (

  select 
    n_nationkey as nation_key,
    n_regionkey as region_key
    -- add nation name here


  from source

)

select * from transformed
