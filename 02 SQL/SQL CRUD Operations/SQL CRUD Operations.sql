-- SQL CRUD Operations

-- EP01 - Create Table & Insert Data 
-- ตอนเราสร้าง employee table เรากำหนดคอลัมน์ id เป็น UNIQUE แปลว่าคอลัมนี้ห้ามใส่ข้อมูลซ้ำนะครับ ถ้าเราพยายาม insert into คอลัมน์นี้ด้วยไอดีที่มีอยู่แล้ว SQLite จะฟ้อง error UNIQUE Constraint ขึ้นมา
-- create table employee
CREATE TABLE employee (
		id INT UNIQUE,
  	name TEXT,
  	department TEXT,
  	position TEXT,
  	salary REAL
);

-- insert data into employee
INSERT INTO employee VALUES 
	(1, 'David', 'Marketing', 'CEO', 100000),
  (2, 'John' , 'Marketing', 'VP', 85000 ),
  (3, 'Marry', 'Sales', 'Manager', 60000); 
    
INSERT INTO employee VALUES 
	(4, 'Harry', 'IT', 'Senior Manager', 88000),
  (5, 'Walker', 'IT', 'Manager', 68000); 
    
-- select all columns from employee
SELECT * FROM employee;

--EP02 - Select Data
-- select all column
SELECT * FROM employee;

-- select column ที่เราต้องการ
SELECT 
	id,
	name, 
	salary
FROM employee;

-- select column ที่เราต้องการ + ลิมิตของข้อมูลที่ต้องการทราบ
SELECT 
	id,
	name, 
	salary
FROM employee
LIMIT 1;

-- EP03 - Transform Column
--Transform Column with LOWER Case
SELECT
	name,
	salary,
	salary * 1.15 AS new_salary
	LOWER(name) || '@company.com' AS company_email
FROM employee;

-- Transform Column with UPPER Case 
SELECT
	name,
	salary,
	salary * 1.15 AS new_salary
	UPPER(name) || '@company.com' AS company_email
FROM employee;

-- EP04 - Filter Data
-- Normal form
SELECT * FROM employee
WHERE department = 'Marketing' AND salary >= 90000;

SELECT * FROM employee
WHERE department = 'Marketing' OR salary >= 90000;

SELECT * FROM employee
WHERE salary = 60000;

-- IN operator
SELECT * FROM employee
WHERE department IN ('Markerting' , 'IT');

-- EP05 - Update Data
UPDATE emoployee
SET salary = 90000
WHERE id = 1;

SELECT * FROM employee;

-- EP06 - Delete Data
-- Delete single Data
DELETE FROM employee
WHERE name = 'Walker';

SELECT * FROM employee;

-- Delete many Data
DELETE FROM employee
WHERE id IN (2,4);

SELECT * FROM employee;

-- Delete All Data
DELETE FROM employee;

-- EP07 - Alter Table (เปลี่ยนชื่อ table)
-- เปลี่ยนชื่อ table จาก employee เป็น Myemployee

ALTER TABLE employee RENAME TO Myemployee
ADD email TEXT;

-- Update data in employee

UPDATE Myemployee
SET email = 'admin@company.com'

SELECT * FROM Myemployee;

-- Update data in id

SET email = 'ceo@company.com'
WHERE id = 1;

SELECT * FROM Myemployee;

-- EP08 - Copy & Drop Table
-- ก่อนจะ DROP TABLE ต้องคิดดีๆก่อนนะครับ เพราะว่าลบแล้ว table จะหายไปเลย ไม่สามารถเรียกกลับมาได้ (undo) นอกจาก database admin จะมีการ backup ข้อมูลเอาไว้
-- Copy Table
CREATE TABLE Myemployee_Backup AS
SELECT * FROM Myemployee;

-- Drop Table (delete table)
DROP TABLE Myemployee_Backup;