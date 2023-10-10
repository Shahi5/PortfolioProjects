-- SQL query for collecting the cancelled orders dataset from the amazon sales report.

SELECT 
	--[index]
	  [Order ID],
      [Date],
	  FORMAT(a.Date, 'MMMM') AS Month_name, -- query to create a column for month taken from the date column.
      [Status],
      [Fulfilment],
      -- [Sales Channel ]
      [ship-service-level],
      -- [Style]
      -- [SKU]
      -- [Category]
	  -- [ASIN]
      -- [Size],
      [Courier Status],
      -- [Qty],
      -- [currency]
       [Amount],
	   CASE 
	   WHEN a.Amount < 1000 THEN 'Low range' 
	   WHEN a.Amount >= 1000 AND a.Amount < 2000 THEN 'Mid range'
	   WHEN a.Amount >= 2000 AND a.Amount < 4000 THEN 'Upper-mid range'
	   WHEN a.Amount >= 4000 THEN 'High range'
	   END AS Price_range, -- CASE statement for separating the amount of products into different price ranges.
      -- [ship-city]
      [ship-state]
      -- [ship-postal-code]
      -- [ship-country]
      -- [promotion-ids]
      -- [B2B]
      -- [fulfilled-by]
      -- [Unnamed: 22]
  FROM [amazon].[dbo].['Amazon Sale Report$'] AS a
  WHERE Status = 'Cancelled' -- condition for obtaining only the cancelled orders from the sales report dataset.
