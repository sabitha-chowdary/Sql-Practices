USE sql_practice;

-- Create a basic temporary table for intermediate data
create temporary table temp_sales (
    product_id int,
    quantity_sold int,
    total_value decimal(10,2)
);

-- Insert data into a temporary table
insert into temp_sales (product_id, quantity_sold, total_value)
select product_id, sum(quantity), sum(quantity * unit_price)
from order_details
group by product_id;

-- Join a temp table with a permanent one
select p.product_name, t.quantity_sold, t.total_value
from temp_sales t
join products p on p.product_id = t.product_id;

-- Drop a temp table manually
drop temporary table if exists temp_sales;

-- Create a temporary table using SELECT INTO / INSTEAD
create temporary table temp_high_value_orders as
select order_id, total_amount
from orders
where total_amount > 10000;

-- Reuse temp tables in stored procedures
-- (Temp tables live for the duration of a session or procedure)
delimiter //
create procedure analyze_sales()
begin
  create temporary table temp_category_sales as
  select category_id, sum(quantity * unit_price) as total_sales
  from products p
  join order_details od on p.product_id = od.product_id
  group by category_id;

  select * from temp_category_sales;
end;
//
delimiter ;

-- Add indexes to a temp table
create temporary table temp_indexed_data (
    customer_id int,
    total_spent decimal(10,2),
    index idx_customer_id (customer_id)
);

-- Compare CTE vs temp table for performance
    -- Using EXPLAIN ANALYZE to test both:
    -- CTE:
    with monthly_sales as (
        select month(order_date) as month, sum(total_amount) as total
        from orders
        group by month(order_date)
    )
    select * from monthly_sales;

    -- TEMP TABLE version (might perform better with reuse):
    create temporary table temp_monthly_sales as
    select month(order_date) as month, sum(total_amount) as total
    from orders
    group by month(order_date);

    select * from temp_monthly_sales;

-- Use temp table to hold aggregated data
create temporary table temp_customer_totals as
select customer_id, sum(total_amount) as total_spent
from orders
group by customer_id;

-- Write a script that auto-creates and cleans up a temp table
drop temporary table if exists temp_script;
create temporary table temp_script (
    id int,
    value varchar(50)
);
insert into temp_script values (1, 'test'), (2, 'more');
select * from temp_script;
drop temporary table temp_script;

-- Use global temp tables (if supported)
-- MySQL does NOT support GLOBAL TEMPORARY TABLES like Oracle.
-- You must simulate this with regular tables and session columns.

-- Use temp tables inside transactions
    start transaction;
    create temporary table temp_trans as
    select * from orders where total_amount > 5000;

    -- You can use the temp table here
    select * from temp_trans;

    commit;
    -- (Temp table will still exist until session ends or manually dropped)