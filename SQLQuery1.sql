--Mathematical functions
--ABS()
SELECT ABS(123.56);
SELECT ABS(-123.56);
--CELING()- Returns the immediate next value of the input number
SELECT CEILING(123.56);
SELECT CEILING(123.23);
SELECT CEILING(123);
--FLOOR()-Returns the immidiate last value for the input value
SELECT FLOOR(123.56);
SELECT FLOOR(123.23);
SELECT FLOOR(123.00);
--ROUND()-Specifies the rounded value for the input value up to the specified len
SELECT ROUND(123.5678,2);
SELECT ROUND(123.5678,0);
SELECT ROUND(456.2348,-1);
SELECT ROUND(456.2348,-2);
--ANALYTICAL Functions--Derive an aggregted value over a set of partitioned data or entire data
--FIRST_VALUE()-- Returns the first value of the ordered data in a partition data or entire data
--To find the highest stock level for each colored product and display it against each product color from the table 'Production.Product
SELECT Name,Color,SafetyStockLevel,
FIRST_VALUE(SafetyStockLevel) OVER(PARTITION BY Color ORDER BY SafetyStockLevel DESC) Highest_StockLevel
from Production.Product;
--LAST_VALUE()-Returns the last value of the ordered data in a partitioned data or entire data
SELECT Name,Color,SafetyStockLevel,
LAST_VALUE(SafetyStockLevel) OVER(PARTITION BY Color ORDER BY SafetyStockLevel DESC) Highest_StockLevel
from Production.Product;
--LEAD()
--To find the difference in sale for productID=777 against its next best sale from table 'Sales.Sales.OrderDetails
SELECT SalesOrderID,ProductID,LineTotal,
LEAD(LineTotal,1) OVER(ORDER BY LineTotal DESC) Next_best_sale,
LineTotal-LEAD(LineTotal,1) OVER(ORDER BY LineTotal DESC) SalesAmountCharge
from Sales.SalesOrderDetail
Where ProductID=777;
--LAG()
----To find the difference in sale for productID=777 against its Previous best sale from table 'Sales.Sales.OrderDetails
SELECT SalesOrderID,ProductID,LineTotal,
LAG(LineTotal,1) OVER(ORDER BY LineTotal DESC) Next_best_sale,
LineTotal-LAG(LineTotal,1) OVER(ORDER BY LineTotal DESC) SalesAmountCharge
from Sales.SalesOrderDetail
Where ProductID=777;

--Useful DML Statements
--INSERT()- To insert new records into the table
--Insert a new record in the 'Time' table in Training database
SELECT * FROM Time;
INSERT INTO Time (MonthID,MonthDesc,YearID,YearDesc)
VALUES(201412,'December',2014,2014);
--INSERT() with giving explicit value to IDENTY Feild
SELECT * FROM Products

SET IDENTITY_INSERT Products ON;
INSERT INTO Products (ProductID,ProductCode,ProductDescription,color)
VALUES(20,'CR-7833','Chaining ring','Black');
SET IDENTITY_INSERT Products OFF;

--Insert a record in the products table with no description 
INSERT INTO Products (ProductCode,color)
VALUES('CR-9981','Silver');
--Insert 'grey' color products into products table from NewProducts Table
INSERT INTO Products (ProductCode,ProductDescription,color)
SELECT ProductCode,ProductDescription,color FROM NewProducts
WHERE color='grey';
--INSERT a new city in city table
SELECT * FROM City
SET IDENTITY_INSERT City On;
INSERT INTO CITY (CityID,CityCode,CityName,PopulationDensity)
VALUES(40,'LDH','Ludhiana','High');
SET IDENTITY_INSERT City OFF;
--Insert low populated cities in to city table from NewMarkets table
INSERT INTO CITY (CityCode,CityName,PopulationDensity)
SELECT CityID,CityName,PopulationDensity from NewMarkets
WHERE PopulationDensity='Low';

--UPDATE()- Used to update the records
--Update the color of the product 'BL-2036' to 'Silver'
UPDATE Products
SET color='Silver'
WHERE ProductCode='BL-2036';
--Update sales value and sales Quantity to 0 in sales tables for sales recorded for NULL product
SELECT * FROM Sales
UPDATE Sales
SET SalesQuantity=0,
    SalesValue=0
WHERE SalesQuantity IS NULL OR SalesValue IS NULL;
 UPDATE Sales
