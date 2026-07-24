USE sql_practice;

-- Find employees and their direct managers.
select concat(e.first_name, ' ', e.last_name) as employee_name,
		concat(m.first_name, ' ', m.last_name) as manager_name
from employees e
inner join employees m on e.manager_id = m.employee_id;

	-- To include with no managers:
	select concat(e.first_name, ' ', e.last_name) as employee_name,
			concat(m.first_name, ' ', m.last_name) as manager_name
	from employees e
	left join employees m on e.manager_id = m.employee_id;

-- show customer Lifetime Value
select 
  concat(c.first_name, ' ', c.last_name) as customer_name,
  c.email,
  coalesce(sum(o.total_amount), 0) as lifetime_value
from customers c
left join orders o on c.customer_id = o.customer_id
group by c.customer_id
order by lifetime_value desc;

-- List employees who earn more than their managers.
select concat(e.first_name, ' ', e.last_name) as employee_name,
		e.salary as employee_salary,
		concat(m.first_name, ' ', m.last_name) as manager_name,
        m.salary as manager_salary
from employees e
inner join employees m on e.manager_id = m.employee_id
where e.salary > m.salary;

-- Show employees in the same department as 'John Smith'.
select concat(e.first_name, ' ', e.last_name) as employee_name,
        e.salary as salary,
        e.department_id
from employees e
where e.department_id = (
	select department_id 
    from employees 
    where first_name ='jhon' and last_name = 'smith'
);

-- Find employee pairs with the same job title.
select 
  concat(e1.first_name, ' ', e1.last_name) as employee_1,
  concat(e2.first_name, ' ', e2.last_name) as employee_2,
  e1.job_title
from employees e1
join employees e2 
  on e1.job_title = e2.job_title 
  and e1.employee_id < e2.employee_id
order by e1.job_title, employee_1, employee_2;

-- List managers with their direct report counts.
select concat(m.first_name, ' ', m.last_name) as manager_name,
		count(e.employee_id) as report_count
from employees m
inner join employees e on e.manager_id = m.employee_id
group by m.employee_id, m.first_name, m.last_name
order by report_count desc; 

-- Show employees hired on the same date.
select 
  concat(e1.first_name, ' ', e1.last_name) as employee_1,
  concat(e2.first_name, ' ', e2.last_name) as employee_2,
  e1.job_title
from employees e1
join employees e2 
  on e1.hire_date = e2.hire_date 
  and e1.employee_id < e2.employee_id
order by e1.job_title, employee_1, employee_2;

-- Find customers from the same city.
select 
  concat(c1.first_name, ' ', c1.last_name) as customer_1,
  concat(c2.first_name, ' ', c2.last_name) as customer_2,
  c1.city
from customers c1
join customers c2 
  on c1.city = c2.city
  and c1.customer_id < c2.customer_id
order by c1.city, customer_1, customer_2;

-- List products with the same price.
select 
  p1.product_name,
  p2.product_name,
  p1.price
from products p1
join products p2 
  on p1.price = p2.price
  and p1.product_id < p2.product_id
order by p1.price, p1.product_name;

-- Show orders placed on the same date by different customers.
select 
  o1.order_id,
  o1.customer_id as customer_id_1,
  o2.order_id,
  o2.customer_id as customer_id_2,
  o1.order_date
from orders o1
join orders o2 
  on o1.order_date = o2.order_date
  and o1.customer_id < o2.customer_id
order by o1.order_date, o1.order_id;

-- Join orders, customers, products, and categories in one query.
select c.customer_id,
		concat(c.first_name, ' ', c.last_name) as customer_name,
        o.order_id,
        o.order_date,
        od.product_id,
        p.product_name,
        p.category_id,
        ct.category_name
from customers c
join orders o on c.customer_id = o.customer_id
join order_details od on o.order_id = od.order_id
join products p on od.product_id = p.product_id
join categories ct on p.category_id = ct.category_id;

