USE sql_practice;

-- Find employees with salary above company average.
select *
from employees
where salary > (
	select avg(salary) 
    from employees
);

-- List customers who have placed orders above average order value.
select concat(c.first_name, ' ', c.last_name) as customer_name,
		c.email,
        c.phone,
        o.order_date,
        o.total_amount
from customers c
inner join orders o on c.customer_id = o.customer_id
where o.total_amount > (
	select avg(total_amount)
    from orders
)
order by o.total_amount, o.order_date;

-- Show products more expensive than the average product price.
select *
from products
where price > (
	select avg(price)
    from products
)
order by price;

-- Find employees in departments with more than 1 people.
select concat(e.first_name, ' ', e.last_name) as employee_name,
		e.email,
        e.phone,
        d.department_name as employee_department
from employees e
join departments d on e.department_id = d.department_id
where d.department_id in (
	select department_id
	from employees
    group by department_id
	having count(*) > 1
);

-- List customers from cities where we have the most customers.
select 
  concat(first_name, ' ', last_name) as customer_name,
  city
from customers
where city in (
  select city
  from customers
  group by city
  having count(*) = (
    select max(city_count)
    from (
      select city, count(*)as city_count
      from customers
      group by city
    ) as city_counts
  )
);

-- Show products from categories with more than 10 products.
select *
from products
where category_id in (
	select category_id 
    from products 
    group by category_id 
    having count(*) > 10
);

-- Find orders with total_amount above average.
select *
from orders
where total_amount > (
	select avg(total_amount)
    from orders
);

-- List employees with salary higher than their department average.
select *
from employees e
where salary > (
	select avg(salary)
	from employees
	where department_id = e.department_id
);

-- Show customers with more orders than average customer.
select 
  c.customer_id,
  concat(c.first_name, ' ', c.last_name) as customer_name,
  count(o.order_id) as total_orders
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.first_name, c.last_name
having count(o.order_id) > (
  select avg(order_count)
  from (
    select customer_id, count(order_id) as order_count
    from orders
    group by customer_id
  ) as customer_orders
);

-- Find products with stock below average stock level.
select *
from products 
where stock_quantity > (
	select avg(stock_quantity)
	from products
);

-- List employees hired after the average hire date.
select *
from employees
where hire_date > (
	select avg(hire_date)
	from employees
);

-- Show orders from customers with above-average total spending.
select *
from orders
where total_amount > (
	select avg(total_amount)
    from orders
);

-- Find products with prices above their category average.
select *
from products p1
where price > (
	select avg(price)
    from products p2
    where p2.category_id = p1.category_id
);

-- List customers from the most popular countries (top 3).
select *
from customers
where country in (
	select country
    from customers
    group by country
    order by count(*) desc
    limit 3
);

-- The above query does not execute in MySQL versions < 8.0, go through below one

select *
from customers c
join (
	select country
    from customers
    group by country
    order by count(*) desc
    limit 3
)top_countries on c.country = top_countries.country
order by c.country;

-- Show employees from departments with highest average salary.
select e.*
from employees e
join(
	select department_id
	from employees
	group by department_id
	order by avg(salary) desc
	limit 1
)highest_paid on e.department_id = highest_paid.department_id;

-- Find orders placed in months with above-average order counts.
select o.*
from orders o
where month(order_date) in (
  select order_month
  from (
    select 
      month(order_date) as order_month,
      count(*) as order_count
    from orders
    group by month(order_date)
  ) monthly_counts
  where order_count > (
    select avg(monthly_order_count)
    from (
      select count(*) as monthly_order_count
      from orders
      group by month(order_date)
    ) all_months
  )
);
-- Explanation:
	-- Inner Derived Table (all_months):
	-- 		Gets order counts per month.
	-- 		Calculates average monthly order count.
	-- 	Middle Derived Table (monthly_counts):
	-- 		Filters months with above-average order counts.
	-- 	Main Query:
	-- 		Returns all orders from those above-average months.

-- List products from suppliers with most products.
select p.*
from products p
join (
	select supplier_id
	from products
	group by supplier_id
    order by count(*) desc
    limit 1
)top_supplier on p.supplier_id = top_supplier.supplier_id;

-- Show customers who ordered the most expensive products.
select distinct
	c.customer_id,
    concat(c.first_name, ' ', c.last_name) as customer_name,
	c.email,
	p.product_name,
	p.price
from customers c
join orders o on c.customer_id = o.customer_id
join order_details od on o.order_id = od.order_id
join products p on od.product_id = p.product_id
where p.price = (
  select max(price) 
  from products
);

-- Find employees with salaries in top 10% of company.
-- 1. Using a fixed number of employees
select *
from employees
where salary >= (
    select min(salary)
    from (
        select salary
        from employees
        order by salary desc
        limit 3 -- 3 is a variable
    ) as top_salaries
);
-- replace the variable value 3 with 10% value of the total number of employees
-- 2. Using 10% of the total number of employees (for MySQL version > 8.0)
select *
from employees
where salary >= (
  select min(salary)
  from (
    select salary
    from employees
    order by salary desc
    limit (
      select ceil(count(*) * 0.1)
      from employees
    )
  ) as top_10_percent
);
-- 3. Using window function (percent_rank)
select *
from (
    select *, percent_rank() over (order by salary desc) as salary_rank
    from employees
) as ranked
where salary_rank <= 0.10;

-- List orders with quantities above average order quantity.
select o.order_id, od.product_id, od.quantity
from order_details od
join orders o on o.order_id = od.order_id
where od.quantity > (
  select avg(quantity)
  from order_details
);
