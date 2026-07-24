USE sql_practice;

-- List all cities where we have customers OR suppliers.
select city 
from customers
UNION
select city
from suppliers;

-- Show all email addresses from customers and employees.
select email from customers
union
select email from employees;

-- Combine product names and category names in one list.
select product_name as name, 'Product' as type
from products
union
select category_name as name, 'category' as type
from categories;

-- List all phone numbers from customers, employees, and suppliers.
select phone Phone_Number, 'Customer' as type
from customers
union
select phone Phone_Number, 'Employee' as type
from employees
union
select phone Phone_Number, 'Supplier' as type
from suppliers;

-- Show all first names from customers and employees.
select first_name, 'Customer' as type
from customers
union
select first_name, 'Employee' as type
from employees;

-- combine all addresses from customers, and suppliers
select address from customers
union
select address from suppliers;

-- list all dates from orders and employee hire dates
select order_date as date from orders
union
select hire_date as date from employees;

-- combine high-value and frequent customers
	-- high-value customers: total order value > 20000
select distinct c.customer_id, concat(c.first_name, ' ', c.last_name) as customer_name, 'high-value' as customer_type
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id
having sum(o.total_amount) > 20000
union
	-- frequent customers: more than 10 orders
select distinct c.customer_id, concat(c.first_name, ' ', c.last_name) as customer_name, 'frequent' as customer_type
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id
having count(o.order_id) > 10;

-- show all contact methods (emails and phones) for business contacts
	-- emails
select 'email' as contact_type, email as contact_value from customers
where email is not null
union
select 'email', email from employees
where email is not null
union
select 'email', email from suppliers
where email is not null
UNION
	-- phones
select 'phone', phone from customers
where phone is not null
union
select 'phone', phone from employees
where phone is not null
union
select 'phone', phone from suppliers
where phone is not null;

-- list all locations (customer cities, supplier cities)
select city from customers
union
select city from suppliers;

-- show all business entities (customers, suppliers, employees) with contact info
select 
  concat(first_name, ' ', last_name) as name,
  email,
  phone,
  'customer' as entity_type
from customers
union
select 
  supplier_name as name,
  email,
  phone,
  'supplier' as entity_type
from suppliers
union
select 
  concat(first_name, ' ', last_name) as name,
  email,
  phone,
  'employee' as entity_type
from employees;
