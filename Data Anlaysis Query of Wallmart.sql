SELECT 
    Time,
        CASE 
            WHEN Time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
            WHEN Time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
            ELSE 'Evening'
        END AS Time_of_date
FROM WalmartSales;

-- Adding new column : Time_of_date with Type Date VARCHAR (20)
BEGIN TRANSACTION;
BEGIN TRY
ALTER TABLE WalmartSales
ADD Time_of_date VARCHAR(20);
COMMIT TRANSACTION;
PRINT ('Data is being processing')
END TRY

BEGIN CATCH
ROLLBACK TRANSACTION;
PRINT('Data is cancel')
END CATCH;


--Input Value to Column Time_of_date with Morning, Afternoon or Evening.
BEGIN TRANSACTION;
BEGIN TRY
UPDATE WalmartSales
SET Time_of_date = (
                    CASE 
                        WHEN Time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
                        WHEN Time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
                        ELSE 'Evening'
                    END 
                    )
COMMIT TRANSACTION;
PRINT ('Data is being Processing')
END TRY

BEGIN CATCH
ROLLBACK TRANSACTION;
PRINT ('Data is cancel')
END CATCH;

-- day_name
SELECT
    Date,
    DATENAME(WEEKDAY,Date) AS day_name
FROM WalmartSales;

-- Adding new column : day_name with Type Date VARCHAR (10)
BEGIN TRANSACTION;
BEGIN TRY
ALTER TABLE WalmartSales
ADD day_name VARCHAR (10);
COMMIT TRANSACTION;
PRINT('Data is being processing')
END TRY 

BEGIN CATCH
ROLLBACK TRANSACTION;
PRINT('Data is cancel')
END CATCH;

-- Input value to day_name with The name of the day:
BEGIN TRANSACTION;
BEGIN TRY 
UPDATE Walmartsales
SET day_name = DATENAME(WEEKDAY,Date)
COMMIT TRANSACTION;
PRINT('Data is being processing')
END TRY

BEGIN CATCH
ROLLBACK TRANSACTION;
PRINT('Data is cancel')
END CATCH;

-- month_name
SELECT
    Date,
    DATENAME(MONTH,Date) AS day_name
FROM WalmartSales;

-- Adding new column : month_name with Type Date VARCHAR (10)
BEGIN TRANSACTION;
BEGIN TRY
ALTER TABLE WalmartSales
ADD month_name VARCHAR (10)
COMMIT TRANSACTION;
PRINT ('Data is being processing')
END TRY

BEGIN CATCH
ROLLBACK TRANSACTION;
PRINT ('Data is cancel')
END CATCH;

-- Input value to month_name with The name of the month:
BEGIN TRANSACTION;
BEGIN TRY 
UPDATE WalmartSales
SET month_name = DATENAME(MONTH,Date)
COMMIT TRANSACTION;
PRINT('Data is being processing')
END TRY 

BEGIN CATCH
ROLLBACK TRANSACTION;
PRINT('Data is cancel')
END CATCH;

-- GENERIC QUESTION --
--1.	How many unique cities does the data have?
SELECT
    DISTINCT (City) AS [Total Unique Cities]
FROM Walmartsales;

--2.	In which city is each branch?
SELECT
    DISTINCT (City),
    Branch  
FROM Walmartsales
ORDER BY Branch;


-- Product --
--1.	How many unique product lines does the data have?
SELECT
    DISTINCT ([Product line]) AS [Unique Product Lines]
FROM Walmartsales;

--2.	What is the most common payment method?
SELECT TOP 1
    Payment,
    COUNT(*) AS [Total Common Payment Method]
FROM Walmartsales
GROUP BY Payment
ORDER BY [Total Common Payment Method] DESC;

--3.	What is the most selling product line?
SELECT TOP 1
    [Product line],
    COUNT(*) AS [Most Selling Product Line]
FROM Walmartsales
GROUP BY [Product line]
ORDER BY [Most Selling Product Line] DESC;

--4.	What is the total revenue by month?
SELECT
    month_name,
    ROUND(SUM(Total),2) AS [Total Revenue]
FROM Walmartsales
GROUP BY month_name
ORDER BY [Total Revenue] DESC;

--5.	What month had the largest COGS?
SELECT TOP 1
    month_name,
    ROUND(SUM(cogs),2) AS [Total COGS]
FROM Walmartsales
GROUP BY month_name
ORDER BY [Total COGS] DESC;

--6.	What product line had the largest revenue?
SELECT 
    [Product line],
    ROUND(SUM(Total),2) AS [Total Revenue Product]
FROM Walmartsales
GROUP BY [Product line]
ORDER BY [Total Revenue Product] DESC;

--7.	What is the city with the largest revenue?
SELECT TOP 1
    Branch,
    City,
    ROUND(SUM(Total),1) AS [Total Revenue]
