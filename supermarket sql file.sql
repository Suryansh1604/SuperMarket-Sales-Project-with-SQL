use supermarket;

show tables;


# 1 A What is the average wholesale price for each Category Name 
# (e.g., 'Edible Mushroom') across the entire period in annex3.csv?

SELECT ic.`Category Name`,
       AVG(wp.`Wholesale Price (RMB/kg)`) AS AvgWholesalePrice
FROM `wholesale_price` wp
JOIN `item_category` ic
  ON wp.`Item Code` = ic.`Item Code`
GROUP BY ic.`Category Name`
order by AvgWholesalePrice desc;



# This table shows the average wholesale price of each category.






#1 B Identify the Top 5 items with the highest and lowest average wholesale price over the entire 
# available period.

SELECT ic.`Category Name` AS `Category Name`,
       AVG(wp.`Wholesale Price (RMB/kg)`) AS `avg_wholesale_price`
FROM `item_category` AS ic
LEFT JOIN `wholesale_price` AS wp
ON ic.`item code` = wp.`item code`
GROUP BY 
	ic.`Category Name`
ORDER BY
	`avg_wholesale_price` DESC;
    
# Top 5 Category by avg_wholesale_price
# Aquatic Tuberous Vegetables, Capsicum, Edible Mushroom, Cabbage, Solanum

#Bottom 5 Category by avg_wholesale_price
# Capsicum, Edible Mushroom, Cabbage, Solanum, Flower/LeafÂ Vegetables






# 1 C Calculate the month-over-month (MoM) percentage change in the average 
-- wholesale price for the overall category.

WITH monthly_avg AS (
    SELECT 
        ic.`Category Name`,
        YEAR(STR_TO_DATE(wp.`Date`, '%Y-%m-%d')) AS Year,
        MONTH(STR_TO_DATE(wp.`Date`, '%Y-%m-%d')) AS Month,
        AVG(wp.`Wholesale Price (RMB/kg)`) AS AvgWholesalePrice
    FROM `wholesale_price` wp
    JOIN `item_category` ic
      ON wp.`Item Code` = ic.`Item Code`
    GROUP BY ic.`Category Name`, Year, Month
),
with_mom AS (
    SELECT 
        `Category Name`,
        Year,
        Month,
        COALESCE(
            ((AvgWholesalePrice - LAG(AvgWholesalePrice) OVER (
                PARTITION BY `Category Name` 
                ORDER BY Year, Month
            )) / LAG(AvgWholesalePrice) OVER (
                PARTITION BY `Category Name` 
                ORDER BY Year, Month
            )) * 100,
            0
        ) AS MoM_Percent_Change
    FROM monthly_avg
)
SELECT 
    `Category Name`,
    0 AS `_Jan`,  -- baseline
    MAX(CASE WHEN Month = 2 THEN MoM_Percent_Change END) AS `Jan_Feb`,
    MAX(CASE WHEN Month = 3 THEN MoM_Percent_Change END) AS `Feb_Mar`,
    MAX(CASE WHEN Month = 4 THEN MoM_Percent_Change END) AS `Mar_Apr`,
    MAX(CASE WHEN Month = 5 THEN MoM_Percent_Change END) AS `Apr_May`,
    MAX(CASE WHEN Month = 6 THEN MoM_Percent_Change END) AS `May_Jun`,
    MAX(CASE WHEN Month = 7 THEN MoM_Percent_Change END) AS `Jun_Jul`,
    MAX(CASE WHEN Month = 8 THEN MoM_Percent_Change END) AS `Jul_Aug`,
    MAX(CASE WHEN Month = 9 THEN MoM_Percent_Change END) AS `Aug_Sep`,
    MAX(CASE WHEN Month = 10 THEN MoM_Percent_Change END) AS `Sep_Oct`,
    MAX(CASE WHEN Month = 11 THEN MoM_Percent_Change END) AS `Oct_Nov`,
    MAX(CASE WHEN Month = 12 THEN MoM_Percent_Change END) AS `Nov_Dec`
