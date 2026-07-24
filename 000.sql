SHOW DATABASES;

CREATE DATABASE sql_practice;

USE sql_practice;

SHOW TABLES;

-- Departments Table
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100),
    location VARCHAR(100),
    budget DECIMAL(15, 2)
);

-- Suppliers Table
CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(100),
    contact_name VARCHAR(100),
    phone VARCHAR(15),
    email VARCHAR(100) UNIQUE,
    address TEXT,
    city VARCHAR(50),
    country VARCHAR(50)
);

-- Categories Table
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100),
    description TEXT
);

-- Customers Table
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    address TEXT,
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    postal_code VARCHAR(20),
    registration_date DATE
);

-- Employees Table
CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    hire_date DATE,
    job_title VARCHAR(50),
    salary DECIMAL(10, 2),
    department_id INT,
    manager_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

-- Products Table
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100),
    description TEXT,
    category_id INT,
    price DECIMAL(10, 2),
    stock_quantity INT,
    supplier_id INT,
    created_date DATE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

-- Orders Table
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status VARCHAR(50),
    total_amount DECIMAL(10, 2),
    shipping_address TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Order Details Table
CREATE TABLE order_details (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10, 2),
    discount DECIMAL(5, 2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert Data into Departments Table
INSERT INTO departments (department_name, location, budget)
VALUES 
('Sales', 'Mumbai', 5000000.00),
('HR', 'Bangalore', 3000000.00),
('IT', 'Delhi', 8000000.00),
('Finance', 'Chennai', 6000000.00),
('Marketing', 'Hyderabad', 4000000.00),
('Customer Support', 'Pune', 2000000.00),
('Operations', 'Kolkata', 7000000.00),
('R&D', 'Noida', 5500000.00),
('Logistics', 'Ahmedabad', 4500000.00),
('Legal', 'Gurugram', 3500000.00);

-- Insert Data into Suppliers Table
INSERT INTO suppliers (supplier_name, contact_name, phone, email, address, city, country)
VALUES
('Tech Global', 'John Smith', '234-567-8901', 'john@techglobal.com', '123 Tech Street', 'San Francisco', 'USA'),
('European Fashion', 'Marie Dubois', '345-678-9012', 'marie@europeanfashion.com', '456 Fashion Ave', 'Paris', 'France'),
('Nordic Furniture', 'Lars Andersen', '456-789-0123', 'lars@nordicfurniture.com', '789 Design Blvd', 'Stockholm', 'Sweden'),
('PlayWorld Toys', 'Emma Wilson', '567-890-1234', 'emma@playworld.com', '321 Play Street', 'London', 'UK'),
('Global Beverages', 'Carlos Rodriguez', '678-901-2345', 'carlos@globalbev.com', '654 Drink Ave', 'Barcelona', 'Spain'),
('Sports International', 'Hans Mueller', '789-012-3456', 'hans@sportsintl.com', '987 Athletic Way', 'Berlin', 'Germany'),
('Beauty Essentials', 'Sophia Rossi', '890-123-4567', 'sophia@beautyessentials.com', '147 Beauty Lane', 'Milan', 'Italy'),
('World Books', 'Takeshi Yamada', '901-234-5678', 'takeshi@worldbooks.com', '258 Library St', 'Tokyo', 'Japan'),
('Precious Gems', 'Isabella Santos', '012-345-6789', 'isabella@preciousgems.com', '369 Jewel Road', 'Rio de Janeiro', 'Brazil'),
('Auto Parts Global', 'David Brown', '123-456-7890', 'david@autopartsglobal.com', '741 Motor Ave', 'Detroit', 'USA'),
('Tech India', 'Ravi Shankar', '9834567890', 'ravi@techindia.com', '120, Vasant Vihar', 'Delhi', 'India'),
('FashionWorld', 'Anjali Desai', '9823456789', 'anjali@fashionworld.com', '15, Fashion Street', 'Mumbai', 'India');

-- Insert Data into Categories Table
INSERT INTO categories (category_name, description)
VALUES
('Electronics', 'Gadgets, mobile phones, computers, and accessories'),
('Clothing', 'Men''s and women''s apparel and fashion accessories'),
('Furniture', 'Home and office furniture for all spaces'),
('Toys', 'Toys and games for children of all ages'),
('Food & Beverages', 'Groceries, snacks, drinks, and gourmet items'),
('Sports', 'Sporting goods and equipment for all activities'),
('Beauty & Personal Care', 'Cosmetics, skincare, hair care and wellness products'),
('Books', 'Fiction, non-fiction, educational and reference books'),
('Jewelry', 'Gold, silver, diamonds and precious stone jewelry'),
('Automotive', 'Car accessories, tools and maintenance products');

-- Insert Data into Customers Table (Including your new international customers)
INSERT INTO customers (first_name, last_name, email, phone, address, city, state, country, postal_code, registration_date)
VALUES
('Rajesh', 'Kumar', 'rajesh.kumar@email.com', '9934567890', '1234 MG Road', 'Mumbai', 'Maharashtra', 'India', '400001', '2021-05-10'),
('Anita', 'Verma', 'anita.verma@email.com', '9009876543', '12, LBS Nagar', 'Delhi', 'Delhi', 'India', '110001', '2020-07-22'),
('Pooja', 'Sharma', 'pooja.sharma@email.com', '9812345678', '234 Green Street', 'Bangalore', 'Karnataka', 'India', '560001', '2022-03-11'),
('Sandeep', 'Reddy', 'sandeep.reddy@email.com', '9812341234', '567 M.G Road', 'Hyderabad', 'Telangana', 'India', '500001', '2019-01-30'),
('Maya', 'Joshi', 'maya.joshi@email.com', '9887654321', '786 Main Road', 'Chennai', 'Tamil Nadu', 'India', '600001', '2021-08-25'),
('Maria', 'Garcia', 'maria.garcia@email.com', '234-567-8901', '456 Oak St', 'Madrid', '', 'Spain', '28001', '2025-06-23'),
('Michael', 'Johnson', 'michael.j@email.com', '345-678-9012', '789 Pine St', 'Berlin', '', 'Germany', '10115', '2025-06-22'),
('Emily', 'Williams', 'emily.w@email.com', '456-789-0123', '101 Birch Rd', 'London', '', 'UK', 'E1 6AN', '2025-06-21'),
('James', 'Brown', 'james.brown@email.com', '567-890-1234', '202 Cedar Ln', 'Sydney', '', 'Australia', '2000', '2025-06-20'),
('Olivia', 'Jones', 'olivia.jones@email.com', '678-901-2345', '303 Redwood Dr', 'Toronto', '', 'Canada', 'M5A 1A1', '2025-06-19'),
('Liam', 'Davis', 'liam.davis@email.com', '789-012-3456', '404 Elm St', 'Auckland', '', 'New Zealand', '1010', '2025-06-18'),
('Sophia', 'Miller', 'sophia.miller@email.com', '890-123-4567', '505 Willow Ave', 'Paris', '', 'France', '75001', '2025-06-17'),
('Benjamin', 'Taylor', 'ben.taylor@email.com', '901-234-5678', '606 Fir St', 'Tokyo', '', 'Japan', '100-0001', '2025-06-16'),
('Ava', 'Anderson', 'ava.anderson@email.com', '012-345-6789', '707 Chestnut Blvd', 'Rome', '', 'Italy', '00100', '2025-06-15'),
('Anna', 'Martinez', 'anna.martinez@email.com', '234-567-8901', '456 Oak St', 'Barcelona', '', 'Spain', '08001', '2025-06-23'),
('Lukas', 'Schmidt', 'lukas.schmidt@email.com', '345-678-9012', '789 Pine St', 'Berlin', '', 'Germany', '10115', '2025-06-22'),
('Olivia', 'Brown', 'olivia.brown@email.com', '456-789-0123', '101 Birch Rd', 'London', '', 'United Kingdom', 'E1 6AN', '2025-06-21'),
('Jack', 'Wilson', 'jack.wilson@email.com', '567-890-1234', '202 Cedar Ln', 'Sydney', '', 'Australia', '2000', '2025-06-20'),
('Sophia', 'Nguyen', 'sophia.nguyen@email.com', '678-901-2345', '303 Redwood Dr', 'Toronto', '', 'Canada', 'M5A 1A1', '2025-06-19'),
('Max', 'Johnson', 'max.johnson@email.com', '789-012-3456', '404 Elm St', 'Auckland', '', 'New Zealand', '1010', '2025-06-18'),
('Chloe', 'Martin', 'chloe.martin@email.com', '890-123-4567', '505 Willow Ave', 'Paris', '', 'France', '75001', '2025-06-17'),
('Taro', 'Yamamoto', 'taro.yamamoto@email.com', '901-234-5678', '606 Fir St', 'Tokyo', '', 'Japan', '100-0001', '2025-06-16'),
('Giulia', 'Rossi', 'giulia.rossi@email.com', '012-345-6789', '707 Chestnut Blvd', 'Rome', '', 'Italy', '00100', '2025-06-15'),
('Carlos', 'Fernandez', 'carlos.fernandez@email.com', '345-678-9012', '789 Maple St', 'Lisbon', '', 'Portugal', '1100-123', '2025-06-14'),
('Isabella', 'Kovacs', 'isabella.kovacs@email.com', '234-567-8901', '123 Elm St', 'Budapest', '', 'Hungary', '1012', '2025-06-13'),
('Tom', 'Wang', 'tom.wang@email.com', '456-789-0123', '321 Oak Rd', 'Beijing', '', 'China', '100000', '2025-06-12'),
('Eva', 'Pérez', 'eva.perez@email.com', '567-890-1234', '654 Birch St', 'Madrid', '', 'Spain', '28003', '2025-06-11'),
('Chris', 'Taylor', 'chris.taylor@email.com', '678-901-2345', '123 Chestnut Blvd', 'Manchester', '', 'UK', 'M1 2AP', '2025-06-10');

-- Insert Data into Employees Table
INSERT INTO employees (first_name, last_name, email, phone, hire_date, job_title, salary, department_id, manager_id)
VALUES
('Amit', 'Sharma', 'amit.sharma@company.com', '9876543210', '2020-05-15', 'Sales Director', 120000.00, 1, NULL),
('Ravi', 'Kumar', 'ravi.kumar@company.com', '9123456789', '2019-02-10', 'HR Manager', 95000.00, 2, NULL),
('Priya', 'Patel', 'priya.patel@company.com', '9876543234', '2021-06-20', 'Software Architect', 140000.00, 3, NULL),
('Vikas', 'Gupta', 'vikas.gupta@company.com', '9234567890', '2020-11-02', 'Finance Manager', 110000.00, 4, NULL),
('Neha', 'Singh', 'neha.singh@company.com', '9356789012', '2022-01-15', 'Marketing Director', 125000.00, 5, NULL),
('Manoj', 'Joshi', 'manoj.joshi@company.com', '9334567890', '2020-08-30', 'Customer Support Manager', 85000.00, 6, NULL),
('Suman', 'Reddy', 'suman.reddy@company.com', '9456789021', '2021-03-10', 'Operations Manager', 100000.00, 7, NULL),
('Shivani', 'Verma', 'shivani.verma@company.com', '9678901234', '2019-07-25', 'R&D Director', 150000.00, 8, NULL),
('Arun', 'Nair', 'arun.nair@company.com', '9236547890', '2021-11-05', 'Logistics Manager', 90000.00, 9, NULL),
('Rashmi', 'Iyer', 'rashmi.iyer@company.com', '9812345678', '2020-03-18', 'Legal Counsel', 130000.00, 10, NULL),
('Rohit', 'Mehta', 'rohit.mehta@company.com', '9876543211', '2021-07-12', 'Sales Executive', 65000.00, 1, 1),
('Anjali', 'Gupta', 'anjali.gupta@company.com', '9123456788', '2020-09-15', 'HR Executive', 55000.00, 2, 2),
('Kiran', 'Soni', 'kiran.soni@company.com', '9876543235', '2022-02-20', 'Software Engineer', 85000.00, 3, 3),
('Deepak', 'Jain', 'deepak.jain@company.com', '9234567891', '2021-01-10', 'Finance Analyst', 70000.00, 4, 4),
('Pooja', 'Rao', 'pooja.rao@company.com', '9356789011', '2022-04-18', 'Marketing Executive', 60000.00, 5, 5);

-- Insert Data into Products Table
INSERT INTO products (product_name, description, category_id, price, stock_quantity, supplier_id, created_date)
VALUES
('iPhone 14 Pro', 'Latest Apple smartphone with 256GB storage', 1, 89999.99, 150, 1, '2023-09-01'),
('Samsung Galaxy S23', 'Android smartphone with advanced camera', 1, 79999.99, 200, 1, '2023-08-15'),
('MacBook Air M2', 'Apple laptop with M2 chip', 1, 129999.99, 75, 1, '2023-07-20'),
('Dell XPS 13', 'Premium Windows laptop', 1, 99999.99, 100, 11, '2023-06-10'),
('AirPods Pro', 'Wireless earbuds with noise cancellation', 1, 24999.99, 300, 1, '2023-05-15'),
('Premium Suit', 'Men''s formal business suit', 2, 15999.99, 50, 2, '2023-08-01'),
('Designer Dress', 'Women''s evening dress', 2, 8999.99, 80, 2, '2023-07-15'),
('Casual Jeans', 'Comfortable denim jeans', 2, 3999.99, 200, 12, '2023-06-20'),
('Silk Blouse', 'Women''s silk blouse', 2, 5999.99, 120, 2, '2023-05-10'),
('Leather Jacket', 'Genuine leather jacket', 2, 12999.99, 60, 2, '2023-04-25'),
('Executive Desk', 'Premium wooden office desk', 3, 25999.99, 40, 3, '2023-07-01'),
('Ergonomic Chair', 'High-end office chair with lumbar support', 3, 18999.99, 80, 3, '2023-06-15'),
('Leather Sofa', '3-seater genuine leather sofa', 3, 45999.99, 25, 3, '2023-05-20'),
('Dining Table Set', '6-seater dining table with chairs', 3, 35999.99, 30, 3, '2023-04-10'),
('Bookshelf', 'Wooden bookshelf with 5 shelves', 3, 8999.99, 70, 3, '2023-03-15'),
('LEGO Creator Expert', 'Advanced LEGO building set', 4, 12999.99, 100, 4, '2023-08-20'),
('Remote Control Car', 'High-speed RC car with camera', 4, 5999.99, 150, 4, '2023-07-10'),
('Educational Robot', 'Programming robot for kids', 4, 8999.99, 80, 4, '2023-06-05'),
('Board Game Collection', 'Set of classic board games', 4, 3999.99, 200, 4, '2023-05-25'),
('Art Supplies Kit', 'Complete drawing and painting kit', 4, 2999.99, 180, 4, '2023-04-15'),
('Premium Coffee Beans', 'Arabica coffee beans 1kg', 5, 1999.99, 500, 5, '2023-08-10'),
('Organic Honey', 'Pure organic honey 500g', 5, 899.99, 300, 5, '2023-07-25'),
('Gourmet Chocolate', 'Belgian dark chocolate collection', 5, 2499.99, 200, 5, '2023-06-30'),
('Protein Powder', 'Whey protein supplement 2kg', 5, 3999.99, 150, 5, '2023-05-15'),
('Green Tea', 'Premium green tea leaves 250g', 5, 699.99, 400, 5, '2023-04-20');

-- Insert Data into Orders Table
INSERT INTO orders (customer_id, order_date, status, total_amount, shipping_address)
VALUES
(1, '2023-08-15', 'Delivered', 89999.99, '1234 MG Road, Mumbai, Maharashtra, India'),
(2, '2023-07-20', 'Delivered', 25999.99, '12, LBS Nagar, Delhi, India'),
(3, '2023-06-25', 'Shipped', 15999.99, '234 Green Street, Bangalore, Karnataka, India'),
(4, '2023-05-30', 'Delivered', 12999.99, '567 M.G Road, Hyderabad, Telangana, India'),
(5, '2023-04-15', 'Delivered', 8999.99, '786 Main Road, Chennai, Tamil Nadu, India'),
(6, '2025-06-20', 'Processing', 129999.99, '456 Oak St, Madrid, Spain'),
(7, '2025-06-19', 'Shipped', 79999.99, '789 Pine St, Berlin, Germany'),
(8, '2025-06-18', 'Delivered', 45999.99, '101 Birch Rd, London, UK'),
(9, '2025-06-17', 'Processing', 18999.99, '202 Cedar Ln, Sydney, Australia'),
(10, '2025-06-16', 'Shipped', 24999.99, '303 Redwood Dr, Toronto, Canada'),
(11, '2025-06-15', 'Delivered', 35999.99, '404 Elm St, Auckland, New Zealand'),
(12, '2025-06-14', 'Processing', 8999.99, '505 Willow Ave, Paris, France'),
(13, '2025-06-13', 'Shipped', 5999.99, '606 Fir St, Tokyo, Japan'),
(14, '2025-06-12', 'Delivered', 12999.99, '707 Chestnut Blvd, Rome, Italy'),
(15, '2025-06-11', 'Processing', 25999.99, '456 Oak St, Barcelona, Spain'),
(16, '2025-06-10', 'Shipped', 89999.99, '789 Pine St, Berlin, Germany'),
(17, '2025-06-09', 'Delivered', 3999.99, '101 Birch Rd, London, United Kingdom'),
(18, '2025-06-08', 'Processing', 15999.99, '202 Cedar Ln, Sydney, Australia'),
(19, '2025-06-07', 'Shipped', 8999.99, '303 Redwood Dr, Toronto, Canada'),
(20, '2025-06-06', 'Delivered', 12999.99, '404 Elm St, Auckland, New Zealand'),
(21, '2025-06-05', 'Processing', 5999.99, '505 Willow Ave, Paris, France'),
(22, '2025-06-04', 'Shipped', 24999.99, '606 Fir St, Tokyo, Japan'),
(23, '2025-06-03', 'Delivered', 18999.99, '707 Chestnut Blvd, Rome, Italy'),
(24, '2025-06-02', 'Processing', 2999.99, '789 Maple St, Lisbon, Portugal'),
(25, '2025-06-01', 'Shipped', 8999.99, '123 Elm St, Budapest, Hungary'),
(26, '2025-05-31', 'Delivered', 12999.99, '321 Oak Rd, Beijing, China'),
(27, '2025-05-30', 'Processing', 3999.99, '654 Birch St, Madrid, Spain'),
(28, '2025-05-29', 'Shipped', 25999.99, '123 Chestnut Blvd, Manchester, UK');

-- Insert Data into Order Details Table
INSERT INTO order_details (order_id, product_id, quantity, unit_price, discount)
VALUES
(1, 1, 1, 89999.99, 0.00),
(2, 11, 1, 25999.99, 5.00),
(3, 6, 1, 15999.99, 0.00),
(4, 16, 1, 12999.99, 10.00),
(5, 13, 1, 8999.99, 0.00),
(6, 3, 1, 129999.99, 0.00),
(7, 2, 1, 79999.99, 5.00),
(8, 13, 1, 45999.99, 0.00),
(9, 12, 1, 18999.99, 0.00),
(10, 5, 1, 24999.99, 0.00),
(11, 14, 1, 35999.99, 0.00),
(12, 15, 1, 8999.99, 0.00),
(13, 17, 1, 5999.99, 0.00),
(14, 10, 1, 12999.99, 0.00),
(15, 11, 1, 25999.99, 0.00),
(16, 1, 1, 89999.99, 0.00),
(17, 8, 1, 3999.99, 0.00),
(18, 6, 1, 15999.99, 0.00),
(19, 7, 1, 8999.99, 0.00),
(20, 16, 1, 12999.99, 0.00),
(21, 17, 1, 5999.99, 0.00),
(22, 5, 1, 24999.99, 0.00),
(23, 12, 1, 18999.99, 0.00),
(24, 19, 1, 2999.99, 0.00),
(25, 15, 1, 8999.99, 0.00),
(26, 16, 1, 12999.99, 0.00),
(27, 8, 1, 3999.99, 0.00),
(28, 11, 1, 25999.99, 0.00),
(1, 5, 1, 24999.99, 0.00),
(2, 20, 2, 1999.99, 0.00),
(3, 8, 1, 3999.99, 0.00),
(6, 5, 1, 24999.99, 0.00),
(7, 12, 1, 18999.99, 0.00),
(8, 9, 1, 5999.99, 0.00),
(10, 21, 3, 899.99, 0.00),
(15, 4, 1, 99999.99, 0.00),
(16, 3, 1, 129999.99, 0.00),
(20, 18, 1, 8999.99, 0.00);