-- Display complete order information (customer, product, category, supplier).
select c.customer_id,
		concat(c.first_name, ' ', c.last_name) as customer_name,
        o.order_id,
        o.order_date,
        od.product_id,
        p.product_name,
        p.category_id,
        ct.category_name,
        s.supplier_id,
        s.supplier_name,
        s.contact_name
from customers c
join orders o on c.customer_id = o.customer_id
join order_details od on o.order_id = od.order_id
join products p on od.product_id = p.product_id
join categories ct on p.category_id = ct.category_id
join suppliers s on p.supplier_id = s.supplier_id;

-- Show employee, department, and manager information together.
select concat(e.first_name, ' ', e.last_name) as employee_name,
		concat(m.first_name, ' ', m.last_name) as manager_name,
        d.department_name as employee_department
from employees e
join employees m on e.manager_id = m.employee_id
join departments d on e.department_id = d.department_id;

-- List order details with customer location and product category.
select c.customer_id,
		concat(c.first_name, ' ', c.last_name) as customer_name,
        o.shipping_address as customer_address,
        o.order_id,
        o.order_date,
        od.product_id,
        p.product_name,
        p.category_id,
        ct.category_name
from customers c
join orders o on c.customer_id = o.customer_id
join order_details od on o.order_id = od.order_id
join products p on od.product_id = p.product_id
join categories ct on p.category_id = ct.category_id;

-- Display sales analysis with customer, product, and supplier data.
select 
  o.order_id,
  o.order_date,
  concat(c.first_name, ' ', c.last_name) as customer_name,
  p.product_name,
  s.supplier_name,
  od.quantity,
  od.unit_price,
  (od.quantity * od.unit_price) as total_sale
from orders o
inner join customers c on o.customer_id = c.customer_id
inner join order_details od on o.order_id = od.order_id
inner join products p on od.product_id = p.product_id
inner join suppliers s on p.supplier_id = s.supplier_id
order by o.order_date, customer_name, product_name;


-- Show inventory report with product, category, and supplier details.
select p.product_id,
		p.product_name,
        p.price,
        p.stock_quantity,
        p.category_id,
        c.category_name,
        c.description,
        p.supplier_id,
        s.supplier_name,
        s.contact_name as supplier_contact,
        s.phone as supplier_phone,
        s.email as supplier_email,
        concat(s.address, s.city, s.country) as supplier_address
from products p
join categories c on p.category_id = c.category_id
join suppliers s on p.supplier_id = s.supplier_id;

-- List customer order summary with product and category information.
select c.customer_id,
		concat(c.first_name, ' ', c.last_name) as customer_name,
        od.product_id,
        p.product_name,
        p.category_id,
        ct.category_name,
        o.order_id,
        o.order_date,
        o.shipping_address,
        od.quantity
from customers c
join orders o on c.customer_id = o.customer_id
join order_details od on o.order_id = od.order_id
join products p on od.product_id = p.product_id
join categories ct on p.category_id = ct.category_id;

-- Display employee performance with department and manager data.
select 
  concat(e.first_name, ' ', e.last_name) as employee_name,
  e.job_title,
  d.department_name,
  concat(m.first_name, ' ', m.last_name) as manager_name,
  e.salary
from employees e
left join departments d on e.department_id = d.department_id
left join employees m on e.manager_id = m.employee_id
order by d.department_name, e.salary desc;

-- Show complete business intelligence view (orders, customers, products, employees).
SELECT 
  o.order_id,
  o.order_date,
  CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
  c.email AS customer_email,
  p.product_name,
  od.quantity,
  od.unit_price,
  (od.quantity * od.unit_price) AS total_price,
  s.supplier_name
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN order_details od ON o.order_id = od.order_id
INNER JOIN products p ON od.product_id = p.product_id
LEFT JOIN suppliers s ON p.supplier_id = s.supplier_id
ORDER BY o.order_date, customer_name;
