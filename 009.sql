USE sql_practice;

-- Find customers who have ordered all products from 'Electronics' category.
select c.customer_id, concat(c.first_name, ' ', c.last_name) as customer_name
from customers c
join orders o on c.customer_id = o.customer_id
join order_details od on o.order_id = od.order_id
join products p on od.product_id = p.product_id
join categories cat on p.category_id = cat.category_id
where cat.category_name = 'electronics'
group by c.customer_id
having count(distinct p.product_id) = (
    select count(*) 
    from products p
    join categories cat on p.category_id = cat.category_id
    where cat.category_name = 'electronics'
);

-- List employees who manage at least one person.
select em.*
from employees em
join (
	select e.employee_id
    from employees e
    inner join employees m on e.manager_id = m.employee_id
)manager_list on manager_list.employee_id = em.employee_id;

-- Show products that appear in more than 5 orders.
select p.*
from products p
join (
	select product_id,count(*) as count_orders
	from order_details
	group by product_id
)prod_details on 
	prod_details.product_id = p.product_id and 
    prod_details.count_orders > 1;

-- Find customers who have placed orders every month this year.
SELECT customer_id
FROM orders
WHERE YEAR(order_date) = YEAR(CURDATE())
GROUP BY customer_id
HAVING COUNT(DISTINCT MONTH(order_date)) = 12;

-- List employees with salary above all employees in 'HR' department.
select e.*
from employees e
join (
	select max(e2.salary) as hr_salary
    from employees e2
	where department_id = 2
)hr_max_salary on hr_max_salary.hr_salary < e.salary;

-- Show products more expensive than any product in 'Books' category.
select p.*
from products p
join (
	select max(p2.price) as max_price
	from products p2
	where category_id = 9
)max_book_price on p.price > max_book_price.max_price;

-- Find customers with order frequency above company average.
SELECT customer_id, COUNT(*) AS order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > (
    SELECT AVG(order_count)
    FROM (
        SELECT COUNT(*) AS order_count
        FROM orders
        GROUP BY customer_id
    ) AS customer_orders
);

-- List departments where all employees earn above 80,000.
SELECT d.department_id, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY e.department_id, d.department_name
HAVING MIN(e.salary) > 80000;

-- Show orders that contain products from multiple categories.
select o.*
from orders o
join order_details od on o.order_id = od.order_id
join products p on od.product_id = p.product_id
join categories c on p.category_id = c.category_id
group by o.order_id
having count(distinct c.category_id) > 1;

-- Find employees who have the same job title as their manager.
select 
  concat(e.first_name, ' ', e.last_name) as employee_name,
  e.job_title as employee_job_title,
  concat(m.first_name, ' ', m.last_name) as manager_name,
  m.job_title as manager_job_title
from employees e
join employees m on e.manager_id = m.employee_id
where e.job_title = m.job_title;

-- List customers who have ordered from multiple suppliers
select o.customer_id
from orders o
join order_details od on o.order_id = od.order_id
join products p on od.product_id = p.product_id
join suppliers s on p.supplier_id = s.supplier_id
group by o.customer_id
having count(distinct s.supplier_id) > 1;

-- show products available from more than one supplier
select p.product_id, p.product_name
from products p
join suppliers s on p.supplier_id = s.supplier_id
group by p.product_id
having count(distinct s.supplier_id) > 1;

-- find employees in departments with budget above average
select e.employee_id, e.first_name, e.last_name, e.department_id
from employees e
join departments d on e.department_id = d.department_id
where d.budget > (
    select avg(budget) from departments
);

-- list customers whose last order was recent (within 30 days)
select c.customer_id, c.first_name, c.last_name
from customers c
join orders o on c.customer_id = o.customer_id
where o.order_date > current_date - interval 30 day;

-- show products with stock levels below their category average
select p.product_id, p.product_name, p.stock_quantity, c.category_name
from products p
join categories c on p.category_id = c.category_id
where p.stock_quantity < (
    select avg(stock_quantity)
    from products
    where category_id = p.category_id
);

-- find orders with all items from the same category
select o.order_id
from orders o
join order_details od on o.order_id = od.order_id
join products p on od.product_id = p.product_id
group by o.order_id
having count(distinct p.category_id) = 1;

-- show customers with diverse order history (multiple categories)
select o.customer_id
from orders o
join order_details od on o.order_id = od.order_id
join products p on od.product_id = p.product_id
group by o.customer_id
having count(distinct p.category_id) > 1;

-- find products with consistent monthly sales
select p.product_id, p.product_name
from order_details od
join products p on od.product_id = p.product_id
join orders o on od.order_id = o.order_id
where year(o.order_date) = year(current_date)
group by p.product_id
having count(distinct month(o.order_date)) > 8;

-- list departments with employee retention above average
select d.department_id, d.department_name
from departments d
join employees e on d.department_id = e.department_id
where (
    select avg(year(current_date) - year(e.hire_date)) from employees
) < (year(current_date) - year(e.hire_date))
group by d.department_id
having avg(year(current_date) - year(e.hire_date)) > (
    select avg(year(current_date) - year(e.hire_date)) from employees
);

-- show orders with unusual patterns (very high or low quantities)
select o.order_id, od.product_id, od.quantity
from order_details od
join orders o on od.order_id = o.order_id
where od.quantity > (
    select avg(quantity) + 2 * stddev(quantity) from order_details
) or od.quantity < (
    select avg(quantity) - 2 * stddev(quantity) from order_details
);

-- find customers with loyalty patterns (regular ordering)
select o.customer_id
from orders o
group by o.customer_id
having count(o.order_id) > 5
and datediff(max(o.order_date), min(o.order_date)) / count(o.order_id) < 30;
