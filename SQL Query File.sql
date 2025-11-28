USE `mahendra`;
-- show columns / sample rows for each table
SHOW COLUMNS FROM d_store;
SELECT * FROM d_store LIMIT 5;

SHOW COLUMNS FROM f_inventory_adjusted;
SELECT * FROM f_inventory_adjusted LIMIT 5;

SHOW COLUMNS FROM f_sales;
SELECT * FROM f_sales LIMIT 5;

SHOW COLUMNS FROM calendar;
SELECT * FROM calendar LIMIT 10;

SHOW COLUMNS FROM customer;
SELECT * FROM customer LIMIT 5;

SHOW COLUMNS FROM d_geojson_us_counties;
SELECT * FROM d_geojson_us_counties LIMIT 5;
-- -----------------------------------------------------------------------------------
-- 1.Total Sales
SELECT 
    ROUND(SUM(f.`Price` * f.`Quantity on Hand`), 2) AS Total_Sales
FROM f_inventory_adjusted f;
-- 2.Total Quantity
SELECT 
    SUM(f.`Quantity on Hand`) AS Total_Quantity
FROM f_inventory_adjusted f;
-- 3.In Stock - out stock
SELECT 
    CASE 
        WHEN `Quantity on Hand` > 0 THEN 'In-Stock'
        ELSE 'Out-of-Stock'
    END AS Stock_Status,
    COUNT(*) AS Product_Count
FROM f_inventory_adjusted
GROUP BY Stock_Status;
-- 4.purchase method
SELECT 
    f.`Purchase Method`,
    COUNT(*) AS Total_Purchases
FROM f_sales f
WHERE f.`Transaction Type` = 'Purchase'
GROUP BY f.`Purchase Method`
ORDER BY Total_Purchases DESC;
-- 5. Top 10 Sores by Region
SELECT 
    s.`Store Region`,
    COUNT(f.`Order Number`) AS Total_Orders
FROM f_sales f
JOIN d_store s 
    ON f.`Store Key` = s.`Store Key`
GROUP BY s.`Store Region`
ORDER BY Total_Orders DESC
LIMIT 10;

-- 2.Top Performing Stores by Customer Orders( Find which stores generate the most sales volume.)
SELECT 
    s.`Store Name`,
    s.`Store City`,
    s.`Store State`,
    COUNT(DISTINCT f.`Order Number`) AS Total_Orders,
    COUNT(DISTINCT f.`Cust Key`) AS Unique_Customers
FROM f_sales f
JOIN d_store s ON f.`Store Key` = s.`Store Key`
GROUP BY s.`Store Name`, s.`Store City`, s.`Store State`
ORDER BY Total_Orders DESC
LIMIT 10;
-- ------------------------------------------------------------------------------------------------
-- 3.Total Orders by Store (Top 10 Stores) Find which stores are generating the most sales transactions.
SELECT 
    s.`Store Name`,
    s.`Store City`,
    s.`Store State`,
    COUNT(f.`Order Number`) AS Total_Orders
FROM f_sales f
JOIN d_store s ON f.`Store Key` = s.`Store Key`
GROUP BY s.`Store Name`, s.`Store City`, s.`Store State`
ORDER BY Total_Orders DESC
LIMIT 10;
-- ----------------------------------------------------------------------------------------------------------------
-- 4.Customer Distribution by Region (Check how customers are spread geographically.)
SELECT 
    `Cust Region`,
    `Cust State`,
    COUNT(*) AS Total_Customers
FROM customer
GROUP BY `Cust Region`, `Cust State`
ORDER BY Total_Customers DESC;
-- ---------------------------------------------------------------------------------------------------------------------------
-- 5.Sales Trend by Season (Helps identify peak sales seasons.)
SELECT 
    c.`Season`,
    c.`Fiscal Year`,
    COUNT(f.`Order Number`) AS Total_Orders
FROM f_sales f
JOIN calendar c ON f.`Date` = c.`Date`
GROUP BY c.`Season`, c.`Fiscal Year`
ORDER BY c.`Fiscal Year`, Total_Orders DESC;
-- ----------------------------------------------------------------------------------------------------
-- 6.store Rent vs Sales Activity (Evaluate which stores have the best rent efficiency.)
SELECT 
    s.`Store Name`,
    s.`Store City`,
    s.`Store State`,
    s.`Monthly Rent Cost`,
    COUNT(f.`Order Number`) AS Orders,
    ROUND(COUNT(f.`Order Number`) / s.`Monthly Rent Cost`, 2) AS Orders_per_Rent
FROM f_sales f
JOIN d_store s ON f.`Store Key` = s.`Store Key`
GROUP BY s.`Store Name`, s.`Store City`, s.`Store State`, s.`Monthly Rent Cost`
ORDER BY Orders_per_Rent DESC;
-- -----------------------------------------------------------------------------------------------------------------------------------
-- 7.Most Active States by Sales Volume Which states contribute most to total orders.
SELECT 
    s.`Store State`,
    COUNT(f.`Order Number`) AS Total_Orders
FROM f_sales f
JOIN d_store s ON f.`Store Key` = s.`Store Key`
GROUP BY s.`Store State`
ORDER BY Total_Orders DESC
LIMIT 10;
-- -------------------------------------------------------------------------------------------------
-- 8.Top 10 Store Regions by Sales Frequency Summarizes regional activity across all stores.
SELECT 
    s.`Store Region`,
    COUNT(f.`Order Number`) AS Total_Orders
FROM f_sales f
JOIN d_store s ON f.`Store Key` = s.`Store Key`
GROUP BY s.`Store Region`
ORDER BY Total_Orders DESC
LIMIT 10;
-- -------------------------------------------------------------------------------------------------------
-- ️9.Stores with Highest Employee Count Find stores with the largest workforce.
SELECT 
    `Store Name`,
    `Store City`,
    `Store State`,
    `Number of Employees`
FROM d_store
ORDER BY `Number of Employees` DESC
LIMIT 10;
-- -----------------------------------------------------------------------------------------------
-- Stores with Highest Rent Find stores incurring the highest monthly rent cost.
SELECT 
    `Store Name`,
    `Store City`,
    `Store State`,
    `Monthly Rent Cost`
FROM d_store
ORDER BY `Monthly Rent Cost` DESC
LIMIT 10;
-- --------------------------------------------------------------------------------------
-- Top 10 Months by Sales Activity Find peak sales months across all stores.
SELECT 
    DATE_FORMAT(f.`Date`, '%Y-%m') AS Sales_Month,
    COUNT(f.`Order Number`) AS Total_Orders
FROM f_sales f
GROUP BY Sales_Month
ORDER BY Total_Orders DESC
LIMIT 10;
-- -----------------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------------------------------











