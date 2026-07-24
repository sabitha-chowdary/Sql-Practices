-- Find employees with salary > 50000 AND department_id = 1.
select *from employees where salary > 50000 and department_id = 1;

-- List customers from 'USA' OR 'Canada'.
select *from customers where ( country = "USA" ) or ( country = "Canada" ) ;

-- Show products with price < 20 OR stock_quantity > 150.
select *from products where ( price < 20 ) or ( stock_quantity > 150 );

-- Find employees NOT in department_id 2 or 3.
select *from employees where ( department_id <> 2 ) and ( department_id <> 3 ) ;

-- List customers from 'Maharashtra' AND country = 'India'.
select *from customers where state = "Maharashtra" and country = "India";

-- Show orders with total_amount > 5000 AND status = 'Delivered'.
select *from orders where total_amount > 5000 and status = 'delivered';

-- Find products with price BETWEEN 5000 AND 15000.
select *from products where price > 5000 and price < 15000;

-- List employees with salary > 80000 OR job_title = 'Engineer'.
select *from employees where salary > 80000 or job_title = "Engineer";

-- Show customers NOT from 'USA', 'Canada', or 'Mexico'.
select *from customers where country not in ("usa", "canada","mexico");

-- Find products with stock_quantity < 100 AND price > 50000.
select *from products where stock_quantity < 100 and price > 50000;

-- List orders placed in 2023 AND total_amount > 500.
select *from orders where order_date like "2023%" and total_amount > 500;

-- Show employees hired BETWEEN '2020-01-01' AND '2022-12-31'.
-- select *from employees where hire_date > "2020-01-01" and hire_date < "2022-12-31";
select *from employees where hire_date between '2020-01-01' and '2022-12-31';

-- Find customers from 'Spain' OR 'France' states.
select *from customers where country in ('France', 'Spain');

-- List products with price > 100 OR category_id IN (1, 3, 5).
select *from products where price > 90000 or category_id in (1, 3, 5);

-- Show employees with salary NOT BETWEEN 40000 AND 90000.
select *from employees where salary not between 40000 and 90000;

-- Find orders with status NOT IN ('Delivered', 'Shipped').
select *from orders where status not in ("Delivered", "Shipped");

-- List customers with phone IS NOT NULL AND email IS NOT NULL.
select *from customers where phone is not null and email is not null;

-- Show products with description IS NOT NULL OR stock_quantity > 0.
select *from products where description is not null or stock_quantity > 0;

-- Find employees with manager_id IS NULL (top-level managers).
select *from employees where manager_id is null;

-- List orders with shipping_address IS NOT NULL AND status = 'Processing'.
select *from orders where shipping_address is not null and status = "Processing";

-- Sort all employees by salary in descending order.
select *from employees order by salary desc;

-- List customers alphabetically by last_name.
select *from customers order by last_name;

-- Show top 10 most expensive products.
select *from products order by price limit 10;

-- Display employees sorted by hire_date (newest first).
select *from employees order by hire_date desc;

-- List customers by registration_date (oldest first).
select *from customers order by registration_date;

-- Show products sorted by stock_quantity (lowest first).
select *from products order by stock_quantity;

-- Display top 5 highest total_amount orders.
select *from orders order by total_amount desc limit 5;

-- Sort employees by department_id, then by salary (descending).
select *from employees order by department_id , salary desc;

-- List customers by country, then by city alphabetically.
select *from customers order by country , city ;

-- Show products by category_id, then by price (ascending).
select *from products order by category_id, price;

-- Find the 3 most recently hired employees.
select *from employees order by hire_date desc limit 3;

-- Display bottom 5 products by price.
select *from products order by price limit 5;

-- Show orders sorted by order_date (most recent first), limit 15.
select *from orders order by order_date desc limit 15;

-- List employees by job_title alphabetically, then by salary descending.
select *from employees order by job_title , salary desc;

-- Display customers from offset 10, limit 5 (pagination).
select *from customers limit 5 offset 10;

-- Show 2nd to 6th highest paid employees.
select *from employees order by salary desc limit 5 offset 1;

-- List products sorted by created_date, showing rows 21-30.
select *from products order by created_date limit 10 offset 20;
