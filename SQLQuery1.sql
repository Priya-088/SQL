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
DROP  TABLE Products_dup;