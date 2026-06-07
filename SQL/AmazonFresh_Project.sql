-- Amazon Fresh Analytics Project
CREATE DATABASE AmazonFresh;
USE AmazonFresh;

CREATE TABLE Customers(
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100) UNIQUE,
    City VARCHAR(100),
    Age INT NOT NULL CHECK(Age > 18),
    PrimeMember VARCHAR(10) DEFAULT 'No'
);

CREATE TABLE Suppliers(
    SupplierID INT PRIMARY KEY,
    SupplierName VARCHAR(100),
    City VARCHAR(100),
    ContactNumber VARCHAR(20)
);

CREATE TABLE Products(
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    StockQuantity INT,
    SupplierID INT,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

CREATE TABLE Orders(
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    OrderAmount DECIMAL(10,2),
    FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Order_Details(
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    Discount DECIMAL(10,2),
    FOREIGN KEY(OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY(ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Reviews(
    ReviewID INT PRIMARY KEY,
    ProductID INT,
    CustomerID INT,
    Rating INT CHECK(Rating BETWEEN 1 AND 5),
    ReviewText TEXT,
    FOREIGN KEY(ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID)
);

-- Task 5
INSERT INTO Products VALUES
(1001,'Apple','Fruits',120,50,1),
(1002,'Banana','Fruits',60,100,1),
(1003,'Orange','Fruits',90,80,2);

-- Task 6
UPDATE Products
SET StockQuantity = 150
WHERE ProductID = 1001;

-- Task 7
DELETE FROM Suppliers
WHERE City='Mumbai';

-- Task 3
SELECT * FROM Customers WHERE City='Patelberg';
SELECT * FROM Products WHERE Category='Fruits';

-- Task 9
SELECT * FROM Orders WHERE OrderDate > '2024-01-01';

SELECT ProductID, AVG(Rating) AvgRating
FROM Reviews
GROUP BY ProductID
HAVING AVG(Rating) > 4;

SELECT ProductID, SUM(Quantity) TotalSold
FROM Order_Details
GROUP BY ProductID
ORDER BY TotalSold DESC;

-- Task 10
SELECT CustomerID, SUM(OrderAmount) TotalSpent
FROM Orders
GROUP BY CustomerID
HAVING SUM(OrderAmount) > 5000
ORDER BY TotalSpent DESC;

-- Task 11
SELECT o.OrderID,
SUM(od.Quantity * od.UnitPrice - od.Discount) Revenue
FROM Orders o
JOIN Order_Details od ON o.OrderID = od.OrderID
GROUP BY o.OrderID;

SELECT CustomerID, COUNT(OrderID) TotalOrders
FROM Orders
GROUP BY CustomerID
ORDER BY TotalOrders DESC;

SELECT SupplierID, COUNT(ProductID) ProductCount
FROM Products
GROUP BY SupplierID
ORDER BY ProductCount DESC
LIMIT 1;

-- Task 13
SELECT ProductID,
SUM(Quantity * UnitPrice) Revenue
FROM Order_Details
GROUP BY ProductID
ORDER BY Revenue DESC
LIMIT 3;

SELECT *
FROM Customers
WHERE CustomerID NOT IN
(SELECT CustomerID FROM Orders);

-- Task 14
SELECT City, COUNT(*) PrimeUsers
FROM Customers
WHERE PrimeMember='Yes'
GROUP BY City
ORDER BY PrimeUsers DESC;

SELECT Category, COUNT(*) TotalProducts
FROM Products
GROUP BY Category
ORDER BY TotalProducts DESC
LIMIT 3;

-- ACID Transaction Example
START TRANSACTION;

UPDATE Products
SET StockQuantity = StockQuantity - 5
WHERE ProductID = 1001;

INSERT INTO Orders
VALUES (5001,101,CURDATE(),1200);

COMMIT;
