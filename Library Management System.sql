-- LIBRARY MANAGEMENT SYSTEM --
-- Create a database named Library 
CREATE DATABASE Library;
USE Library;
-- Table - Branch
CREATE TABLE Branch (
    Branch_no INT PRIMARY KEY,
    Manager_Id INT,
    Branch_address VARCHAR(100),
    Contact_no VARCHAR(15)
);
DESC Branch;
-- Inserting data into Branch table
INSERT INTO Branch VALUES
(1, 101, '123 Library Station', '123-456-7890'),
(2, 102, '456 Book Venue', '234-567-8901');
SELECT * FROM Branch;
-- Table - Employee
CREATE TABLE Employee (
    Emp_Id INT PRIMARY KEY,
    Emp_name VARCHAR(50),
    Position VARCHAR(50),
    Salary DECIMAL(10,2),
    Branch_no INT,
    FOREIGN KEY (Branch_no) REFERENCES Branch(Branch_no)
);
DESC Employee;
-- Inserting data into Employee table
INSERT INTO Employee VALUES
(201, 'Nitha', 'Manager', 60000, 1),
(202, 'Jelmy', 'Assistant', 45000, 1),
(203, 'Jimy', 'Manager', 55000, 2),
(204, 'Dhanya', 'Clerk', 30000, 2),
(205, 'Jose', 'Manager', 60000, 1),
(206, 'Rakesh', 'Assistant', 45000, 1),
(207, 'Arun', 'Manager', 55000, 1),
(208, 'Praveen', 'Manager', 55000, 1),
(101, 'Ajoy', 'Manager', 60000, 1),
(102, 'Sajith', 'Manager', 65000, 2);
SELECT * FROM Employee;

-- Table - Books
CREATE TABLE Books (
    ISBN INT PRIMARY KEY,
    Book_title VARCHAR(100),
    Category VARCHAR(100),
    Rental_Price DECIMAL(10,2),
    Status VARCHAR(10),
    Author VARCHAR(100),
    Publisher VARCHAR(100)
);
DESC Books;
-- Inserting data into Books table
INSERT INTO Books VALUES
(1001, 'Indian Culture', 'History', 25.00, 'yes', 'Thomas Sevier', 'Pub1'),
(1002, 'The Art of Cooking', 'Cooking', 15.00, 'no', 'Pankaj', 'Pub2'),
(1003, 'Agricultural Methods', 'Gardening', 20.00, 'yes', 'Theresa', 'Pub3'),
(1004, 'World Around', 'History', 30.00, 'yes', 'Chanakya', 'Pub4'),
(1005, 'History of Japan', 'History', 25.00, 'yes', 'Shiaki', 'Pub5'),
(1006, 'Mygate Hisyory', 'History', 35.00, 'no', 'Sharma', 'Pub6'),
(1007, 'Human History of Africa', 'History', 25.00, 'yes', 'Dhimoka', 'Pub7'),
(1008, 'Raspiratory system in Humans', 'Science', 55.00, 'yes', 'Cathorine', 'Pub8');
SELECT * FROM Books;

-- Table - Customer
CREATE TABLE Customer (
    Customer_Id INT PRIMARY KEY,
    Customer_name VARCHAR(50),
    Customer_address VARCHAR(100),
    Reg_date DATE
);
DESC Customer;
-- Inserting data into Customer table
INSERT INTO Customer VALUES
(301, 'Sandhya', '789 Reader Junction', '2021-12-15'),
(302, 'Meera', '101 Study Apartment', '2022-01-20'),
(303, 'Soumya', 'H-609 Malabar st', '2021-12-15'),
(304, 'Jino', 'M-102 SouthAsia Jn', '2021-11-28');
SELECT * FROM Customer;

