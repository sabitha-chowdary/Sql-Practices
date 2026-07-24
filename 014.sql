USE sql_practice;


-- Calculate monthly sales totals, then find months above average.
with monthly_sales as (
    select 
        date_format(order_date, '%y-%m') as month,
        sum(total_amount) as total_sales
    from orders
    group by month
),
average_sales as (
    select avg(total_sales) as avg_sales from monthly_sales
)
select ms.month, ms.total_sales
from monthly_sales ms, average_sales a
where ms.total_sales > a.avg_sales
order by ms.month;


-- Find employees and their management hierarchy levels.
with recursive hierarchy as (
    select 
        employee_id,
        first_name,
        last_name,
        manager_id,
        1 as level
    from employees
    where manager_id is null 
    union all
    select 
        e.employee_id,
        e.first_name,
        e.last_name,
        e.manager_id,
        h.level + 1
    from employees e
    inner join hierarchy h on e.manager_id = h.employee_id
)
select 
    employee_id,
    concat(first_name, ' ', last_name) as employee_name,
    level as hierarchy_level
from hierarchy
order by level, employee_name;


-- Calculate customer lifetime value using multiple steps.
-- 1. calculate total spent per order
with order_totals as (
    select 
        o.order_id,
        o.customer_id,
        sum(od.quantity * od.unit_price) as order_total
    from orders o
    join order_details od on o.order_id = od.order_id
    group by o.order_id, o.customer_id
),
-- 2. aggregate total spent per customer
customer_lifetime_value as (
    select 
        customer_id,
        sum(order_total) as lifetime_value
    from order_totals
    group by customer_id
)
-- 3. join with customer info for final output
select 
    c.customer_id,
    concat(c.first_name, ' ', c.last_name) as customer_name,
    c.email,
    coalesce(clv.lifetime_value, 0) as lifetime_value
from customers c
left join customer_lifetime_value clv on c.customer_id = clv.customer_id
order by lifetime_value desc;


-- Create recursive organizational chart.
with recursive org_chart as (
  -- anchor member: top-level employees (no manager)
  select 
    employee_id,
    concat(first_name, ' ', last_name) as employee_name,
    manager_id,
    1 as level,
    concat(first_name, ' ', last_name) as hierarchy_path
  from employees
  where manager_id is null
  union all
  -- recursive member: find subordinates
  select 
    e.employee_id,
    concat(e.first_name, ' ', e.last_name) as employee_name,
    e.manager_id,
    oc.level + 1 as level,
    concat(oc.hierarchy_path, ' > ', e.first_name, ' ', e.last_name) as hierarchy_path
  from employees e
  inner join org_chart oc on e.manager_id = oc.employee_id
)
-- final result
select *
from org_chart
order by hierarchy_path;


-- Calculate year-over-year growth rates.
with yearly_sales as (
  select 
    year(order_date) as sales_year,
    sum(total_amount) as total_sales
  from orders
  group by year(order_date)
),
growth_calc as (
  select 
    sales_year,
    total_sales,
    lag(total_sales) over (order by sales_year) as prev_year_sales
  from yearly_sales
)
select 
  sales_year,
  total_sales,
  prev_year_sales,
  round(
    (total_sales - prev_year_sales) / prev_year_sales * 100, 2
  ) as yoy_growth_percentage
from growth_calc
where prev_year_sales is not null;


-- Find customers with consistent ordering patterns.
with customer_months as (
  select 
    customer_id,
    year(order_date) as order_year,
    month(order_date) as order_month
  from orders
  group by customer_id, year(order_date), month(order_date)
),
customer_month_counts as (
  select 
    customer_id,
    order_year,
    count(distinct order_month) as active_months
  from customer_months
  group by customer_id, order_year
),
consistent_customers as (
  select 
    customer_id
  from customer_month_counts
  where active_months = 12
  group by customer_id
  having count(order_year) >= 1
)
select 
  c.customer_id,
  concat(c.first_name, ' ', c.last_name) as customer_name,
  c.email
from customers c
join consistent_customers cc on c.customer_id = cc.customer_id;


-- Find products with declining sales trends.
with monthly_sales as (
  select 
    p.product_id,
    p.product_name,
    date_format(o.order_date, '%y-%m') as sale_month,
    sum(od.quantity) as total_quantity
  from order_details od
  join orders o on od.order_id = o.order_id
  join products p on od.product_id = p.product_id
  group by p.product_id, sale_month
),
sales_with_trend as (
  select 
    product_id,
    product_name,
    sale_month,
    total_quantity,
    lag(total_quantity) over (partition by product_id order by sale_month) as prev_month_quantity
  from monthly_sales
)
select *
from sales_with_trend
where prev_month_quantity is not null
  and total_quantity < prev_month_quantity
order by product_id, sale_month;


-- Calculate inventory turnover rates by category.
-- inventory turnover rate = cogs / average inventory
with category_sales as (
  select 
    p.category_id,
    sum(od.quantity * od.unit_price) as total_cogs
  from order_details od
  join products p on od.product_id = p.product_id
  group by p.category_id
),
category_inventory as (
  select 
    category_id,
    sum(stock_quantity * price) as inventory_value
  from products
  group by category_id
)
select 
  cat.category_id,
  cat.category_name,
  cs.total_cogs,
  ci.inventory_value as avg_inventory,
  round(cs.total_cogs / nullif(ci.inventory_value, 0), 2) as inventory_turnover_rate
from category_sales cs
join category_inventory ci on cs.category_id = ci.category_id
join categories cat on cat.category_id = cs.category_id
order by inventory_turnover_rate desc;
