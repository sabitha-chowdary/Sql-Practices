USE sql_practice;

-- Display all columns from the employees table.
select *from employees;

-- Show only first_name, last_name, and salary from employees.
select first_name, last_name, salary from employees;

-- List all unique job titles from the employees table.
select distinct job_title from employees;

-- Display the first 5 rows from the customers table.
select *from customers limit 5;

-- Show all product names and their prices.
select product_name, price from products;

-- List all department names.
select distinct department_name from departments;

-- Display customer_id, email, and city for all customers.
select customer_id, email, city from customers;

-- Show all orders with order_id, customer_id, and order_date.
select order_id, customer_id, order_date from orders;

-- List all categories with their descriptions.
select distinct description from categories;

-- Display supplier names and their contact information.
select supplier_name, contact_name from suppliers;

-- Show all products with product_id and product_name only.
select product_id, product_name from products;

-- List the last 10 employees based on employee_id.
select *from employees order by employee_id desc limit 10;

-- Display all columns from orders table limiting to 8 rows.
select *from orders limit 8;

-- Show unique cities from customers table.
select distinct city from customers;

-- List all order statuses (distinct values) from orders table.
select distinct status from orders;

-- Find all employees with salary greater than 60000.
select *from employees where salary > 60000;

-- List customers from 'Maharashtra' state.
-- select *from customers where state like "Maharashtra";
select *from customers where state = "Maharashtra";

-- Show products with price more than 10000.
select *from products where price > 10000;

-- Find employees hired after '2020-01-01'.
select *from employees where hire_date > "2020-01-01";

-- Display customers from 'USA' country.
select *from customers where country = "USA";

-- List products with stock_quantity equal to 0.
select *from products where stock_quantity = 0;

-- Find employees with job_title = 'HR Manager'.
select *from employees where job_title = "HR Manager";

-- Show orders placed after '2022-01-01'.
select *from orders where order_date > "2022-01-01";

-- List customers with postal_code = '500001'.
select *from customers where postal_code = "500001";

-- Find products with price exactly 99.99.
select *from products where price = 99.99;

-- Show employees with department_id = 3.
select *from employees where department_id = 3;

-- List orders with status = 'Shipped'.
select *from orders where status = "shipped";

-- Find customers registered before '2022-01-01'.
select *from customers where registration_date < "2022-01-01";

-- Show products created after '2022-01-01'.
select *from products where created_date > "2022-01-01";

-- List employees with salary less than 60000.
select *from employees where salary < 60000;

-- Find customers from 'London' city.
select *from customers where city = "london";

-- Show orders with total_amount greater than 2000.
select *from orders where total_amount > 2000;

-- List products with category_id = 2.
select *from products where category_id = 2;
