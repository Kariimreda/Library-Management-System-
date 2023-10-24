-- Create the database
use master
CREATE DATABASE library;


-- Use the database
USE library;

-- Create the branches table
CREATE TABLE branches (
  branch_id INT IDENTITY (1, 1) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  address VARCHAR(255),
  phone_number VARCHAR(20),
);

-- Create the books table
CREATE TABLE books (
  book_id INT IDENTITY (1, 1) PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  author VARCHAR(255) NOT NULL,
  publisher VARCHAR(255),
  year_published DATE,-- 00,00,0000
  branch_id INT NOT NULL,
  FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);


-- Create the library_employees table
CREATE TABLE library_employees (
  employees_id INT IDENTITY (1, 1) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255),
  phone_number VARCHAR(20),
  address VARCHAR(255),
  branch_id INT NOT NULL,

  FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

-- Create the borrowers table
CREATE TABLE borrowers (
  borrower_id INT IDENTITY (1, 1) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255),
  phone_number VARCHAR(20),
  address VARCHAR(255),
  branch_id INT NOT NULL,
  FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

-- Create the loans table
CREATE TABLE loans (
  loans_id INT IDENTITY (1, 1) PRIMARY KEY,
  book_id INT NOT NULL,
  borrower_id INT NOT NULL,
  loan_date DATE NOT NULL,
  due_date DATE NOT NULL,
  return_date DATE,
  return_status VARCHAR(20),
  issue_status VARCHAR(20),
  FOREIGN KEY (book_id) REFERENCES books(book_id),
  FOREIGN KEY (borrower_id) REFERENCES borrowers(borrower_id)
);

-- add coulumn
ALTER TABLE library_employees
ADD Salary int ;
SELECT * FROM library_employees;



-- Create a new table to store audit information
CREATE TABLE employee_audit (
  audit_id INT IDENTITY (1, 1) PRIMARY KEY, -- The audit ID is an identity column that auto-increments
  employees_id INT NOT NULL, -- The ID of the employee being audited
  audit_action VARCHAR(20) NOT NULL, -- The type of action being audited (e.g. INSERT, UPDATE, DELETE)
  audit_timestamp DATETIME NOT NULL, -- The date and time the audit record was created
  audit_user VARCHAR(255) NOT NULL -- The name of the user who performed the action being audited
);

-- Create a trigger that fires after an insert operation on the library_employees table
CREATE TRIGGER library_employees_ATI
ON library_employees
AFTER INSERT
AS
BEGIN
  -- Insert a new row into the employee_audit table for each inserted row in the library_employees table
  INSERT INTO employee_audit (employees_id, audit_action, audit_timestamp, audit_user)
  SELECT employees_id, 'INSERT', GETDATE(), SUSER_SNAME()
  FROM inserted;
END;

-- Select all rows from the employee_audit table to view the audit records
SELECT * FROM employee_audit;


-- insert into library employees
INSERT INTO library_employees (name, email, phone_number, address, branch_id)
VALUES
  ('John Doe', 'johndoe@example.com', '555-1234', '123 Main St', 1)
  ('Jane Smith', 'janesmith@example.com', '555-5678', '456 Elm St', 2),
  ('Bob Johnson', 'bjohnson@example.com', '555-9012', '789 Oak St', 1),
  ('Mary Brown', 'mbrown@example.com', '555-3456', '321 Maple St', 2),
  ('Tom Davis', 'tdavis@example.com', '555-7890', '654 Pine St', 2),
  ('Samantha Lee', 'slee@example.com', '555-2345', '987 Cedar St', 1),
  ('David Kim', 'dkim@example.com', '555-6789', '246 Birch St', 2),
  ('Rachel Chen', 'rchen@example.com', '555-0123', '135 Walnut St', 2),
  ('Michael Park', 'mpark@example.com', '555-4567', '864 Ash St', 1)
  select * from library_employees;



