USE sql_practice;

-- Count employees by department_id.
select department_id, count(*) as employee_count from employees group by department_id;

-- Find average salary by job_title.
select job_title, avg(salary) as avg_salary from employees group by job_title;

-- Count customers by country.
select country, count(*) as no_of_customers from customers group by country;

-- Calculate total sales by product_id (from order_details).
select product_id, count(*) as no_of_sales, sum(unit_price*quantity) as total_amount from order_details group by product_id;

-- Show average product price by category_id.
select category_id, avg(price) as avg_price from products group by category_id;

-- Count orders by status.
select status, count(*) as no_of_orders from orders group by status;

-- Find total order_amount by customer_id.
select customer_id, sum(total_amount) as order_amount from orders group by customer_id;

-- Show departments with more than one employee.
select department_id, count(*) as no_of_employees from employees group by department_id having count(employee_id) > 1;

-- List countries with more than 2 customers.
select country, count(*) as no_of_customers from customers group by country having no_of_customers > 2;

-- Find job_titles with average salary > 100000.
select job_title, avg(salary) as avg_salary from employees group by job_title having avg_salary > 100000;

-- Show categories with average product price > 10000.
select category_id, avg(price) as avg_price from products group by category_id having avg_price > 10000;

-- List customers with total order value > 20000.
select customer_id, sum(total_amount) as total_value from orders group by customer_id having total_value > 20000;

-- Find product categories with more than 4 products.
select category_id, count(*) as total_products from products group by category_id having total_products > 4;

-- Show order statuses that have more than 10 orders.
select status, count(*) as no_of_orders from orders group by status having no_of_orders > 10;

-- List suppliers with more than one product.
select supplier_id, count(*) as no_of_products from suppliers group by supplier_id having no_of_products > 1;

-- Find departments with total salary budget > 150000.
select department_id, sum(salary) as salary_budget from employees group by department_id having salary_budget > 150000;

-- Show cities with more than 1 customer.
select city, count(customer_id) as no_of_customers from customers group by city having no_of_customers > 1;

-- List years with more than 5 orders.
select year(order_date) as order_year, count(order_id) as no_of_orders from orders group by order_year having no_of_orders > 5;
