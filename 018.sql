USE sql_practice;

-- Create a view showing employee name and department.
create or replace view vw_employee_department as
select 
    e.employee_id,
    concat(e.first_name, ' ', e.last_name) as employee_name,
    d.department_name
from employees e
left join departments d on e.department_id = d.department_id;

show indexes from employees;

-- Create a view showing top 5 selling products.
create or replace view vw_top_5_products as
select 
    p.product_id,
    p.product_name,
    sum(od.quantity) as total_sold
from products p
join order_details od on p.product_id = od.product_id
group by p.product_id
order by total_sold desc
limit 5;

-- Create a view for monthly revenue by product.
create or replace view vw_monthly_revenue as
select 
    p.product_name,
    date_format(o.order_date, '%Y-%m') as order_month,
    sum(od.quantity * od.unit_price) as monthly_revenue
from products p
join order_details od on p.product_id = od.product_id
join orders o on o.order_id = od.order_id
group by p.product_id, order_month;

-- Create an updatable view on customers.
create or replace view vw_updatable_customers as
select customer_id, first_name, last_name, email
from customers;

-- Try inserting into a view and explain the result.
-- NOTE: This works if the view is updatable (no joins, no aggregations, etc.)
insert into vw_updatable_customers (first_name, last_name, email)
values ('Test', 'User', 'test.user@example.com'); -- This works if your view is simple and matches base table constraints

-- Use a view to hide sensitive columns (like salary).
create or replace view vw_employee_public as
select employee_id, first_name, last_name, job_title, department_id
from employees;

-- Create a nested view from another view.
create or replace view vw_employee_summary as
select * from vw_employee_department
where department_name is not null;

-- Drop a view and re-create it with updated logic.
drop view if exists vw_top_5_products;

create view vw_top_5_products as
select 
    p.product_id,
    p.product_name,
    sum(od.quantity) as total_sold
from products p
join order_details od on p.product_id = od.product_id
group by p.product_id
order by total_sold desc
limit 10;  -- Changed to top 10

-- Use a view in a JOIN query.
select 
    c.first_name,
    c.last_name,
    o.total_amount,
    v.department_name
from customers c
join orders o on c.customer_id = o.customer_id
join vw_employee_department v on v.employee_id = o.customer_id; -- hypothetical if employee assigned

-- Create a view filtering orders with status = 'Completed'.
create or replace view vw_completed_orders as
select *
from orders
where status = 'Completed';

-- Create a view for customers with total orders > 10000.
create or replace view vw_high_value_customers as
select 
    c.customer_id,
    concat(c.first_name, ' ', c.last_name) as customer_name,
    sum(o.total_amount) as total_orders
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id
having total_orders > 10000;

-- Create a view combining data from two schemas.
-- Assume schema1.customers and schema2.orders exist
create or replace view vw_cross_schema_data as
select 
    c.customer_id,
    c.first_name,
    o.order_id,
    o.total_amount
from schema1.customers c
join schema2.orders o on c.customer_id = o.customer_id;

-- Use WITH CHECK OPTION in a view.
create or replace view vw_domestic_customers as
select * from customers
where country = 'India'
with check option;
-- Ensures that only rows with country = 'India' can be inserted

-- Alter a view to add more columns.
drop view if exists vw_employee_public;

create view vw_employee_public as
select employee_id, first_name, last_name, job_title, department_id, hire_date
from employees;

-- Compare performance of view vs base table query.
explain select * from vw_top_5_products;
explain select p.product_id, product_name, sum(quantity) from products p join order_details group by product_id;

-- Use a view to simplify a complex subquery.
create or replace view vw_order_totals as
select order_id, sum(quantity * unit_price) as order_total
from order_details
group by order_id;
-- Then query:
select o.order_id, o.order_date, v.order_total
from orders o
join vw_order_totals v on o.order_id = v.order_id;


-- Retrieving all views in a schema 
select *
from information_schema.statistics
where table_schema = 'sql_practice';
