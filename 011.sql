USE sql_practice;

-- Extract year from all order dates.
select distinct year(order_date) 
from orders;

-- Find orders placed in the current month.
select *
from orders
where month(order_date) = month(curdate());

-- Calculate age of all employees.
select datediff(curdate(), hire_date) as experience_in_days
from employees;

select 
  concat(timestampdiff(year, hire_date, curdate()), ' years, ',
         timestampdiff(month, hire_date, curdate()) % 12, ' months') as experience
from employees;

-- Show orders grouped by month and year.
select 
  year(order_date) as order_year,
  month(order_date) as order_month,
  count(order_id) as total_orders,
  sum(total_amount) as total_sales
from orders
group by year(order_date), month(order_date)
order by order_year, order_month;

-- Find employees hired in the last 2 years.
select *
from employees
where datediff(curdate(), hire_date) < 730;

-- Calculate days between order date and current date.
select  order_id, datediff(curdate(), order_date) as no_of_days
from orders;

-- Show customers registered in each quarter of 2023.
select 
  quarter(registration_date) as quarter,
  count(*) as total_customers
from customers
where year(registration_date) = 2023
group by quarter(registration_date)
order by quarter;

-- Find orders placed on weekends.
SELECT *
FROM orders
WHERE DAYOFWEEK(order_date) IN (1, 7);  -- 1 = Sunday, 7 = Saturday

-- Extract month name from employee hire dates.
select employee_id, 
		hire_date,
        monthname(hire_date) as hire_month
from employees;

-- Show orders placed in the last 90 days.
select *
from orders
where datediff(curdate(), order_date) < 90;

-- Format customer names as 'Last, First'.
select 
  concat(last_name, ', ', first_name) as formatted_name
from customers;

-- Convert all email addresses to lowercase.
select lower(email), 'Customers' as type
from customers
UNION
select lower(email), 'Emoloyee' as type
from employees
UNION
select lower(email), 'Suppliers' as type
from suppliers;

-- Extract domain names from customer emails.
select 
  email,
  substring_index(email, '@', -1) as domain_name
from customers;

-- Find customers with names longer than 10 characters.
select 
  concat(first_name, ' ', last_name) as full_name,
  length(concat(first_name, last_name)) as name_length
from customers
where length(concat(first_name, last_name)) > 10;

-- Show first 3 characters of all product names.
select 
  product_name,
  left(product_name, 3) as first_3_chars
from products;

-- Replace spaces with underscores in product names.
select 
  product_name,
  replace(product_name, ' ', '_') as product_name_underscored
from products;

-- Find customers whose names contain specific patterns.
select customer_id,
       concat(first_name, ' ', last_name) as full_name
from customers
where concat(first_name, ' ', last_name) like '%son%';

-- Calculate length of product descriptions.
select product_id, 
		length(description) as description_length
from products;

-- Show employees hired on the same day of the week.
select *
from employees
where day(hire_date) = day(curdate());

-- Find orders placed during business hours (9 AM - 5 PM).
select *
from orders
where hour(order_date) between 9 and 16;  -- 16 means up to 4:59 pm

	-- 2nd Approach
	select *
	from orders
	where time(order_date) >= '09:00:00'
	  and time(order_date) < '17:00:00';

-- Extract initials from customer names.
select 
  concat(left(first_name, 1), '.', left(last_name, 1), '.') as initials,
  first_name,
  last_name
from customers;

-- Show products with names in all uppercase.
select *
from products
where binary product_name = upper(product_name);

-- Find customers with palindromic names.
select customer_id,
       concat(first_name, ' ', last_name) as full_name
from customers
where replace(concat(first_name, last_name), ' ', '') = 
      reverse(replace(concat(first_name, last_name), ' ', ''));
