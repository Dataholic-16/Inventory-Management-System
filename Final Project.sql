-- Create Product table
CREATE TABLE Product (
    product_Id INTEGER PRIMARY KEY,
    product_Name TEXT,
    description TEXT,
    category TEXT,
    price REAL,
    quantity_in_hand INTEGER,
    min_stock_level INTEGER,
    FK_supplier_Id INTEGER,
    FK_customer_Id INTEGER,
    supplier_Name TEXT,
    FOREIGN KEY (FK_supplier_Id) REFERENCES Supplier(supplier_Id),
    FOREIGN KEY (FK_customer_Id) REFERENCES Customer(customer_Id)
);


-- Create Supplier table
CREATE TABLE Supplier (
    supplier_Id INTEGER PRIMARY KEY,
    supplier_Name TEXT,
    contact_Info TEXT
);

-- Create Sales Order table
CREATE TABLE Sales_Order (
    Order_Id INTEGER PRIMARY KEY,
    Order_Date DATE,
    total_Amount REAL,
    FK_payment_method_Id INTEGER,
    FK_customer_Id INTEGER,
    FOREIGN KEY (FK_payment_method_Id) REFERENCES Payment_Method(payment_method_Id),
    FOREIGN KEY (FK_customer_Id) REFERENCES Customer(customer_Id)
);

-- Create Purchase Order table
CREATE TABLE Purchase_Order (
    Order_Id INTEGER PRIMARY KEY,
    Order_date DATE,
    total_amount REAL,
    FK_supplier_Id INTEGER,
    FOREIGN KEY (FK_supplier_Id) REFERENCES Supplier(supplier_Id)
);


-- Create Inventory Log table
CREATE TABLE Inventory_Log (
    log_ID INTEGER PRIMARY KEY,
    date DATE,
    FK_product_Id INTEGER,
    quantity_Removed INTEGER,
    quantity_Added INTEGER,
    quantity_in_Hand INTEGER,
    min_stock_Level INTEGER,
    FK__employee_Id INTEGER,
    FOREIGN KEY (FK_product_Id) REFERENCES Product(product_Id),
    FOREIGN KEY (FK__employee_Id) REFERENCES Employee(employee_Id)
);

-- Create Employee table
CREATE TABLE Employee (
    employee_Id INTEGER PRIMARY KEY,
    employee_Name TEXT,
    position TEXT,
    contact_Info TEXT
);

-- Create Discounts table
CREATE TABLE Discounts (
   discount_Id INTEGER PRIMARY KEY,
   discount_Amount INTEGER,
   FK_product_Id INTEGER,
   FOREIGN KEY (FK_product_Id) REFERENCES Product(product_Id)
);


 CREATE TABLE Customer (
   customer_Id INTEGER PRIMARY KEY,
   customer_Name TEXT,
   customer_Info TEXT,
);
-- Create Transaction_History table
CREATE TABLE Transaction_History (
    transaction_Id INTEGER PRIMARY KEY,
    transaction_date DATE,
    transaction_type TEXT,
    FK_product_Id INTEGER,
    FK_order_Id INTEGER,
    FOREIGN KEY (FK_product_Id) REFERENCES Product(product_Id),
    FOREIGN KEY (FK_order_Id) REFERENCES Sales_Order(Order_Id)
);

-- Create Sales_Transaction table
CREATE TABLE Sales_Transaction (
    transaction_Id INTEGER PRIMARY KEY,
    FK_Order_Id INTEGER,
    FK_product_Id INTEGER,
    FK_customer_Id INTEGER,
    FK_payment_method_Id INTEGER,
    quantity_Sold INTEGER,
    FK_transaction_Date DATE,
    FOREIGN KEY (FK_Order_Id) REFERENCES Sales_Order(Order_Id),
    FOREIGN KEY (FK_product_Id) REFERENCES Product(product_Id),
    FOREIGN KEY (FK_customer_Id) REFERENCES Customer(customer_Id),
    FOREIGN KEY (FK_payment_method_Id) REFERENCES Payment_Method(payment_method_Id)
);

-- Create Payment_Method table
CREATE TABLE Payment_Method (
  payment_method_Id INTEGER PRIMARY KEY,
  method_Name TEXT
);
-- Create Customer table
CREATE TABLE Customer (
    customer_Id INTEGER PRIMARY KEY,
    customer_Name TEXT,
    customer_Info TEXT
);

SELECT * FROM Product
JOIN Supplier ON Product.FK_supplier_Id = Supplier.supplier_Id;

SELECT Sales_Order.Order_Id, Sales_Order.Order_Date, Sales_Order.total_Amount, Customer.customer_Name, Product.product_Name
FROM Sales_Order
JOIN Customer ON Sales_Order.FK_customer_Id = Customer.customer_Id
JOIN Sales_Transaction ON Sales_Order.Order_Id = Sales_Transaction.FK_Order_Id
JOIN Product ON Sales_Transaction.FK_product_Id = Product.product_Id;

SELECT Inventory_Log.log_ID, Inventory_Log.date, Inventory_Log.quantity_Added, Employee.employee_Name
FROM Inventory_Log
JOIN Employee ON Inventory_Log.FK__employee_Id = Employee.employee_Id;