-- insert into branches
INSERT INTO branches (name, phone_number, address, employee_count)
VALUES 
  ('Central Library', '555-1234', '123 Main St', 0),
  ('North Branch', '555-5678', '456 Elm St', 0),
  ('South Branch', '555-9012', '789 Oak St', 0),
  ('East Branch', '555-3456', '321 Maple St', 0),
  ('West Branch', '555-7890', '654 Pine St', 0)
  select * from branches;

-- insert into books
INSERT INTO books (title, author, publisher, year_published, branch_id)
VALUES
  ('To Kill a Mockingbird', 'Harper Lee', 'J. B. Lippincott &amp; Co.', '1960-07-11', 1),
  ('1984', 'George Orwell', 'Secker &amp; Warburg', '1949-06-08', 2),
  ('The Great Gatsby', 'F. Scott Fitzgerald', 'Charles Scribner''s Sons', '1925-04-10', 2),
  ('Pride and Prejudice', 'Jane Austen', 'T. Egerton, Whitehall', '1813-01-28', 2),
  ('The Catcher in the Rye', 'J. D. Salinger', 'Little, Brown and Company', '1951-07-16', 1),
  ('Animal Farm', 'George Orwell', 'Secker &amp; Warburg', '1945-08-17', 1),
  ('Brave New World', 'Aldous Huxley', 'Chatto &amp; Windus', '1932-06-14', 2)
    select * from books;

-- insert into borrowers
INSERT INTO borrowers (name, email, phone_number, address, branch_id)
VALUES
  ('John Doe', 'johndoe@example.com', '123-456-7890', '123 Main St, Anytown USA', 1),
  ('Jane Smith', 'janesmith@example.com', '555-555-1212', '456 Elm St, Anytown USA', 2),
  ('Bob Johnson', 'bjohnson@example.com', '555-123-4567', '789 Oak St, Anytown USA', 1),
  ('Samantha Lee', 'slee@example.com', '555-987-6543', '321 Pine St, Anytown USA', 2),
  ('David Kim', 'dkim@example.com', '555-555-5555', '555 Maple St, Anytown USA', 2),
  ('Emily Davis', 'edavis@example.com', '555-555-1234', '777 Cherry St, Anytown USA', 1),
  ('Mark Wilson', 'mwilson@example.com', '555-555-7890', '999 Walnut St, Anytown USA', 2),
  ('Sarah Brown', 'sbrown@example.com', '555-456-7890', '888 Cedar St, Anytown USA', 1)
      select * from borrowers;

-- insert into loans
INSERT INTO loans (book_id, borrower_id, loan_date, due_date, return_date, return_status, issue_status)
VALUES
  (4, 5, '2022-01-01', '2022-01-15', '2022-01-13', 'Returned', 'Issued'),
  (5, 6, '2022-02-02', '2022-02-16', NULL, NULL, 'Issued'),
  (6, 7, '2022-03-03', '2022-03-17', '2022-03-12', 'Returned', 'Issued'),
  (7, 8, '2022-04-04', '2022-04-18', NULL, NULL, 'Issued'),
  (8, 9, '2022-05-05', '2022-05-19', '2022-05-18', 'Returned', 'Issued'),
  (9, 10, '2022-06-06', '2022-06-20', NULL, NULL, 'Issued'),
  (10, 11, '2022-07-07', '2022-07-21', '2022-07-19', 'Returned', 'Issued')
        select * from loans;



-- Create the book_index index on the books table
CREATE INDEX book_index
ON books (title);

-- View information about the book_index index using the sys.indexes view
SELECT *
FROM sys.indexes
WHERE name = 'book_index';



-- Create view for library_employees with employees_id,name , phone_number,address
create view employees_view as
select employees_id,name , phone_number,address from library_employees ;
SELECT * FROM employees_view;


-- Create view for branches table with all columns
create view branches_view
as select * from branches
select * from branches_view

delete from branches_view 
where name = 'mall masr library' 
SELECT * FROM branches_view;

