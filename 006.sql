USE sql_practice;

-- Show all customers and their orders (including customers with no orders).
select concat(c.first_name, ' ', c.last_name) as customer_name, 
		o.order_date, o.status, o.total_amount
from customers c
left join orders o on c.customer_id = o.customer_id;

-- List all products and their order quantities (including never-ordered products).
select p.product_name, 
		od.quantity
from products p
left join order_details od on p.product_id = od.product_id;

-- Display all employees and their departments (including unassigned employees).
select concat(e.first_name, ' ', e.last_name) as employee_name,
		e.job_title,
        d.department_name
from employees e
left join departments d on e.department_id = d.department_id;     

-- Show all categories and their product counts (including empty categories).
select c.category_name,
		count(p.product_id) as no_of_products
from categories c
left join products p on c.category_id = p.category_id 
group by c.category_id, c.category_name;

-- List all suppliers and their products (including suppliers with no products).
select s.supplier_name,
		p.product_name
from suppliers s
left join products p on s.supplier_id = p.supplier_id
order by s.supplier_name;

-- Find customers who have never placed an order.
select distinct concat(c.first_name, ' ', c.last_name) as customer_name
from customers c
left join orders o on c.customer_id = o.customer_id
where o.order_id is null;

-- Show products that have never been ordered.
select p.product_name
from products p
left join order_details od on p.product_id = od.product_id
where od.order_id is null;

-- List employees without assigned departments.
select  concat(e.first_name, ' ', e.last_name) as employee_name 
from employees e
left join departments d on e.department_id = d.department_id
where d.department_id is null;

-- 2nd Method
SELECT 
  employee_id,
  CONCAT(first_name, ' ', last_name) AS employee_name,
  job_title
FROM employees
WHERE department_id IS NULL;

-- Display categories with no products.
select c.category_name, 
		c.description
from categories c
left join products p on c.category_id = p.category_id
where p.product_id is null;

-- Show suppliers with no products.
select s.supplier_name,
		s.contact_name
from suppliers s
left join products p on s.supplier_id = p.supplier_id
where p.supplier_id is null;


-- Find all departments and employee counts (including empty departments).
select d.department_name,
		count(e.employee_id) as employee_count
from departments d
left join employees e on d.department_id = e.department_id
group by d.department_id;

-- List all orders and their details (including orders with no details).
select o.order_id,
		o.order_date,
        o.status as order_status,
        o.total_amount,
        od.quantity as order_quantity,
        od.product_id,
        p.product_name
from orders o
left join order_details od on o.order_id = od.order_id
left join products p on od.product_id = p.product_id
order by o.order_id;

-- Show all products with their total sales (including unsold products).
select p.product_name,
		sum(od.quantity) as quantity_sales
from products p
left join order_details od on p.product_id = od.product_id
group by p.product_id
order by quantity_sales;

-- Display customers with their total order values (including zero).
select concat(c.first_name, ' ', c.last_name) as customer_name, 
		coalesce(sum(o.total_amount),0) as total_order_value
from customers c
left join orders o on c.customer_id = o.customer_id
group by c.customer_id
order by customer_name;

-- Show all categories with average product prices (including empty ones).
select c.category_name,
		coalesce(avg(p.price),0) as average_product_price
from categories c
left join products p on c.category_id = p.category_id
group by c.category_id
order by average_product_price;

-- Find managers and their direct report counts (including managers with no reports).
select concat(m.first_name, ' ', m.last_name) as manager_name,
		count(e.employee_id) as report_count
from employees m
left join employees e on e.manager_id = m.employee_id
group by m.employee_id, m.first_name, m.last_name
order by report_count desc; 

-- Display all years and order counts (including years with no orders).
select year(date(order_date)) as year,
		count(order_id) as order_counts
from orders
group by year;

-- List all cities and customer counts (including cities with no customers).
select city,
		count(customer_id) as customer_count
from customers
group by city
order by customer_count;

-- Show all job titles and employee counts (including unused titles).
select job_title,
		count(employee_id) as employee_count
from employees
group by job_title
order by employee_count;

-- Display all order statuses and their frequencies (including unused statuses).
select status,
		count(order_id) as frequency
from orders
group by status
order by frequency;

-- List all countries and their customer counts (including countries with no customers).
select country,
		count(customer_id) as customer_count
from customers
group by country
order by customer_count;