SELECT Transaction_History.transaction_Id, Transaction_History.transaction_date, Transaction_History.transaction_type,
       Product.product_Name, Sales_Order.Order_Id
FROM Transaction_History
JOIN Product ON Transaction_History.FK_product_Id = Product.product_Id
JOIN Sales_Order ON Transaction_History.FK_order_Id = Sales_Order.Order_Id;

SELECT Sales_Transaction.transaction_Id, Customer.customer_Name, Payment_Method.method_Name, Sales_Transaction.quantity_Sold
FROM Sales_Transaction
JOIN Customer ON Sales_Transaction.FK_customer_Id = Customer.customer_Id
JOIN Payment_Method ON Sales_Transaction.FK_payment_method_Id = Payment_Method.payment_method_Id;

SELECT Sales_Order.Order_Id, SUM(Product.price * Sales_Transaction.quantity_Sold) AS TotalSalesAmount
FROM Sales_Order
JOIN Sales_Transaction ON Sales_Order.Order_Id = Sales_Transaction.FK_Order_Id
JOIN Product ON Sales_Transaction.FK_product_Id = Product.product_Id
GROUP BY Sales_Order.Order_Id;

SELECT Employee.employee_Id, Employee.employee_Name, Employee.position
FROM Employee;

SELECT Discounts.discount_Id, Discounts.discount_Amount, Product.product_Name
FROM Discounts
JOIN Product ON Discounts.FK_product_Id = Product.product_Id;


-- Insert data into Payment_Method table
INSERT INTO Payment_Method VALUES (1, 'Credit Card');
INSERT INTO Payment_Method VALUES (2, 'PayPal');

-- Insert data into Supplier table
INSERT INTO Supplier VALUES (1, 'Tech Supplier', 'techsupplier@gmail.com');
INSERT INTO Supplier VALUES (2, 'Office Supplies Inc.', 'osinc@gmail.com');

-- Insert data into Customer table
INSERT INTO Customer VALUES (1, 'John Doe', 'john.doe@gmail.com');
INSERT INTO Customer VALUES (2, 'Jane Smith', 'jane.smith@gmail.com');

-- Insert data into Employee table
INSERT INTO Employee VALUES (1, 'Manager Smith', 'Manager', 'smith@gmail.com');
INSERT INTO Employee VALUES (2, 'Salesperson Johnson', 'Salesperson', 'Johnson@gmail.com');

-- Insert data into Product table
INSERT INTO Product VALUES (1, 'Laptop', 'High-performance laptop', 'Electronics', 999.99, 50, 10, 1, 1, 'Tech Supplier');
INSERT INTO Product VALUES (2, 'Printer', 'Wireless color printer', 'Electronics', 199.99, 20, 5, 2, 1, 'Office Supplies Inc.');

-- Update data in Product table
UPDATE Product SET product_Name = 'Laptop', description = 'High-performance laptop', category = 'Electronics', price = 71999.00, quantity_in_hand = 50, min_stock_level = 10, FK_supplier_Id = 1, FK_customer_Id = 1, supplier_Name = 'Tech Supplier' WHERE product_Id = 1;
UPDATE Product SET product_Name = 'Printer', description = 'Wireless color printer', category = 'Electronics', price = 82999.00, quantity_in_hand = 20, min_stock_level = 5, FK_supplier_Id = 2, FK_customer_Id = 1, supplier_Name = 'Office Supplies Inc.' WHERE product_Id = 2;

-- Insert data into Sales_Order table
INSERT INTO Sales_Order VALUES (1, '2023-02-01', 1199.98, 1, 1);
INSERT INTO Sales_Order VALUES (2, '2023-02-02', 399.98, 2, 2);
-- Update data in Sales_Order table
UPDATE Sales_Order SET Order_Date = '2023-02-01', total_Amount = 80000, FK_payment_method_Id = 1, FK_customer_Id = 1 WHERE Order_Id = 1;
UPDATE Sales_Order SET Order_Date = '2023-02-02', total_Amount = 95000, FK_payment_method_Id = 2, FK_customer_Id = 2 WHERE Order_Id = 2;


-- Insert data into Discounts table
INSERT INTO Discounts VALUES (1, 10, 1);
INSERT INTO Discounts VALUES (2, 5, 2);

-- Insert data into Inventory_Log table
INSERT INTO Inventory_Log VALUES (1, '2023-02-01', 1, 0, 10, 40, 10, 1);
INSERT INTO Inventory_Log VALUES (2, '2023-02-02', 2, 0, 5, 15, 5, 2);

-- Insert data into Transaction_History table
INSERT INTO Transaction_History VALUES (1, '2023-02-01', 'Sale', 1, 1);
INSERT INTO Transaction_History VALUES (2, '2023-02-02', 'Sale', 2, 2);

-- Insert data into Sales_Transaction table
INSERT INTO Sales_Transaction VALUES (1, 1, 1, 1, 1, 1, '2023-02-01');
INSERT INTO Sales_Transaction VALUES (2, 2, 2, 2, 2, 1, '2023-02-02');

-- Insert data into Purchase_Order table
INSERT INTO Purchase_Order VALUES (1, '2023-02-01',60000, 1);
INSERT INTO Purchase_Order VALUES (2, '2023-02-02', 65000, 2);