FROM Walmartsales
GROUP BY Branch,City
ORDER BY [Total Revenue] DESC;

-- 8.	What product line had the largest VAT?
SELECT --TOP 1
    [Product line],
    AVG([Tax 5%]) AS [Average Tax]
FROM Walmartsales
GROUP BY [Product line]
ORDER BY [Average Tax] DESC;

--9.	Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
WITH AverageSales AS (
    SELECT
        [Product line],
        AVG([Total]) AS AvgSales
    FROM
        Walmartsales
    GROUP BY
        [Product line]
)

SELECT
    W.*,
    CASE
        WHEN W.[Total] > A.AvgSales THEN 'Good'
        ELSE 'Bad'
    END AS SalesCategory
FROM
    Walmartsales W
JOIN
    AverageSales A ON W.[Product line] = A.[Product line];


--10.	Which branch sold more products than average product sold?
SELECT
    Branch,
    SUM(Quantity) AS [Total Quantity]
FROM Walmartsales
GROUP BY Branch
HAVING SUM(Quantity) > (SELECT AVG(Quantity) FROM Walmartsales);

--11.	What is the most common product line by gender?
SELECT
    [Product line],
    gender,
    COUNT(gender) AS [Most Common Product By Gender]
FROM Walmartsales
GROUP BY [Product line],gender
ORDER BY [Most Common Product By Gender] DESC;

--12.	What is the average rating of each product line?
SELECT
    [Product line],
    ROUND(AVG(Rating),2) AS [Average Rating]
FROM Walmartsales
GROUP BY [Product line]
ORDER BY [Average Rating] DESC;

-- SALES --
--1.	Number of sales made in each time of the day per weekday
SELECT
    Time_of_date,
    COUNT(*) AS [Total Sales Daily]
FROM Walmartsales
WHERE day_name = 'Sunday'
GROUP BY time_of_date;

--2.	Which of the customer types brings the most revenue?
SELECT
    [Customer type],
    ROUND(SUM(Total),2) AS [Total Revenues]
FROM Walmartsales
GROUP BY [Customer type] 
ORDER BY [Total Revenues] DESC;

--3.	Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT 
    City,
    ROUND(AVG([Tax 5%]),2) AS [Average Tax]
FROM Walmartsales
GROUP BY City
ORDER BY [Average Tax] DESC;

--4.	Which customer type pays the most in VAT?
SELECT
    [Customer type],
    ROUND(AVG([Tax 5%]),2) AS [Average Tax]
FROM Walmartsales
GROUP BY [Customer type] 
ORDER BY [Average Tax] DESC;

-- CUSTOMER --
--1.	How many unique customer types does the data have? 2
SELECT
    DISTINCT [Customer type]
FROM Walmartsales;

--2.	How many unique payment methods does the data have? 3
SELECT
    DISTINCT [Payment]
FROM Walmartsales;

--3.	What is the most common customer type? Member
SELECT
    [Customer type],
    COUNT(*) AS [Total Common Customer Type] 
FROM Walmartsales
GROUP BY [Customer type] 
ORDER BY [Total Common Customer Type] DESC;

--4.	Which customer type buys the most? Member
SELECT
    [Customer type],
    COUNT(*) AS [Total Customer Type Buys]
FROM Walmartsales
GROUP BY [Customer type] 
ORDER BY [Total Customer Type Buys] DESC;

--5.	What is the gender of most of the customers? Female
SELECT 
    Gender,
    COUNT(*) AS [Total Gender] 
FROM Walmartsales
GROUP BY Gender
ORDER BY [Total Gender] DESC;

--6.	What is the gender distribution per branch?
SELECT 
    Branch,
    Gender,
    COUNT(*) AS [Total Gender] 
FROM Walmartsales
--WHERE Branch = 'A'
GROUP BY Branch,Gender
ORDER BY Branch,[Total Gender] DESC;

--7.	Which time of the day do customers give most ratings? Afternoon
SELECT
    Time_of_date,
    ROUND(AVG(Rating),2) AS [Average Rating]
FROM Walmartsales
GROUP BY Time_of_date
ORDER BY [Average Rating] DESC;

--8.	Which time of the day do customers give most ratings per branch?
SELECT
    Branch,
    Time_of_date,
    ROUND(AVG(Rating),2) AS [Average Rating]
FROM Walmartsales
GROUP BY Branch,Time_of_date
ORDER BY Branch,[Average Rating] DESC;

--9.	Which day of the week has the best avg ratings?
SELECT
    day_name,
    ROUND(AVG(Rating),2) AS [Average Rating]
FROM Walmartsales
GROUP BY day_name
ORDER BY [Average Rating] DESC;

--10.	Which day of the week has the best average ratings per branch?
SELECT
    Branch,
    day_name,
    ROUND(AVG(Rating),2) AS [Average Rating]
FROM Walmartsales
GROUP BY Branch,day_name
ORDER BY Branch,[Average Rating] DESC;
