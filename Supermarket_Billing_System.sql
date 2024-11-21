
-- Step 1: Create the Database
CREATE DATABASE SupermarketBillingSystem;
USE SupermarketBillingSystem;

-- Step 2: Create Tables

-- Products Table
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    Price DECIMAL(10, 2) NOT NULL,
    QuantityInStock INT NOT NULL
);

-- Customers Table
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(15),
    Email VARCHAR(50),
    Address TEXT
);

-- Bills Table
CREATE TABLE Bills (
    BillID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    BillDate DATE NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- BillDetails Table (For individual product items in each bill)
CREATE TABLE BillDetails (
    BillDetailID INT AUTO_INCREMENT PRIMARY KEY,
    BillID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    Subtotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (BillID) REFERENCES Bills(BillID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Step 3: Insert Sample Data

-- Insert Products
INSERT INTO Products (Name, Category, Price, QuantityInStock) VALUES
('Milk', 'Dairy', 2.50, 100),
('Bread', 'Bakery', 1.20, 50),
('Apple', 'Fruits', 0.75, 200),
('Soap', 'Toiletries', 1.50, 150),
('Shampoo', 'Toiletries', 5.00, 80);

-- Insert Customers
INSERT INTO Customers (Name, PhoneNumber, Email, Address) VALUES
('John Doe', '1234567890', 'john@example.com', '123 Main St'),
('Jane Smith', '9876543210', 'jane@example.com', '456 Elm St');

-- Insert Bills
INSERT INTO Bills (CustomerID, BillDate, TotalAmount) VALUES
(1, '2024-11-20', 15.50),
(2, '2024-11-21', 8.40);

-- Insert BillDetails
INSERT INTO BillDetails (BillID, ProductID, Quantity, Subtotal) VALUES
(1, 1, 2, 5.00),  -- 2 Milk
(1, 2, 1, 1.20),  -- 1 Bread
(1, 4, 2, 3.00),  -- 2 Soap
(2, 3, 5, 3.75),  -- 5 Apples
(2, 2, 2, 2.40);  -- 2 Bread

-- Step 4: Sample Queries

-- 1. View all products and their stock levels
SELECT ProductID, Name, Category, QuantityInStock, Price FROM Products;

-- 2. Check total sales made for a specific product
SELECT p.Name AS ProductName, SUM(bd.Quantity) AS TotalQuantitySold, SUM(bd.Subtotal) AS TotalSales
FROM BillDetails bd
JOIN Products p ON bd.ProductID = p.ProductID
GROUP BY p.ProductID;

-- 3. View bill details for a specific bill
SELECT b.BillID, c.Name AS CustomerName, b.BillDate, bd.Quantity, p.Name AS ProductName, bd.Subtotal
FROM Bills b
JOIN BillDetails bd ON b.BillID = bd.BillID
JOIN Products p ON bd.ProductID = p.ProductID
JOIN Customers c ON b.CustomerID = c.CustomerID
WHERE b.BillID = 1;

-- 4. List all customers and their total spending
SELECT c.Name AS CustomerName, SUM(b.TotalAmount) AS TotalSpent
FROM Customers c
JOIN Bills b ON c.CustomerID = b.CustomerID
GROUP BY c.CustomerID;

-- 5. Check low stock products
SELECT Name, QuantityInStock
FROM Products
WHERE QuantityInStock < 20;

-- 6. Calculate total revenue
SELECT SUM(TotalAmount) AS TotalRevenue FROM Bills;