SET MonthID=201601
WHERE SalesValue>9000 AND SalesQuantity>120;

--DELETE()- To delete the records
--Delete december 2014 record from 'Time' table
SELECT * FROM Time;
DELETE FROM Time
WHERE MonthID=201412;
--Duplicating the Table
SELECT * INTO Products_dup from NewProducts;
--Deleting all records in the Products_dup
select * from Products_dup;
DELETE FROM Products_dup;
--Inserting a new record into products-dup--the identity key does'nt reset
INSERT INTO Products_dup (ProductCode,ProductDescription,color)
VALUES('HU-6280','LL HUB','Grey');
--Delete the sales value from sales table where sales quantity is less than 50 or sales value less than 1000
--Creating a copy of sales table
SELECT * INTO Sales_copy from Sales;
DELETE FROM Sales_copy
WHERE SalesQuantity<50 OR SalesValue<1000;
--DELETE Grey products from products table
--Making a copy of products table
SELECT * INTO Products_copy from Products
DELETE FROM Products
WHERE color='grey';

--CREATE- Used to creat new table
--Create a  table named Dim city with following columns
--CityID-Identity int column with seed value=1 and increment value=1
--CityCode- varchar data type of length 10
--CityName- varchar data type of length 50
--PopulationType- varchar data type of length 10
CREATE TABLE DimCity
(
[CityID] [int] IDENTITY(1,1),
[CityCode] [varchar](10),
[CityName] [varchar](50),
[PopulationType] [varchar](10)
);
--Inserting the value in the above table
INSERT INTO DimCity(CityCode,CityName,PopulationType)
VALUES('HYD','Hyderabad','High');
SELECT * FROM DimCity;
--Creating a copy of the table
--Create a table old products with same structure as Products to store old products
SELECT * INTO OldProducts2 FROM Products
WHERE 0=1;
SELECT * FROM OldProducts2;
--Create a table named Black Products with two columns namely ProductCode,ProductDiscription, insert black products into the new table from products table
SELECT * INTO BlackProducts from Products
WHERE color='Black';
SELECT * FROM BlackProducts;
--Create a table named Retailers with following columns
--RetailerID-Identity int column with seed value=6 and Increment value=4
--RetailerCode-varchar data type of length 30
--RetailerName-varchar data type of length 50
--Credit-decimal data type with 7 precision and scale of 2
--CreditLimit-decimal data type with 8 precision and scale of 2
CREATE TABLE Retailers
(
[RetailerID] [int] IDENTITY(6,4),
[RetailerCode] [varchar](30),
[RetailerName] [varchar](50),
[Credit] [decimal](7,2),
[CreditLimit] [decimal](8,2)
);
SELECT * FROM Retailers;
--Insert data into the above table
INSERT INTO Retailers (RetailerCode,RetailerName,Credit,CreditLimit)
VALUES('AUSTRALIA001','Australis Bike Retailer',3245.50,50000.00);
INSERT INTO Retailers (RetailerCode,RetailerName,Credit,CreditLimit)
VALUES('TRIKES001','Trikes,Inc.',45300.80,40000.00);
INSERT INTO Retailers (RetailerCode,RetailerName,Credit,CreditLimit)
VALUES('CYCLING001','Cycling master',18780.90,20000.00);
SELECT * FROM Retailers;
INSERT INTO Retailers (RetailerCode,RetailerName,Credit,CreditLimit)
VALUES('MERITBI0001','Merit bikes',48538.00,60000.00);
--Creating a copy of retailers who crossed credit limit as defaulters
SELECT * INTO Defaulters2 from Retailers
WHERE CreditLimit<Credit;
SELECT * FROM Defaulters2;

--ALTER TABLE()- Used to add,drop and modify the column
--Add a new column 'Price' to Products table
ALTER TABLE [products]
add [Price] [decimal](7,2);
SELECT * FROM Products;
--Change the data type of the price column to int
ALTER TABLE Products
alter column Price int;
--drop the Price column
ALTER TABLE Products
drop column Price;
--Add a new integer column 'IsActive' to DimReseller table and update the value to 1 for all the retailers
ALTER TABLE DimReseller
add [IsActive] [int];
SELECT * FROM DimReseller;
UPDATE DimReseller
SET IsActive=1;
--Alter the data type of IsActive to varchar and update it to 'TRUE'
ALTER TABLE DimReseller
alter column [IsActive] [varchar](20);
UPDATE DimReseller
SET IsActive='True';
--DROP()- To Drop the table
DROP TABLE Products_dup;

