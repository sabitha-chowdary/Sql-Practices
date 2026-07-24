USE sql_practice;


-- Create customer segmentation based on multiple criteria.
with customer_orders as (
  select 
    c.customer_id,
    concat(c.first_name, ' ', c.last_name) as customer_name,
    count(o.order_id) as total_orders,
    coalesce(sum(o.total_amount), 0) as total_spent,
    max(o.order_date) as last_order_date,
    datediff(curdate(), max(o.order_date)) as days_since_last_order
  from customers c
  left join orders o on c.customer_id = o.customer_id
  group by c.customer_id
),
segmented_customers as (
  select *,
    case 
      when total_spent > 10000 and total_orders >= 10 and days_since_last_order <= 60 then 'vip'
      when total_spent between 5000 and 10000 then 'loyal'
      when total_orders between 1 and 4 then 'new'
      when total_orders = 0 then 'inactive'
      else 'regular'
    end as customer_segment
  from customer_orders
)
select * 
from segmented_customers
order by customer_segment, total_spent desc;


-- Find supplier performance metrics.
with supplier_sales as (
  select 
    s.supplier_id,
    s.supplier_name,
    sum(od.quantity * od.unit_price) as total_sales_value
  from suppliers s
  join products p on p.supplier_id = s.supplier_id
  join order_details od on od.product_id = p.product_id
  group by s.supplier_id, s.supplier_name
),
product_counts as (
  select 
    supplier_id,
    count(*) as total_products
  from products
  group by supplier_id
),
order_counts as (
  select 
    p.supplier_id,
    count(distinct od.order_id) as total_orders
  from products p
  join order_details od on od.product_id = p.product_id
  group by p.supplier_id
)
select 
  ss.supplier_id,
  ss.supplier_name,
  coalesce(pc.total_products, 0) as total_products,
  coalesce(oc.total_orders, 0) as total_orders,
  coalesce(ss.total_sales_value, 0) as total_sales_value
from supplier_sales ss
left join product_counts pc on ss.supplier_id = pc.supplier_id
left join order_counts oc on ss.supplier_id = oc.supplier_id
order by total_sales_value desc;


-- Find seasonal adjustment factors for products.
with monthly_sales as (
  select 
    p.product_id,
    p.product_name,
    month(o.order_date) as sale_month,
    sum(od.quantity) as monthly_quantity
  from orders o
  join order_details od on o.order_id = od.order_id
  join products p on p.product_id = od.product_id
  group by p.product_id, p.product_name, month(o.order_date)
),
avg_monthly_sales as (
  select 
    product_id,
    avg(monthly_quantity) as avg_quantity
  from monthly_sales
  group by product_id
)
select 
  ms.product_id,
  ms.product_name,
  ms.sale_month,
  ms.monthly_quantity,
  a.avg_quantity,
  round(ms.monthly_quantity / nullif(a.avg_quantity, 0), 2) as seasonal_factor
from monthly_sales ms
join avg_monthly_sales a on ms.product_id = a.product_id
order by ms.product_id, ms.sale_month;


-- Create complex pricing analysis.
with price_analysis as (
  select
    p.product_id,
    p.product_name,
    month(o.order_date) as sale_month,
    year(o.order_date) as sale_year,    
    p.price as listed_price,
    od.unit_price,
    od.discount,    
    round(od.unit_price * (1 - od.discount / 100), 2) as effective_price, -- price after discount
    round(p.price - od.unit_price * (1 - od.discount / 100), 2) as price_diff -- price difference and margin
  from order_details od
  join orders o on o.order_id = od.order_id
  join products p on p.product_id = od.product_id
)
select
  product_id,
  product_name,
  sale_year,
  sale_month,
  count(*) as total_sales,
  round(avg(listed_price), 2) as avg_listed_price,
  round(avg(unit_price), 2) as avg_ordered_price,
  round(avg(effective_price), 2) as avg_effective_price,
  round(avg(discount), 2) as avg_discount_pct,
  round(avg(price_diff), 2) as avg_margin_per_unit
from price_analysis
group by product_id, product_name, sale_year, sale_month
order by sale_year, sale_month, product_name;


-- Find market share by product category.
with category_sales as (
  select 
    c.category_id,
    c.category_name,
    sum(od.quantity * od.unit_price * (1 - ifnull(od.discount, 0) / 100)) as total_category_sales
  from order_details od
  join products p on p.product_id = od.product_id
  join categories c on c.category_id = p.category_id
  group by c.category_id, c.category_name
),
total_sales as (
  select sum(total_category_sales) as overall_sales from category_sales
)
select 
  cs.category_name,
  round(cs.total_category_sales, 2) as category_sales,
  round((cs.total_category_sales / ts.overall_sales) * 100, 2) as market_share_percentage
from category_sales cs
cross join total_sales ts
order by market_share_percentage desc;
