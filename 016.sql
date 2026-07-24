USE sql_practice;

-- Categorize employees as 'Junior', 'Mid', 'Senior' based on salary.
select 
  employee_id,
  concat(first_name, ' ', last_name) as employee_name,
  salary,
  case
    when salary < 70000 then 'junior'
    when salary between 70000 and 100000 then 'mid'
    else 'senior'
  end as level
from employees
order by salary desc;


-- Classify orders as 'Small', 'Medium', 'Large' based on total amount.
select 
  order_id,
  customer_id,
  order_date,
  total_amount,
  case
    when total_amount < 100 then 'small'
    when total_amount between 80 and 300 then 'medium'
    else 'large'
  end as order_size
from orders
order by total_amount desc;


-- Categorize products as 'Low Stock', 'Medium Stock', 'High Stock'.
select 
  product_id,
  product_name,
  stock_quantity,
  case
    when stock_quantity < 50 then 'low stock'
    when stock_quantity between 50 and 200 then 'medium stock'
    else 'high stock'
  end as stock_level
from products
order by stock_quantity;


-- Classify customers as 'New', 'Regular', 'VIP' based on order history.
select 
  c.customer_id,
  concat(c.first_name, ' ', c.last_name) as customer_name,
  count(o.order_id) as order_count,
  case
    when count(o.order_id) <= 1 then 'new'
    when count(o.order_id) between 2 and 5 then 'regular'
    else 'vip'
  end as customer_type
from customers c
left join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.first_name, c.last_name
order by order_count desc;


-- Categorize order status into 'Active', 'Completed', 'Problem'.
select 
  order_id,
  order_date,
  status,
  case
    when status in ('pending', 'processing', 'shipped') then 'active'
    when status in ('delivered', 'completed') then 'completed'
    when status in ('cancelled', 'returned', 'failed') then 'problem'
    else 'unknown'
  end as status_category
from orders
order by order_date desc;


-- Create seasonal categories for products based on sales patterns.
with monthly_sales as (
  select 
    p.product_id,
    p.product_name,
    month(o.order_date) as sale_month,
    sum(od.quantity) as total_sold
  from products p
  join order_details od on p.product_id = od.product_id
  join orders o on o.order_id = od.order_id
  group by p.product_id, p.product_name, month(o.order_date)
),
peak_months as (
  select 
    product_id,
    product_name,
    sale_month,
    rank() over (partition by product_id order by total_sold desc) as rnk
  from monthly_sales
),
seasonal_classification as (
  select 
    product_id,
    product_name,
    case
      when sale_month in (3, 4, 5) then 'spring'
      when sale_month in (6, 7, 8) then 'summer'
      when sale_month in (9, 10, 11) then 'fall'
      when sale_month in (12, 1, 2) then 'winter'
    end as peak_season
  from peak_months
  where rnk = 1
)
select *
from seasonal_classification
order by product_name;


-- Create urgency levels for orders based on days since placed.
select 
  o.order_id,
  o.order_date,
  datediff(curdate(), o.order_date) as days_since_order,
  case 
    when datediff(curdate(), o.order_date) > 14 then 'high'
    when datediff(curdate(), o.order_date) between 7 and 14 then 'medium'
    else 'low'
  end as urgency_level
from orders o
order by days_since_order desc;


-- Create price tiers for products within categories.
select 
  p.product_id,
  p.product_name,
  c.category_name,
  p.price,
  case 
    when tier = 1 then 'low'
    when tier = 2 then 'medium'
    when tier = 3 then 'high'
  end as price_tier
from (
  select 
    p.*,
    ntile(3) over (partition by category_id order by price) as tier
  from products p
) p
join categories c on p.category_id = c.category_id
order by c.category_name, p.price;



-- Classify customers by geographic regions.
select 
  customer_id,
  concat(first_name, ' ', last_name) as customer_name,
  country,
  state,
  city,
  case 
    when country in ('united states', 'canada', 'mexico') then 'north america'
    when country in ('united kingdom', 'germany', 'france', 'spain', 'italy') then 'europe'
    when country in ('india', 'china', 'japan', 'south korea') then 'asia'
    when country in ('brazil', 'argentina', 'colombia') then 'south america'
    when country in ('australia', 'new zealand') then 'oceania'
    when country in ('south africa', 'nigeria', 'egypt') then 'africa'
    else 'other'
  end as region
from customers
order by region, customer_name;


-- Create inventory status categories.
select 
  product_id,
  product_name,
  stock_quantity,
  case 
    when stock_quantity < 10 then 'low stock'
    when stock_quantity between 10 and 50 then 'medium stock'
    else 'high stock'
  end as inventory_status
from products;


-- Categorize employees by tenure (New, Experienced, Veteran).
select 
  employee_id,
  concat(first_name, ' ', last_name) as employee_name,
  hire_date,
  timestampdiff(year, hire_date, curdate()) as years_of_service,
  case 
    when timestampdiff(year, hire_date, curdate()) < 2 then 'new'
    when timestampdiff(year, hire_date, curdate()) between 2 and 5 then 'experienced'
    else 'veteran'
  end as tenure_category
from employees;


-- Create order complexity categories based on number of items.
select 
  o.order_id,
  count(od.product_id) as item_count,
  case 
    when count(od.product_id) = 1 then 'simple'
    when count(od.product_id) between 2 and 5 then 'moderate'
    else 'complex'
  end as complexity
from orders o
join order_details od on o.order_id = od.order_id
group by o.order_id;


-- Categorize departments by size and budget.
select 
  d.department_id,
  d.department_name,
  count(e.employee_id) as employee_count,
  d.budget,
  case 
    when count(e.employee_id) > 1 and d.budget > 6000000 then 'large & high budget'
    when count(e.employee_id) > 1 then 'large'
    when d.budget > 1000000 then 'high budget'
    else 'small & low budget'
  end as department_category
from departments d
left join employees e on e.department_id = d.department_id
group by d.department_id;


-- Create sales territory classifications.
select 
  c.city,
  count(o.order_id) as total_orders,
  case 
    when count(o.order_id) >= 5 then 'high sales territory'
    when count(o.order_id) between 2 and 4 then 'moderate sales territory'
    else 'low sales territory'
  end as territory_classification
from customers c
join orders o on o.customer_id = c.customer_id
group by c.city;