--Commanly used constrains
--NOT NULL()- Ensure NULL values are not allowed in column, applied only column level
--Create a table name Employee with following columns
--EmpID- Identity int column with seed value=1 and increment value=1
--EmpName- NOT NULL varchar data type of length 100
--Gender-varchar data type of length 8
--startdate- date data type
--Enddate-date data type
CREATE TABLE Employee
(
EmpID int IDENTITY(1,1),
EmpName varchar(100) NOT NULL,
Gender varchar(8) NULL,
StartDate date NULL,
EndDate date NULL
);
SELECT * FROM Employee;
--In the above table add a NOT NULL constraint to the Gender column in Employee table
ALTER TABLE Employee
alter column Gender varchar(8) NOT NULL;
--Inserting the data into the above table
INSERT INTO Employee (EmpName,EndDate,StartDate,Gender)
VALUES('Priya','1996-10-11','2021-06-02','F');
SELECT * FROM Employee;
INSERT INTO Employee (EmpName,EndDate,StartDate)
VALUES('PUPPY','1996-10-11','2021-06-02');
--Add a column 'HireDate' in the employee table which only accepts valid values
ALTER TABLE Employee
add HireDate date;
UPDATE Employee
SET HireDate='01-10-2021'
WHERE EmpName='Priya';
ALTER TABLE Employee
alter column HireDate date NOT NULL;
--UNIQUE CONSTRAINT- Ensures unique value in column, accepts null values, multiple columns can be unique
--Create a table name 'Employee2' with following info
--EmpID-int
--EmpName-Not Null, varchar datatype of length 100
--Gender-varchar datatype length 8
--StartDate-date datatype
--EndDate-date datatype
--Where EmpID and EmpName uniquely identifies the employee
CREATE TABLE Employee2
(
[EmpID] [int],
[EmpName] [varchar](100) NOT NULL,
[Gender] [varchar](8) NULL,
[StartDate] [date] NULL,
[EndDate] [date] NULL,
CONSTRAINT uc_employee UNIQUE (EmpID,EmpName)
);
--Insert the same data into the emoloyee2 table and check for the error
INSERT INTO Employee2 (EmpID,EmpName,Gender,StartDate,EndDate)
VALUES(1,'Priya','F','02-01-2021','02-01-2035');
SELECT * FROM Employee2;
INSERT INTO Employee2 (EmpID,EmpName,Gender,StartDate,EndDate)
VALUES(1,'MORA','F','02-01-2021','02-01-2035');
INSERT INTO Employee2 (EmpID,EmpName,Gender,StartDate,EndDate)
VALUES(1,'Priya','F','02-01-2021','02-01-2035');
--Drop the Unique constrain from the employee2 table
ALTER TABLE Employee2
drop constraint uc_employee;
--adding a duplicate column in employee2 table and again adding the UNIQUE CONSTRAINT
INSERT INTO Employee2 (EmpID,EmpName,Gender,StartDate,EndDate)
VALUES(1,'MORA','F','02-01-2021','02-01-2035');
SELECT * FROM Employee2;
--Adding the Unique constraint
ALTER TABLE Employee2
add constraint 
uc_emp UNIQUE (EmpID,EmpName);--here we get an error because of duplicate values
--Create a table name products with following info
--ProductName-NOT NULL, Varchar datatype of length 100
--ProductCode-NOT NULL, Varchar datatype of lengtg 20
--Color- Varchat datatype of length 20
--Price- decimal datatype
--Where ProductName,ProductCode together uniquely identifies a Products
CREATE TABLE Products
(
ProductName varchar(100) NOT NULL,
productCode varchar(20) NOT NULL,
Color varchar(20) NULL,
Price decimal,
Constraint emp UNIQUE (ProductName,ProductCode)
);
SELECT * FROM Products;
--PRIMARY KEY CONSTRAINT
--Uniquely defines each row, can't accept NULL Values, table has only one Primary key
--Create a table name 'Employee3' with following info
--EmpID-int
--EmpName-Not Null, varchar datatype of length 100
--Gender-varchar datatype length 8
--StartDate-date datatype
--EndDate-date datatype
--Where EmpID uniquely identifies the employee
CREATE TABLE Employee3
(
EmpID int,
EmpName varchar(100)  NOT NULL,
Gender varchar(8) NULL,
StartDate date NULL,
EndDate date NULL,
CONSTRAINT pk_emp PRIMARY KEY (EmpID)
);
SELECT * FROM Employee3;
--INSERTING data in the above table
INSERT INTO Employee3 (EmpID,EmpName,Gender)
VALUES(1,'Michel','Male');
INSERT INTO Employee3 (EmpID,EmpName,Gender)
VALUES(1,'Michel','Male');
--Droping the constraint
ALTER TABLE Employee3
drop constraint pk_emp;
--Adding the constraint back- gives an error due to duplicate values
ALTER TABLE Employee3
add constraint pk_emp PRIMARY KEY (EmpID);
--Create a table name products2 with following info
--ProductName-NOT NULL, Varchar datatype of length 100
--ProductCode-Varchar datatype of lengtg 20
--Color- Varchat datatype of length 20
--Price- decimal datatype
--Where ProductCode uniquely identifies a Products and can not accept NULL Values
CREATE TABLE Products2
(
ProductName varchar(100) NOT NULL,
ProductCode varchar(20),
Color varchar(20) NULL,
Price decimal NULL,
CONSTRAINT pk_pro PRIMARY KEY (ProductCode)
);
--FOREIGN KEY CONSTRAINT
--Ensure to the column to accept values only from primary key in another table
----Create a table name 'Employee3' with following info
--EmpID-int
--EmpName-Not Null, varchar datatype of length 100
--Gender-varchar datatype length 8
--StartDate-date datatype
--EndDate-date datatype
--Where EmpID uniquely identifies the employee
CREATE TABLE Employee4
(
EmpID int,
EmpName varchar(100)  NOT NULL,
Gender varchar(8) NULL,
StartDate date NULL,
EndDate date NULL,
CONSTRAINT pk_emp PRIMARY KEY (EmpID)
);
SELECT * FROM Employee4;
--Inserting the records into the table
INSERT INTO Employee4 (EmpID,EmpName,Gender)
VALUES(1,'Michel','Male');
INSERT INTO Employee4 (EmpID,EmpName,Gender)
VALUES(2,'Joey','Male');
--Create a salary table
--EmpID-integer value(Employement ID in the employee table
--salary-integer value
CREATE TABLE Salary 
(
EmpID int,
Salary int,
CONSTRAINT fk_salary FOREIGN KEY (EmpID) REFERENCES Employee4(EmpID)
);
--Inserting the data into salary table
INSERT INTO Salary (EmpID,Salary)
VALUES(3,2222);
--Droping the constraint
ALTER TABLE Salary
drop constraint fk_salary;
--CHECK CONSTRAINT
--Ensure column accepts only valid values based on specified
--Create a table name products3 with following info
--ProductID- Identity int column with seed value=1 and increment value=1
--ProductName-NOT NULL, Varchar datatype of length 100
--ProductCode-Varchar datatype of lengtg 20
--Color- Varchar datatype of length 20
--Price- decimal datatype 
--Where it allows products with Price greater than 150
CREATE TABLE Products3
(
ProductID int IDENTITY(1,1),
ProductName varchar(100) NOT NULL,
ProductCode varchar(20) NULL,
Color varchar(20) NULL,
Price decimal(6,2) NULL,
Constraint check_pro CHECK (Price>150)
);
SELECT * FROM Products3;
--Add the check constraint to products3 table to allow only 'black' coloured products with Price greater than 150
ALTER TABLE Products3
add constraint check_color CHECK (Color='black' and Price>150);
--Insert the data in the above table
INSERT INTO Products3 (ProductName,ProductCode,Price)
VALUES('Blade','BL-2036',138.5);
--Drop the check_pro constraint
ALTER TABLE Products3
drop constraint check_pro;
--DEFAULT CONSTRAINT
--Specifies a default value for the column when no value is specified
--Create a table name products3 with following info
--ProductID- Identity int column with seed value=1 and increment value=1
--ProductName-NOT NULL, Varchar datatype of length 100
--ProductCode-Varchar datatype of lengtg 20
--Color- Varchar datatype of length 20 with a default value 'black'
--Price- decimal datatype
CREATE TABLE Products4
(
ProductID int identity(1,1),
ProductName varchar(100) NOT NULL,
ProductCode varchar(20) NULL,
Color varchar(20) NULL CONSTRAINT default_pro DEFAULT 'Black',
Price decimal(6,2) NULL
);
--Assign the default price as 100
ALTER TABLE Products4
add constraint df_color DEFAULT 100 for Price;
--Adding the data
Insert INTO Products4 (ProductName,ProductCode,Price)
VALUES('blade','BL-2036',138.5);
SELECT * FROM Products4;
--Drop the constraint
ALTER TABLE Products4
drop constraint df_color;

--JOINS- Used to join multiple tables based on common column
--INNER JOIN- Returns the matching rows from both tables
--Find the sales value and quantity against different population density zones using sales table and city table
SELECT * FROM City;
SELECT * FROM Sales;
SELECT C.PopulationDensity, SUM(S.SalesQuantity) SUM_OF_QUANTITY,SUM(S.SalesValue) SUM_SALES
FROM Sales S
INNER JOIN
City C
ON
C.CityID=S.CityID
GROUP BY C.PopulationDensity;

--LEFT JOIN- Gives the common rows from right table and all the rows from left table
--List all the cities with sales value and sales quantity at city level.  If there are no sales made in a particular city the show the measure as 0
SELECT C.CityName,ISNULL(SUM(SalesQuantity),0),ISNULL(SUM(SalesValue),0)
FROM City C
LEFT JOIN
Sales S
ON
S.CityID=C.CityID
GROUP BY C.CityName;
--LEFT EXCLUDING JOIN- Return all the records from left table without matching records from right table
--List the cities with no sales
SELECT C.* ,S.SalesQuantity FROM
City C LEFT JOIN Sales S
ON 
C.CityID=S.CityID
WHERE S.SalesQuantity IS NULL;
--RIGHT JOIN- Returns matching rows from left table and all the rows from right table
--List all the cities with sales value and sales quantity at city level.  If there are no sales made in a particular city the show the measure as 0
SELECT C.CityName,ISNULL(SUM(SalesQuantity),0),ISNULL(SUM(SalesValue),0)
FROM Sales S
LEFT JOIN
City C
ON
S.CityID=C.CityID
GROUP BY C.CityName;
--RIGHT EXCLUDING JOIN- Return all the records from right table without matching records from right table
--List the sales for invalid product that is products not available in products table
SELECT S.*,P.ProductID FROM Products P RIGHT JOIN Sales S
ON P.ProductID=S.ProductID
WHERE P.ProductID IS NULL;

SELECT * FROM DimSalesTerritory;
SELECT * FROM FactInternetSales;

--FULL JOIN- Full join is used to return all the rows from both the tables
--Select all the sales orders and all products from sales table and products table respectively
SELECT * FROM Sales S
FULL JOIN Products P
ON S.ProductID=P.ProductID
--SELF JOIN- Self join is used to join table with it self by using the two copies of the same table
--Select distinct list of all different sales orderID for ProductID=776
SELECT * FROM Sales.SalesOrderDetail;
SELECT DISTINCT(S.SalesOrderID), P.SalesOrderDetailID FROM
Sales.SalesOrderDetail S LEFT JOIN Sales.SalesOrderDetail P
ON S.SalesOrderID=P.SalesOrderDetailID
WHERE S.ProductID=776;

--VIEW
--Create view- Used to creat the view
--Create a view to allow the users to access only Canada's Internet Sales for the year 2008
CREATE VIEW
CanadaInternetSales2008
AS
SELECT INTSALES.* FROM FactInternetSales INTSALES
INNER JOIN
DimSalesTerritory ST
ON
INTSALES.SalesTerritoryKey=ST.SalesTerritoryKey
INNER JOIN
DimDate DT
ON
INTSALES.OrderDateKey=DT.DateKey
WHERE ST.SalesTerritoryRegion='Canada'
AND DT.CalendarYear=2008;

SELECT * FROM CanadaInternetSales2008;

--UPDATE THE VIEW
--Update CanadaInternetSales2008 view to select only products with UnitPrice greater than 50
ALTER VIEW 
CanadaInternetSales2008
AS
SELECT INTSALES.* FROM FactInternetSales INTSALES
INNER JOIN
DimSalesTerritory ST
ON
INTSALES.SalesTerritoryKey=ST.SalesTerritoryKey
INNER JOIN
DimDate DT
ON
INTSALES.OrderDateKey=DT.DateKey
WHERE ST.SalesTerritoryRegion='Canada'
AND DT.CalendarYear=2008
AND UnitPrice>50;

SELECT * FROM CanadaInternetSales2008;

--DROP VIEW
DROP VIEW CanadaInternetSales2008;
