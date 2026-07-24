USE sql_practice;

-- Compare each month's sales with the previous month.
select 
  date_format(order_date, '%Y-%m') as order_month,
  sum(total_amount) as monthly_sales,
  lag(sum(total_amount)) over (order by date_format(order_date, '%Y-%m')) as previous_month_sales,
  sum(total_amount) - lag(sum(total_amount)) over (order by date_format(order_date, '%Y-%m')) as difference
from orders
group by date_format(order_date, '%Y-%m');

-- Calculate 3-month moving average of order totals.
select 
  date_format(order_date, '%Y-%m') as order_month,
  sum(total_amount) as monthly_total,
  avg(sum(total_amount)) over (order by date_format(order_date, '%Y-%m') rows between 2 preceding and current row) as moving_avg_3_months
from orders
group by date_format(order_date, '%Y-%m');

-- Find difference between consecutive orders for each customer.
select 
  customer_id,
  order_id,
  order_date,
  total_amount,
  total_amount - lag(total_amount) over (partition by customer_id order by order_date) as difference_from_previous
from orders;

-- Show next order date for each customer.
select 
  customer_id,
  order_id,
  order_date,
  lead(order_date) over (partition by customer_id order by order_date) as next_order_date
from orders;

-- Calculate running total of sales by month.
select 
  date_format(order_date, '%Y-%m') as order_month,
  sum(total_amount) as monthly_sales,
  sum(sum(total_amount)) over (order by date_format(order_date, '%Y-%m')) as running_total
from orders
group by date_format(order_date, '%Y-%m');

-- Compare current employee salary with previous hire's salary.
select 
  employee_id,
  first_name,
  last_name,
  hire_date,
  salary,
  lag(salary) over (order by hire_date) as previous_salary,
  salary - lag(salary) over (order by hire_date) as salary_difference
from employees;

-- Find percentage change in monthly orders.
select 
  date_format(order_date, '%Y-%m') as order_month,
  count(*) as order_count,
  lag(count(*)) over (order by date_format(order_date, '%Y-%m')) as previous_month_count,
  round((count(*) - lag(count(*)) over (order by date_format(order_date, '%Y-%m'))) / lag(count(*)) over (order by date_format(order_date, '%Y-%m')) * 100, 2) as percentage_change
from orders
group by date_format(order_date, '%Y-%m');

-- Show running average of product prices.
select 
  product_id,
  product_name,
  price,
  avg(price) over (order by product_id rows between unbounded preceding and current row) as running_avg_price
from products;

-- Calculate difference between consecutive product prices in each category.
select 
  product_id,
  product_name,
  category_id,
  price,
  price - lag(price) over (partition by category_id order by price) as price_difference
from products;

-- Find cumulative sum of order quantities.
select 
  order_id,
  product_id,
  quantity,
  sum(quantity) over (order by order_id) as cumulative_quantity
from order_details;

-- Show trend in customer registrations (month-over-month growth).
select 
  date_format(registration_date, '%Y-%m') as registration_month,
  count(*) as registrations,
  count(*) - lag(count(*)) over (order by date_format(registration_date, '%Y-%m')) as growth
from customers
group by date_format(registration_date, '%Y-%m');

-- Calculate moving average of employee salaries by department.
select 
  employee_id,
  department_id,
  salary,
  avg(salary) over (partition by department_id order by employee_id rows between 2 preceding and current row) as moving_avg_salary
from employees;

-- Find gaps between customer orders.
select 
  customer_id,
  order_id,
  order_date,
  datediff(order_date, lag(order_date) over (partition by customer_id order by order_date)) as days_between_orders
from orders;

-- Show running count of orders by customer.
select 
  customer_id,
  order_id,
  order_date,
  row_number() over (partition by customer_id order by order_date) as order_number
from orders;

-- Calculate percentage of total sales for each order.
select 
  order_id,
  total_amount,
  round(total_amount / sum(total_amount) over () * 100, 2) as percentage_of_total_sales
from orders;

-- Find seasonal trends in product sales.
select 
  month(order_date) as sale_month,
  p.product_id,
  p.product_name,
  sum(od.quantity) as total_sold
from order_details od
join orders o on od.order_id = o.order_id
join products p on od.product_id = p.product_id
group by month(order_date), p.product_id;

-- Show cumulative customer count by month.
select 
  date_format(registration_date, '%Y-%m') as reg_month,
  count(*) as new_customers,
  sum(count(*)) over (order by date_format(registration_date, '%Y-%m')) as cumulative_customers
from customers
group by date_format(registration_date, '%Y-%m');

-- Find average time between orders for each customer.
select 
  customer_id,
  avg(days_between_orders) as avg_days_between_orders
from (
  select 
    customer_id,
    datediff(order_date, lag(order_date) over (partition by customer_id order by order_date)) as days_between_orders
  from orders
) as order_diff
where days_between_orders is not null
group by customer_id;

-- Show running percentage of completed orders.
select 
  order_id,
  status,
  sum(case when status = 'Completed' then 1 else 0 end) over (order by order_id) /
  count(*) over (order by order_id) * 100 as running_completion_percentage
from orders;