FROM with_mom
GROUP BY `Category Name`
ORDER BY `Category Name`;

# Below is the table showing month over month change in average price of each category






#1 D
WITH monthly_volatility AS (
    SELECT 
        ic.`Item Name`,
        YEAR(STR_TO_DATE(wp.`Date`, '%Y-%m-%d')) AS Year,
        MONTH(STR_TO_DATE(wp.`Date`, '%Y-%m-%d')) AS Month,
        STDDEV(wp.`Wholesale Price (RMB/kg)`) AS MonthlyStdDev
    FROM `wholesale_price` wp
    JOIN `item_category` ic
      ON wp.`Item Code` = ic.`Item Code`
    GROUP BY ic.`Item Name`, Year, Month
)
SELECT 
    `Item Name`,
    AVG(MonthlyStdDev) AS AvgMonthlyVolatility
FROM monthly_volatility
GROUP BY `Item Name`
ORDER BY AvgMonthlyVolatility DESC
LIMIT 10;

# These are the top 10 item which are highly volatile by month.
# Sichuan Red Cedar, Honghu Lotus Root, Millet Pepper, 7 Colour Pepper (2), Chinese Cabbage, Chinese Caterpillar Fungus Flowers (Box) (1), Wild Lotus Root (2), Red Hang Pepper, 7 Colour Pepper (1), Fruit Chili







# 1 E What is the average price of items with a Loss Rate (%) greater than 15% 
# compared to items with a Loss Rate less than 5%? 

SELECT 
    CASE 
        WHEN lr.`Loss Rate (%)` > 15 THEN 'High Loss (>15%)'
        WHEN lr.`Loss Rate (%)` < 5 THEN 'Low Loss (<5%)'
    END AS LossRateGroup,
    AVG(wp.`Wholesale Price (RMB/kg)`) AS AvgWholesalePrice
FROM `wholesale_price` wp
JOIN `loss_rate` lr
  ON wp.`Item Code` = lr.`ï»¿Item Code`
JOIN `item_category` ic
  ON wp.`Item Code` = ic.`Item Code`
WHERE lr.`Loss Rate (%)` > 15
   OR lr.`Loss Rate (%)` < 5
GROUP BY LossRateGroup;

# Items with high loss has high average wholesale price it means that expensive product 
# has a high chance of loss rate





#2 A Which Category Name has the highest average Loss Rate (%)?

SELECT 
    ic.`Category Name`,
    AVG(lr.`Loss Rate (%)`) AS AvgLossRate
FROM `loss_rate` lr
right JOIN `item_category` ic
  ON lr.`ï»¿Item Code` = ic.`Item Code`
GROUP BY ic.`Category Name`
ORDER BY AvgLossRate DESC
limit 1;

# Cabbage Category has the highest average loss rate. It means marketing and sales effort
# required in this category.






#2 B List all Item Names that have a Loss Rate (%) of 0.00 and their corresponding Category Name.

SELECT 
    ic.`Item Name`,
    ic.`Category Name`,
    lr.`Loss Rate (%)`
FROM `loss_rate` lr
JOIN `item_category` ic
  ON lr.`ï»¿Item Code` = ic.`Item Code`
WHERE lr.`Loss Rate (%)` = 0.00;

# These are the profitable items as they have a loss rate of 0% it means they are not having any loss.







# 2 C Identify the 5 most valuable items lost by calculating Average Wholesale Price * Loss Rate (%) and ranking them. 
# This can help prioritize inventory management efforts.

WITH avg_price AS (
    SELECT 
        wp.`Item Code`,
        AVG(wp.`Wholesale Price (RMB/kg)`) AS AvgWholesalePrice
    FROM `wholesale_price` wp
    GROUP BY wp.`Item Code`
)
SELECT 
    ic.`Item Name`,
    ap.AvgWholesalePrice,
    lr.`Loss Rate (%)`,
    (ap.AvgWholesalePrice * lr.`Loss Rate (%)`) AS ValueLost
FROM avg_price ap
JOIN `loss_rate` lr
  ON ap.`Item Code` = lr.`ï»¿Item Code`
