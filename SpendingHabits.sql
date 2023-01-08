USE PortfolioProject

SELECT *
FROM
Chase;

---Drop empty columns from the 
ALTER TABLE Chase
DROP COLUMN 
F7, F8, F9, F10, F11, F12, F13, F14, F15, F16, F17, F18, F19, F20, F21, F22, F23, F24, F25, F26;

--Formatting everything to lower case
UPDATE Chase
SET Details = LOWER(details);
UPDATE Chase
SET Description = LOWER(Description);

---Remove credit and only focus on spending
DELETE FROM Chase
WHERE Details = 'credit' OR Details = 'dslip';

UPDATE Chase
SET Amount = Amount * -1;

---Add purchase date, year and month columns to the data set and insert year and month into the column
ALTER TABLE Chase
ADD Purchasingdate date;

ALTER TABLE Chase
ADD PurchaseMonth INT;

ALTER TABLE Chase
ADD PurchaseYear INT;

--Add date to the purchase date column
UPDATE Chase
SET PurchasingDate = CAST(PostingDate AS date);
--Add month to purchasing month column
UPDATE Chase
SET PurchaseMonth = MONTH(PurchasingDate);
--Add year to purchasing year column
UPDATE Chase
SET PurchaseYear = YEAR(PurchasingDate);

--Add categories such as groceries subscriptions
DROP VIEW Analytics;

--Creating a view to analyze the data in dashboard
CREATE VIEW Analytics AS 
	SELECT Details, Description, Amount, purchasingdate, purchasemonth, purchaseyear,
		CASE
			WHEN Description LIKE '%texas%' THEN 'College' 
			WHEN Description LIKE '%zone%' 	THEN 'Housing'
			WHEN Description LIKE '%acorn%' OR 
				Description LIKE '%transfer%' OR 
				Description LIKE '%gemini%' 
			THEN 'Saving'
			WHEN Description LIKE '%tmobile%' OR 
				Description LIKE '%sprint%' 
			THEN 'Mobile'
			WHEN Description LIKE '%h-e-b%' OR
				Description LIKE '%costco%' OR
				Description LIKE '%wal%' OR
				Description LIKE '%shoprite%' OR
				Description LIKE '%kroger%' OR
				Description LIKE '%asian%' OR
				Description LIKE '%uber%' OR
				Description LIKE '%mcdonald%' OR
				Description LIKE '%zell%' OR
				Description LIKE '%doordash%' OR
				Description LIKE '%valley%' OR
				Description LIKE '%domino%' OR 
				Description LIKE '%grubhub%' OR
				Description LIKE '%dunkin%' OR
				Description LIKE '%starbucks%'
			THEN 'Food'
			WHEN Description LIKE '%hulu%' OR
				Description LIKE '%spotify%' OR
				Description LIKE '%netflix%' OR 
				Description LIKE '%trading%' OR
				Description LIKE '%investor%' THEN 'Subscription' 
			WHEN Description LIKE '%discover%' THEN 'Credit Card'
		ELSE 'Others'
		END AS Categories

FROM 
Chase;

SELECT * FROM 
Analytics
WHERE Categories= 'others' ; 

SELECT PurchaseYear, Categories, SUM(Amount) AS Total 
FROM 
Analytics
WHERE Categories= 'other'
GROUP BY PurchaseYear, Categories
ORDER BY Categories, Purchaseyear ASC;
