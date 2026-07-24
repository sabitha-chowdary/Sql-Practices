USE sql_practice;

-- Create a basic index on the email column in customers
CREATE INDEX idx_customers_email ON customers(email);
show index from customers;

-- Create a composite index on last_name and first_name in employees
CREATE INDEX idx_employees_name ON employees(last_name, first_name);
show index from employees;

-- Drop an existing index
DROP INDEX idx_customers_email ON customers;
show index from customers;

-- View all indexes on a table
SHOW INDEX FROM customers;

-- Check performance difference using EXPLAIN with and without index
EXPLAIN SELECT * FROM customers WHERE email = 'anita.verma@email.com';

-- Add a unique index to email in customers
CREATE UNIQUE INDEX idx_customers_email ON customers(email); -- already created
SHOW INDEX FROM customers;

-- Create a full-text index on description in products
CREATE FULLTEXT INDEX idx_products_description ON products(description);
SHOW INDEX FROM products WHERE Key_name = 'idx_products_description';

-- Add an index only to optimize SELECT but not INSERT
-- (Note: All indexes optimize SELECT but slow down INSERT/UPDATE. Choose indexes wisely.)

-- Create a hash index (if supported by DBMS and engine)
-- (In MySQL, MEMORY engine supports HASH index by default)
	-- Example: 
	-- 1st Method:
	CREATE TABLE example_hash (
		id INT,
		name VARCHAR(50),
		INDEX USING HASH (name)
	) ENGINE=MEMORY;

	-- 2nd Method
	-- Step 1: Create the table using the MEMORY engine
	CREATE TABLE example_hash (
		id INT,
		name VARCHAR(50)
	) ENGINE=MEMORY;
	-- Step 2: Create a HASH index on the 'name' column
	CREATE INDEX idx_name_hash ON example_hash (name) USING HASH;
SHOW INDEX FROM example_hash;

-- Use EXPLAIN ANALYZE to inspect index scan vs full scan
EXPLAIN ANALYZE SELECT * FROM customers WHERE email = 'anita.verma@email.com'; -- (MySQL 8.0+)

-- Create a non-clustered index on order_date
-- (MySQL uses InnoDB where all indexes except PRIMARY KEY are non-clustered)
CREATE INDEX idx_orders_order_date ON orders(order_date);

-- Create an index on a foreign key column
CREATE INDEX idx_orders_customer_id ON orders(customer_id);

-- Practice multi-column WHERE clause that benefits from index
-- (Query that uses composite index)
EXPLAIN SELECT * FROM employees WHERE last_name = 'Doe' AND first_name = 'John';

-- Force the use of a specific index (if allowed in DBMS)
SELECT * FROM customers USE INDEX (idx_customers_email) WHERE email = 'ben.taylor@email.com';

-- Drop and re-create the most beneficial index on orders
DROP INDEX idx_orders_order_date ON orders;
CREATE INDEX idx_orders_order_date ON orders(order_date);
