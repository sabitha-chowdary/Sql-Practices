USE sql_practice;

-- Rank employees by salary within each department.
select 
  employee_id,
  first_name,
  last_name,
  department_id,
  salary,
  rank() over (partition by department_id order by salary desc) as salary_rank
from employees;

-- Number orders chronologically for each customer.
select 
  order_id,
  customer_id,
  order_date,
  row_number() over (partition by customer_id order by order_date) as order_number
from orders;

-- Rank products by price within each category.
select 
  product_id,
  product_name,
  category_id,
  price,
  rank() over (partition by category_id order by price desc) as price_rank
from products;

-- Number customers by registration date.
select 
  customer_id,
  concat(first_name, ' ', last_name) as customer_name,
  registration_date,
  row_number() over (order by registration_date) as customer_number
from customers;

-- Find top 5 customers by total order value.
select *
from (
  select 
    c.customer_id,
    concat(c.first_name, ' ', c.last_name) as customer_name,
    sum(o.total_amount) as total_value,
    rank() over (order by sum(o.total_amount) desc) as rank_val
  from customers c
  join orders o on c.customer_id = o.customer_id
  group by c.customer_id
) as ranked
where rank_val <= 5;

-- Rank employees by hire date within job titles.
select 
  employee_id,
  first_name,
  last_name,
  job_title,
  hire_date,
  rank() over (partition by job_title order by hire_date) as hire_rank
from employees;

-- Number products by stock quantity (lowest to highest).
select 
  product_id,
  product_name,
  stock_quantity,
  row_number() over (order by stock_quantity asc) as quantity_rank
from products;

-- Find top 2 orders for each customer by value.
select *
from (
  select 
    order_id,
    customer_id,
    total_amount,
    rank() over (partition by customer_id order by total_amount desc) as order_rank
  from orders
) as ranked
where order_rank <= 2;

-- Rank suppliers by number of products supplied.
select 
  s.supplier_id,
  s.supplier_name,
  count(p.product_id) as total_products,
  rank() over (order by count(p.product_id) desc) as supply_rank
from suppliers s
left join products p on s.supplier_id = p.supplier_id
group by s.supplier_id;

-- Number orders by date for each month.
select 
  order_id,
  order_date,
  month(order_date) as order_month,
  row_number() over (partition by month(order_date) order by order_date) as order_rank
from orders;

-- Find most expensive product in each category.
select *
from (
  select 
    product_id,
    product_name,
    category_id,
    price,
    rank() over (partition by category_id order by price desc) as price_rank
  from products
) as ranked
where price_rank = 1;

-- Rank customers by order frequency.
select 
  c.customer_id,
  concat(first_name, ' ', last_name) as customer_name,
  count(o.order_id) as order_count,
  rank() over (order by count(o.order_id) desc) as frequency_rank
from customers c
left join orders o on c.customer_id = o.customer_id
group by c.customer_id;

-- Number employees by salary in each department.
select 
  employee_id,
  department_id,
  salary,
  row_number() over (partition by department_id order by salary desc) as salary_number
from employees;

-- Find top 3 months by total sales.
select *
from (
  select 
    date_format(order_date, '%Y-%m') as month,
    sum(total_amount) as total_sales,
    rank() over (order by sum(total_amount) desc) as sales_rank
  from orders
  group by date_format(order_date, '%Y-%m')
) as ranked
where sales_rank <= 3;

-- Rank orders by total amount within each year.
select 
  order_id,
  year(order_date) as order_year,
  total_amount,
  rank() over (partition by year(order_date) order by total_amount desc) as order_rank
from orders;

-- Number products by creation date within categories.
-- assuming there’s a column `created_at` in `products`
select 
  product_id,
  product_name,
  category_id,
  created_date,
  row_number() over (partition by category_id order by created_date) as product_order
from products;

-- Find highest-paid employee in each department.
select *
from (
  select 
    employee_id,
    first_name,
    last_name,
    department_id,
    salary,
    rank() over (partition by department_id order by salary desc) as salary_rank
  from employees
) as ranked
where salary_rank = 1;
