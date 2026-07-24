USE sql_practice;

-- Find all employees with missing phone numbers.
select *from employees where phone is null;

-- List customers with email addresses (not null).
select *from customers where email is not null;

-- Show products with null descriptions.
select *from products where description is null;

-- Find employees whose first_name starts with 'J'.
select *from employees where first_name like "J%";

-- List customers whose last_name ends with 'son'.
select *from customers where last_name like '%son';

-- Show products containing 'Pro' in their name.
select *from products where product_name like '%pro%';

-- Find employees with phone numbers (not null).
select *from employees where phone is not null;

-- List customers whose email contains 'gmail'.
select *from customers where email like '%gmail%';

-- Show products whose name starts with 'Apple'.
select *from products where product_name like 'Apple%';

-- Find customers with missing postal_code.
select *from customers where postal_code is null;

-- List employees whose last_name contains 'er'.
select *from employees where last_name like '%er%';

-- Show products ending with 'X' or 'Y' in name.
select *from products where product_name like '%x' or product_name like '%y';

-- Find customers whose first_name has exactly 4 characters.
select *from customers where first_name like '____';

-- List orders with null shipping_address.
select *from orders where shipping_address is null;

-- Show employees whose job_title contains 'Manager'.
select *from employees where job_title like '%manager%';

-- Find products whose description contains 'wireless' or 'bluetooth'.
select *from products where description like '%wireless%' or description like '%bluetooth%';

-- List customers whose city starts with 'Del'.
select *from customers where city like 'del%';

-- Show employees with email ending with company domain '.com'.
select *from employees where email like '%.com';

-- Find products with names containing numbers (using LIKE with patterns).
select *from products where product_name REGEXP '[0-9]';

-- Count total number of employees.
select count(*) as total_no_of_employees from employees;

-- Find the average salary of all employees.
select avg(salary) as average_salary from employees;

-- Get the maximum and minimum product prices.
select max(price) as max_price, min(price) as min_price from products;

-- Calculate total stock_quantity of all products.
select sum(stock_quantity) as total_stock_quantity from products;

-- Count how many customers are registered.
select count(*) as no_of_customers from customers;

-- Find the sum of all order total_amounts.
select sum(total_amount) from orders;

-- Get the average price of products.
select avg(price) as average_price from products;

-- Count how many orders have been placed.
select count(*) as no_of_orders from orders;

-- Find the earliest and latest hire_date of employees.
select min(hire_date) as earliest, max(hire_date) as latest from employees;

-- Calculate average total_amount of orders.
select avg(total_amount) as avg_total_amount from orders;

-- Count products with stock_quantity > 0.
select count(*) as products_in_stock from products where stock_quantity > 0;

-- Find total quantity ordered across all order_details.
select sum(quantity) as total_quantity from order_details;

-- Get the highest salary in the company.
select max(salary) as highest_salary from employees;

-- Count customers by country (just the count, not grouped).
select count(distinct country) as total_no_of_customers from customers;

-- Find average days between order_date and current date.
select avg(datediff(curdate(), order_date)) as avg_days from orders;

-- Calculate total revenue (sum of quantity * unit_price from order_details).
select sum(quantity * unit_price) as total_revenue from order_details;