-- Table - IssueStatus
CREATE TABLE IssueStatus (
    Issue_Id INT PRIMARY KEY,
    Issued_cust INT,
    Issued_book_name VARCHAR(100),
    Issue_date DATE,
    Isbn_book INT,
    FOREIGN KEY (Issued_cust) REFERENCES Customer(Customer_Id),
    FOREIGN KEY (Isbn_book) REFERENCES Books(ISBN)
);
DESC IssueStatus;
-- Inserting data into IssueStatus table
INSERT INTO IssueStatus VALUES
(401, 301, 'Indian Culture', '2023-06-10', 1001),
(402, 303, 'Raspiratory system in Humans', '2023-07-10', 1008);
SELECT * FROM IssueStatus;

-- Table - ReturnStatus
CREATE TABLE ReturnStatus (
    Return_Id INT PRIMARY KEY,
    Return_cust INT,
    Return_book_name VARCHAR(100),
    Return_date DATE,
    Isbn_book2 INT,
    FOREIGN KEY (Isbn_book2) REFERENCES Books(ISBN)
);
DESC ReturnStatus;
-- Inserting data into ReturnStatus table
INSERT INTO ReturnStatus VALUES
(501, 301, 'Indian Culture', '2023-06-20', 1001);
SELECT * FROM ReturnStatus;

--  1. Retrieve the book title, category, and rental price of all available books.
SELECT Book_title, Category, Rental_Price
FROM Books
WHERE Status = 'yes';

-- 2. List the employee names and their respective salaries in descending order of salary.
SELECT Emp_name, Salary
FROM Employee
ORDER BY Salary DESC;

-- 3. Retrieve the book titles and the corresponding customers who have issued those books. 
SELECT b.Book_title, c.Customer_name
FROM IssueStatus i
INNER JOIN Books b ON i.Isbn_book = b.ISBN
INNER JOIN Customer c ON i.Issued_cust = c.Customer_Id;

-- 4. Display the total count of books in each category. 
SELECT Category, COUNT(*) AS Total_Books
FROM Books
GROUP BY Category;

-- 5. Retrieve the employee names and their positions for the employees whose salaries are above Rs.50,000. 
SELECT Emp_name, Position
FROM Employee
WHERE Salary > 50000;

-- 6. List the customer names who registered before 2022-01-01 and have not issued any books yet.
SELECT c.Customer_name,i.Issue_Id
FROM Customer c
LEFT JOIN IssueStatus i ON c.Customer_Id = i.Issued_cust
WHERE c.Reg_date < '2022-01-01' AND i.Issue_Id IS NULL;

-- 7. Display the branch numbers and the total count of employees in each branch. 
SELECT Branch_no, COUNT(*) AS Total_Employees
FROM Employee
GROUP BY Branch_no;

-- 8. Display the names of customers who have issued books in the month of June 2023.
SELECT c.Customer_name,i. Issue_date
FROM IssueStatus i
INNER JOIN Customer c ON i.Issued_cust = c.Customer_Id
WHERE i.Issue_date BETWEEN '2023-06-01' AND '2023-06-30';

 -- 9. Retrieve book_title from book table containing history.
 SELECT Book_title
FROM Books
WHERE Book_title LIKE '%history%';

-- 10.Retrieve the branch numbers along with the count of employees for branches having more than 5 employees
SELECT Branch_no, COUNT(*) AS Total_Employees
FROM Employee
GROUP BY Branch_no
HAVING COUNT(*) > 5;

-- 11. Retrieve the names of employees who manage branches and their respective branch addresses. 
SELECT e.Emp_name, b.Branch_address
FROM Employee e
INNER JOIN Branch b ON e.Emp_Id = b.Manager_Id;

-- 12. Display the names of customers who have issued books with a rental price higher than Rs. 25.
SELECT c.Customer_name,b.Rental_Price
FROM IssueStatus i
INNER JOIN Books b ON i.Isbn_book = b.ISBN
INNER JOIN Customer c ON i.Issued_cust = c.Customer_Id
WHERE b.Rental_Price > 25;

