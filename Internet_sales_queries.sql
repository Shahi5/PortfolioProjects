-- 1. Cleaned DimDate table -- 
-- Records related to date which is greater than or equal to 2020

SELECT
[DateKey], 
  [FullDateAlternateKey] AS Date,
  --  ,[DayNumberOfWeek],
  [EnglishDayNameOfWeek] AS Day,
  -- ,[SpanishDayNameOfWeek]
  -- ,[FrenchDayNameOfWeek]
  -- ,[DayNumberOfMonth]
  -- ,[DayNumberOfYear], 
  [WeekNumberOfYear] AS WeekNr, 
  [EnglishMonthName] AS Month,
  LEFT([EnglishMonthName],3) AS Monthshort,
  -- ,[SpanishMonthName]
  -- ,[FrenchMonthName], 
  [MonthNumberOfYear] AS MonthNo, 
  [CalendarQuarter] AS Quarter, 
  [CalendarYear] AS year 
  -- ,[CalendarSemester]
  -- ,[FiscalQuarter]
  --,[FiscalYear]
  --,[FiscalSemester]
FROM 
  [AdventureWorksDW2022].[dbo].[DimDate]
WHERE CalendarYear >= 2020;



-- 2. Cleaned customer table -- 
-- Left join on the customer and geography table with the help of common geographykey column on both tables. 

SELECT
	   c.[CustomerKey] AS [Customer Key],
     -- ,[GeographyKey]
     -- ,[CustomerAlternateKey]
     -- ,[Title]
      c.[FirstName] AS [First name],
     -- ,[MiddleName]
      c.[LastName] AS [Last name], 
	 c.[FirstName] + '' + c.[LastName] AS [Full Name],
     -- ,[NameStyle]
     -- ,[BirthDate]
     -- ,[MaritalStatus]
     -- ,[Suffix]
CASE c.Gender WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' END AS Gender,
	 -- ,[Gender]
     -- ,[EmailAddress]
     -- ,[YearlyIncome]
     -- ,[TotalChildren]
     -- ,[NumberChildrenAtHome]
     -- ,[EnglishEducation]
     -- ,[SpanishEducation]
     -- ,[FrenchEducation]
     -- ,[EnglishOccupation]
     -- ,[SpanishOccupation]
     -- ,[FrenchOccupation]
     -- ,[HouseOwnerFlag]
     -- ,[NumberCarsOwned]
     -- ,[AddressLine1]
     -- ,[AddressLine2]
     -- ,[Phone]
      c.[DateFirstPurchase] AS DateFirstPurchase,
      --,[CommuteDistance]
	  g.City AS [Customer city] -- Joining Customer City from Geography Table
  FROM 
  [AdventureWorksDW2022].[dbo].[DimCustomer] AS c
  LEFT JOIN [AdventureWorksDW2022].[dbo].[DimGeography] AS g ON c.GeographyKey = g.GeographyKey -- Left join on customer and gerography table
  ORDER BY 
  [Customer Key] ASC  -- Setting the customer key in ascending order



  -- 3. Cleaned DimProduct table -- 
  -- Joining two more tables productsubcategory and product category tables using the left join query

SELECT
	p.[ProductKey],
      p.[ProductAlternateKey] AS ProductItemCode, 
     -- ,[ProductSubcategoryKey]
     -- ,[WeightUnitMeasureCode]
     -- ,[SizeUnitMeasureCode]
      p.[EnglishProductName] AS [Product Name],
	  ps.[EnglishProductSubcategoryName] AS [Sub Category],  -- Joined from subcategory table
	  pc.[EnglishProductCategoryName] AS [Product Category], -- Joined fromc ategory table 
     -- ,[SpanishProductName]
     -- ,[FrenchProductName]
     -- ,[StandardCost]
     -- ,[FinishedGoodsFlag]
      p.[Color] AS [Product Color],
     -- ,[SafetyStockLevel]
     -- ,[ReorderPoint]
     -- ,[ListPrice]
      p.[Size] AS [Product Size],
     -- ,[SizeRange]
     -- ,[Weight]
     -- ,[DaysToManufacture]
      p.[ProductLine] AS [Product Line],
     -- ,[DealerPrice]
     -- ,[Class]
     -- ,[Style]
      p.[ModelName] AS [Product Model Name],
     -- ,[LargePhoto]
      p.[EnglishDescription] AS [Product Description],
     -- ,[FrenchDescription]
     -- ,[ChineseDescription]
     -- ,[ArabicDescription]
     -- ,[HebrewDescription]
     -- ,[ThaiDescription]
     -- ,[GermanDescription]
     -- ,[JapaneseDescription]
     -- ,[TurkishDescription]
     -- ,[StartDate]
     -- ,[EndDate]
     ISNULL (p.[Status], 'Outdated') AS [Product status]
  FROM 
  [AdventureWorksDW2022].[dbo].[DimProduct] AS p 
  LEFT JOIN [AdventureWorksDW2022].[dbo].[DimProductSubcategory] AS ps ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey 
  LEFT JOIN  [AdventureWorksDW2022].[dbo].[DimProductCategory] AS pc ON ps.ProductCategoryKey = pc.ProductCategoryKey

  ORDER BY

  p.ProductKey ASC -- setting the product key in ascending order for the table 


  -- 4. Cleaned FactInternetSales -- 
  -- The data on internet sales made on the last three years. 

SELECT 
	   [ProductKey],
       [OrderDateKey],
       [DueDateKey],
       [ShipDateKey],
       [CustomerKey],
     -- ,[PromotionKey]
     -- ,[CurrencyKey]
     -- ,[SalesTerritoryKey]
       [SalesOrderNumber], 
     -- ,[SalesOrderLineNumber]
     -- ,[RevisionNumber]
     -- ,[OrderQuantity]
     -- ,[UnitPrice]
     -- ,[ExtendedAmount]
     -- ,[UnitPriceDiscountPct]
     -- ,[DiscountAmount]
     -- ,[ProductStandardCost]
     -- ,[TotalProductCost]
      [SalesAmount]
     -- ,[TaxAmt]
     -- ,[Freight]
    --  ,[CarrierTrackingNumber]
     -- ,[CustomerPONumber]
     -- ,[OrderDate]
     -- ,[DueDate]
     -- ,[ShipDate]
  FROM [AdventureWorksDW2022].[dbo].[FactInternetSales]
  WHERE 
	LEFT (OrderDateKey, 4) >= YEAR(GETDATE()) -2  -- Ensures that we only bring two years of date from extraction (i.e. 2023 - 2 = 2021)
   
   ORDER BY [ProductKey] ASC 