JOIN `item_category` ic
  ON ap.`Item Code` = ic.`Item Code`
ORDER BY ValueLost DESC
LIMIT 5;

-- Top 5 Items with high value lost
-- Chicken Fir Bacteria, Huanghuacai, Black Chicken Mushroom, Black Porcini, Honghu Lotus Root
-- These items should be ordered when in demand and other time discount should be used to remove 
-- these products from inventory.






# 3 A Plot the (monthly or quarterly average) trend of
#  the wholesale price for the top 3 items by Quantity_sold

# Top 3 product by Quantity Sold
SELECT 
    ic.`Item Name`,
    SUM(s.`Quantity Sold (kilo)`) AS TotalQuantity
FROM sales s
JOIN item_category ic
  ON s.`Item Code` = ic.`Item Code`
GROUP BY ic.`Item Name`
ORDER BY TotalQuantity DESC
LIMIT 3;

WITH monthly_avg AS (
    SELECT 
        ic.`Item Name`,
        YEAR(wp.`Date`) AS Year,
        MONTH(wp.`Date`) AS Month,
        AVG(wp.`Wholesale Price (RMB/kg)`) AS AvgPrice
    FROM wholesale_price wp
    JOIN item_category ic ON wp.`Item Code` = ic.`Item Code`
    WHERE YEAR(wp.`Date`) BETWEEN 2021 AND 2023
      AND ic.`Item Name` IN ('Wuhu Green Pepper (1)', 'Broccoli', 'Net Lotus Root (1)')
    GROUP BY ic.`Item Name`, YEAR(wp.`Date`), MONTH(wp.`Date`)
)
SELECT 
    `Item Name`,
    ROUND(AVG(CASE WHEN Year=2021 AND Month=1  THEN AvgPrice END),2) AS `2021-01`,
    ROUND(AVG(CASE WHEN Year=2021 AND Month=2  THEN AvgPrice END),2) AS `2021-02`,
    ROUND(AVG(CASE WHEN Year=2021 AND Month=3  THEN AvgPrice END),2) AS `2021-03`,
    ROUND(AVG(CASE WHEN Year=2021 AND Month=4  THEN AvgPrice END),2) AS `2021-04`,
    ROUND(AVG(CASE WHEN Year=2021 AND Month=5  THEN AvgPrice END),2) AS `2021-05`,
    ROUND(AVG(CASE WHEN Year=2021 AND Month=6  THEN AvgPrice END),2) AS `2021-06`,
    ROUND(AVG(CASE WHEN Year=2021 AND Month=7  THEN AvgPrice END),2) AS `2021-07`,
    ROUND(AVG(CASE WHEN Year=2021 AND Month=8  THEN AvgPrice END),2) AS `2021-08`,
    ROUND(AVG(CASE WHEN Year=2021 AND Month=9  THEN AvgPrice END),2) AS `2021-09`,
    ROUND(AVG(CASE WHEN Year=2021 AND Month=10 THEN AvgPrice END),2) AS `2021-10`,
    ROUND(AVG(CASE WHEN Year=2021 AND Month=11 THEN AvgPrice END),2) AS `2021-11`,
    ROUND(AVG(CASE WHEN Year=2021 AND Month=12 THEN AvgPrice END),2) AS `2021-12`,
    ROUND(AVG(CASE WHEN Year=2022 AND Month=1  THEN AvgPrice END),2) AS `2022-01`,
    ROUND(AVG(CASE WHEN Year=2022 AND Month=2  THEN AvgPrice END),2) AS `2022-02`,
    ROUND(AVG(CASE WHEN Year=2022 AND Month=3  THEN AvgPrice END),2) AS `2022-03`,
    ROUND(AVG(CASE WHEN Year=2022 AND Month=4  THEN AvgPrice END),2) AS `2022-04`,
    ROUND(AVG(CASE WHEN Year=2022 AND Month=5  THEN AvgPrice END),2) AS `2022-05`,
    ROUND(AVG(CASE WHEN Year=2022 AND Month=6  THEN AvgPrice END),2) AS `2022-06`,
    ROUND(AVG(CASE WHEN Year=2022 AND Month=7  THEN AvgPrice END),2) AS `2022-07`,
    ROUND(AVG(CASE WHEN Year=2022 AND Month=8  THEN AvgPrice END),2) AS `2022-08`,
    ROUND(AVG(CASE WHEN Year=2022 AND Month=9  THEN AvgPrice END),2) AS `2022-09`,
    ROUND(AVG(CASE WHEN Year=2022 AND Month=10 THEN AvgPrice END),2) AS `2022-10`,
    ROUND(AVG(CASE WHEN Year=2022 AND Month=11 THEN AvgPrice END),2) AS `2022-11`,
    ROUND(AVG(CASE WHEN Year=2022 AND Month=12 THEN AvgPrice END),2) AS `2022-12`,
    ROUND(AVG(CASE WHEN Year=2023 AND Month=1  THEN AvgPrice END),2) AS `2023-01`,
    ROUND(AVG(CASE WHEN Year=2023 AND Month=2  THEN AvgPrice END),2) AS `2023-02`,
    ROUND(AVG(CASE WHEN Year=2023 AND Month=3  THEN AvgPrice END),2) AS `2023-03`,
    ROUND(AVG(CASE WHEN Year=2023 AND Month=4  THEN AvgPrice END),2) AS `2023-04`,
    ROUND(AVG(CASE WHEN Year=2023 AND Month=5  THEN AvgPrice END),2) AS `2023-05`,
    ROUND(AVG(CASE WHEN Year=2023 AND Month=6  THEN AvgPrice END),2) AS `2023-06`
