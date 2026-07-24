USE sql_practice;

-- create an after insert trigger on orders to log activity
delimiter //
create trigger trg_log_order_insert
after insert on orders
for each row
begin
  insert into log_table (procedure_name, run_time, message)
  values ('trg_log_order_insert', now(), concat('order id ', new.order_id, ' inserted.'));
end;
//
delimiter ;

-- create a before update trigger to prevent salary decrease
delimiter //
create trigger trg_prevent_salary_cut
before update on employees
for each row
begin
  if new.salary < old.salary then
    signal sqlstate '45000' set message_text = 'salary decrease not allowed';
  end if;
end;
//
delimiter ;

-- create a before delete trigger to backup data to archive table
create table if not exists employees_archive like employees;

delimiter //
create trigger trg_backup_before_delete
before delete on employees
for each row
begin
  insert into employees_archive select * from employees where employee_id = old.employee_id;
end;
//
delimiter ;

-- create a trigger to auto-update stock after order is placed
delimiter //
create trigger trg_update_stock_after_order
after insert on order_details
for each row
begin
  update products
  set stock_quantity = stock_quantity - new.quantity
  where product_id = new.product_id;
end;
//
delimiter ;

-- view existing triggers on a table
show triggers where `table` = 'orders';

-- drop a trigger
drop trigger if exists trg_log_order_insert;

-- create a trigger to calculate total_amount before insert
delimiter //
create trigger trg_calc_total_amount
before insert on orders
for each row
begin
  declare order_total decimal(10,2);
  select sum(quantity * unit_price) into order_total
  from order_details
  where order_id = new.order_id;
  set new.total_amount = ifnull(order_total, 0.00);
end;
//
delimiter ;

-- add validation logic in a trigger
delimiter //
create trigger trg_validate_email
before insert on customers
for each row
begin
  if new.email not like '%@%.%' then
    signal sqlstate '45000' set message_text = 'invalid email format';
  end if;
end;
//
delimiter ;

-- prevent deletion of vip customers using a trigger
delimiter //
create trigger trg_block_vip_delete
before delete on customers
for each row
begin
  if old.email like '%vip%' then
    signal sqlstate '45000' set message_text = 'vip customers cannot be deleted';
  end if;
end;
//
delimiter ;

-- prevent insert if order_date is in the future
delimiter //
create trigger trg_prevent_future_order
before insert on orders
for each row
begin
  if new.order_date > curdate() then
    signal sqlstate '45000' set message_text = 'future order dates are not allowed';
  end if;
end;
//
delimiter ;

-- update audit table with trigger on employee changes
create table if not exists employee_audit (
  id int auto_increment primary key,
  employee_id int,
  action varchar(20),
  change_time datetime
);

delimiter //
create trigger trg_employee_audit
after update on employees
for each row
begin
  insert into employee_audit(employee_id, action, change_time)
  values (old.employee_id, 'update', now());
end;
//
delimiter ;

-- cascade update using a trigger (if foreign keys not used)
delimiter //
create trigger trg_cascade_department_name
after update on departments
for each row
begin
  update employees
  set job_title = replace(job_title, old.department_name, new.department_name)
  where department_id = new.department_id;
end;
//
delimiter ;

-- create a trigger to sync data between two tables
-- (assuming a mirror table exists: customers_backup)
delimiter //
create trigger trg_sync_customer_data
after insert on customers
for each row
begin
  insert into customers_backup select * from customers where customer_id = new.customer_id;
end;
//
delimiter ;

-- create a conditional trigger that only runs on specific conditions
delimiter //
create trigger trg_high_value_order_flag
after insert on orders
for each row
begin
  if new.total_amount > 10000 then
    insert into log_table(procedure_name, run_time, message)
    values ('trg_high_value_order_flag', now(), concat('high-value order placed: ', new.order_id));
  end if;
end;
//
delimiter ;
