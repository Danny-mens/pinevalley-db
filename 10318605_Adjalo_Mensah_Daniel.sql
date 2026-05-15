-- 1. Create database
CREATE DATABASE PineValleyFC;
USE PineValleyFC;   -- (or equivalent for your DBMS)

-- 2. Create tables (parents first, then children)

-- Customer_T (Parent)
CREATE TABLE Customer_T (
    CustomerID      INT PRIMARY KEY,
    CustomerName    VARCHAR(100) NOT NULL,
    CustomerCity    VARCHAR(50),
    CustomerState   VARCHAR(50)
);

-- Product_T (Parent) with CHECK constraint on ProductFinish
CREATE TABLE Product_T (
    ProductID           INT PRIMARY KEY,
    ProductName         VARCHAR(100) NOT NULL,
    ProductStandardPrice DECIMAL(10,2),
    ProductFinish       VARCHAR(30),
    CHECK (ProductFinish IN ('Natural Ash', 'Red Oak', 'Cherry', 'Walnut', 'Maple'))
);

-- Order_T (Child of Customer_T)
CREATE TABLE Order_T (
    OrderID     INT PRIMARY KEY,
    OrderDate   DATE,
    CustomerID  INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer_T(CustomerID)
);

-- OrderLine_T (Child of Order_T and Product_T)
CREATE TABLE OrderLine_T (
    OrderID         INT,
    ProductID       INT,
    OrderedQuantity INT,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID)   REFERENCES Order_T(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product_T(ProductID)
);

-- 3. Add CustomerEmail column to Customer_T
ALTER TABLE Customer_T
ADD CustomerEmail VARCHAR(50);

-- 4. Create index on ProductStandardPrice
CREATE INDEX idx_product_price ON Product_T(ProductStandardPrice);

INSERT INTO Customer_T (CustomerID, CustomerName, CustomerCity, CustomerState, CustomerEmail)
VALUES
    (1100, 'Kojo Asare',        'Accra',      'Greater Accra', 'kojo.asare@email.com'),
    (1101, 'Ama Serwaa',        'Kumasi',     'Ashanti',       'ama.serwaa@email.com'),
    (1102, 'Kofi Mensah',       'Tema',       'Greater Accra', 'kofi.mensah@email.com'),
    (1103, 'Esi Boateng',       'Sekondi',    'Western',       'esi.boateng@email.com'),
    (1104, 'Kwame Nkrumah',     'Accra',      'Greater Accra', 'kwame.nkrumah@email.com'),
    (1105, 'Abena Osei',        'Kumasi',     'Ashanti',       'abena.osei@email.com');
    
    -- First 5 products
INSERT INTO Product_T (ProductID, ProductName, ProductStandardPrice, ProductFinish)
VALUES
    (101, 'Dining Table',        450.00, 'Natural Ash'),
    (102, 'Office Desk',         320.00, 'Red Oak'),
    (103, 'Bookshelf',           275.00, 'Walnut'),
    (104, 'Conference Chair',    150.00, 'Maple'),
    (105, 'Nightstand',          125.00, 'Natural Ash');

-- Cherry Dining Table (question 1b)
INSERT INTO Product_T (ProductID, ProductName, ProductStandardPrice, ProductFinish)
VALUES (106, 'Cherry Dining Table', 800.00, 'Cherry');

INSERT INTO Order_T (OrderID, OrderDate, CustomerID)
VALUES
    (5001, '2022-12-15', 1100),
    (5002, '2023-01-20', 1101),
    (5003, '2023-03-10', 1102),
    (5004, '2023-05-05', 1103),
    (5005, '2024-02-18', 1104);
    
    INSERT INTO OrderLine_T (OrderID, ProductID, OrderedQuantity)
VALUES
    (5001, 101, 2),
    (5001, 106, 1),
    (5002, 102, 5),
    (5003, 104, 8),
    (5004, 103, 3),
    (5005, 105, 4);
    
    SELECT CustomerName, CustomerCity, CustomerState
FROM Customer_T
WHERE CustomerState = 'Greater Accra' OR CustomerCity = 'Kumasi'
ORDER BY CustomerName ASC;

SELECT
    MAX(ProductStandardPrice) AS Max_Price,
    MIN(ProductStandardPrice) AS Min_Price,
    AVG(ProductStandardPrice) AS Avg_Price
FROM Product_T;

SELECT o.OrderID, c.CustomerName
FROM Order_T o
INNER JOIN Customer_T c ON o.CustomerID = c.CustomerID;

SELECT ProductID, SUM(OrderedQuantity) AS TotalOrderedQuantity
FROM OrderLine_T
GROUP BY ProductID
HAVING SUM(OrderedQuantity) > 10;

UPDATE Customer_T
SET CustomerCity = 'Koforidua'
WHERE CustomerID = 1100;

DELETE FROM Order_T
WHERE OrderDate < '2023-01-01';

GRANT SELECT, INSERT ON Order_T TO Sales_Clerk;

REVOKE DELETE ON Product_T FROM Sales_Clerk;