FROM monthly_avg
GROUP BY `Item Name`
ORDER BY `Item Name`;

# Run this query to find out the monthly trend of top 3 product by quantity sold.






# 3 B Which day of the week (Monday, Tuesday, etc.) or which month
# exhibits the highest/lowest average wholesale prices?

select
	dayname(`Date`) as weekday,
    avg(`Wholesale Price (RMB/kg)`) as wholesale_price
from
	wholesale_price
group by
	weekday
order by 
	wholesale_price desc;
    
# Wednesday has the hightest avg wholesale_price and Monday has the lowest avg wholesale_price 
    
select
	monthname(`Date`) as monthname,
    avg(`Wholesale Price (RMB/kg)`) as wholesale_price 
from
	wholesale_price
group by
	monthname
order by 
	wholesale_price desc;

# Febrary has the hightest avg wholesale_price in monthname and
# August has the lowest avg wholesale_price in monthname 	












# 4 A Calculate the total sales revenue for each Category Name by multiplying Unit Selling Price (RMB/kg) from annex2.csv
# and Sales Volume (kg) from the hypothetical annex2 data.

# below is the query for revenue for each category
SELECT 
    ic.`Item Name`,
    SUM(s.`Unit Selling Price (RMB/kg)` * s.`Quantity Sold (kilo)`) AS TotalSalesValue
FROM sales s
JOIN item_category ic
  ON s.`Item Code` = ic.`Item Code`
GROUP BY ic.`Item Name`
ORDER BY TotalSalesValue DESC
LIMIT 10;







# 4 B Identify the Top 10 performing items based on total sales volume over the entire period.
SELECT 
    ic.`Item Name`,
    SUM(s.`Unit Selling Price (RMB/kg)` * s.`Quantity Sold (kilo)`) AS TotalSalesValue
FROM sales s
JOIN item_category ic
  ON s.`Item Code` = ic.`Item Code`
GROUP BY ic.`Item Name`
ORDER BY TotalSalesValue DESC
LIMIT 10;

# Below are the top 10 item by Total Sales Volume
# Broccoli, Net Lotus Root (1), Xixia Mushroom (1), Wuhu Green Pepper (1), 
# Yunnan Shengcai, Eggplant (2), Paopaojiao (Jingpin), Luosi Pepper, Yunnan Lettuces, Chinese Cabbage



