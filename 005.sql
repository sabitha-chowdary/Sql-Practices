USE sql_practice;

-- Show employee names with their department names.
select concat(e.first_name, ' ', e.last_name) as employee_name, 
		d.department_name as department_name
from employees e
inner join departments d on e.department_id = d.department_id;

-- List customers with their order information.
select concat(c.first_name, ' ', c.last_name) as customer_name, 
		o.order_date, o.status, o.total_amount
from customers c
inner join orders o on c.customer_id = o.customer_id;

-- Display products with their category names.
select p.product_name, c.category_name
from products p
inner join categories c on c.category_id = p.category_id;

-- Show order details with product names.
select od.order_detail_id, od.quantity, od.unit_price, p.product_name
from order_details od
inner join products p on od.product_id = p.product_id;

-- List employees with their manager names.
select concat(e.first_name, ' ', e.last_name) as employee_name, 
		concat(m.first_name, ' ', m.last_name) as manager_name
from employees e
inner join employees m on e.manager_id = m.employee_id;

-- Display orders with customer names and emails.
select o.order_id, o.order_date, o.status, 
		concat(c.first_name, ' ', c.last_name) as customer_name, 
        c.email as customer_email
from orders o
inner join customers c on o.customer_id = c.customer_id;

-- Show products with supplier information.
select p.product_name, s.supplier_name, s.contact_name
from products p
inner join suppliers s on p.supplier_id = s.supplier_id;

-- List order details with customer and product info.
select od.order_detail_id,
		o.order_id,
        concat(c.first_name, ' ', c.last_name) as customer_name,
        c.email as customer_email,
        p.product_name,
        od.quantity,
        od.unit_price
from order_details od
inner join orders o on o.order_id = od.order_id
inner join customers c on c.customer_id = o.customer_id
inner join products p on p.product_id = od.product_id;
        
-- Display employees with department location.
select concat(e.first_name, ' ', e.last_name) as employee_name,
		e.job_title,
        d.department_name
from employees e
inner join departments d on e.department_id = d.department_id;        

-- Show orders with complete customer address.
select concat(c.first_name, ' ', c.last_name) as customer_name,
		c.address,
        c.city,
        c.state,
        c.country,
        c.postal_code,
        o.shipping_address
from customers c
inner join orders o on c.customer_id = o.customer_id;

-- List products with category descriptions.
select p.product_name,
		c.category_name,
        c.description as category_description
from products p
inner join categories c on p.category_id = c.category_id;

-- Display order summaries with customer cities.
select o.order_id,
		o.order_date,
        o.status,
        o.total_amount,
        o.shipping_address,
        c.city
from orders o
inner join customers c on o.customer_id = c.customer_id;

-- Show employee contact info with department budget.
select concat(e.first_name, ' ', e.last_name) as employee_name, 
		e.email,
        e.phone,
        e.department_id,
        d.department_name,
        d.budget
from employees e
inner join departments d on e.department_id = d.department_id;

-- List detailed order information (customer, product, quantity).
select concat(c.first_name, ' ', c.last_name) as customer_name, 
		p.product_name,
		od.quantity
from customers c
inner join orders o on c.customer_id = o.customer_id
inner join order_details od on o.order_id = od.order_id
inner join products p on od.product_id = p.product_id;

-- Display product inventory with supplier contact.
select p.product_name,
		p.price,
        p.stock_quantity,
        s.supplier_name,
        s.contact_name,
        s.phone,
        s.email
from products p
inner join suppliers s on p.supplier_id = s.supplier_id;

-- Show customer order history with product names.
select concat(c.first_name, ' ', c.last_name) as customer_name,
		p.product_name,
        o.order_date,
        o.status,
        od.quantity,
        od.unit_price
from customers c
inner join orders o on c.customer_id = o.customer_id
inner join order_details od on od.order_id = o.order_id
inner join products p on p.product_id = od.product_id;
		
-- List employee hierarchy (employee and manager details).
select concat(e.first_name, ' ', e.last_name) as employee_name, 
		e.job_title,
		concat(m.first_name, ' ', m.last_name) as manager_name,
        m.job_title AS manager_title
from employees e
left join employees m on e.manager_id = m.employee_id;

-- Display order fulfillment info (customer, product, supplier).
select concat(c.first_name, ' ', c.last_name) as customer_name,
		p.product_name,
        s.supplier_name
from customers c
inner join orders o on o.customer_id = c.customer_id
inner join order_details od on od.order_id = o.order_id
inner join products p on p.product_id = od.product_id
inner join suppliers s on s.supplier_id = p.supplier_id;

-- Show department performance (employees and total salary).
select d.department_name,
		count(e.employee_id) as no_of_employees,
        sum(e.salary) as total_salaries
from departments d
inner join employees e on e.department_id = d.department_id
group by d.department_id, d.department_name;

-- List complete order details with all related information.
select 
  o.order_id,
  o.order_date,
  o.status,
  concat(c.first_name, ' ', c.last_name) as customer_name,
  c.email as customer_email,
  p.product_name,
  s.supplier_name,
  od.quantity,
  od.unit_price,
  (od.quantity * od.unit_price) as total_line_price
from orders o
inner join customers c on o.customer_id = c.customer_id
inner join order_details od on o.order_id = od.order_id
inner join products p on od.product_id = p.product_id
inner join suppliers s on p.supplier_id = s.supplier_id
order by o.order_id, p.product_name;
