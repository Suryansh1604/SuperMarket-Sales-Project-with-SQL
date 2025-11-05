# Price and Loss Optimization for Fresh Produce

## Project Goal

The primary objective is to analyze wholesale price fluctuations and product loss rates to identify high-risk, high-reward items and categories, providing actionable insights for pricing strategy, procurement, and inventory management.

---

## I. Price & Cost Analysis

### 1. Average Wholesale Price by Category

The average wholesale price provides a baseline understanding of product value across the entire period.

| Category Name | Trend |
|:--------------|:------|
| Aquatic Tuberous Vegetables | Highest Average Price |
| Capsicum | High Average Price |
| Edible Mushroom | Moderate Average Price |
| Cabbage | Moderate-Low Average Price |
| Flower/Leaf Vegetables | Lowest Average Price |

### 2. Top/Bottom 5 Items by Average Wholesale Price

This identifies the most and least expensive product categories over the available period.

#### Top 5 Categories (Highest Price)

1. Aquatic Tuberous Vegetables
2. Capsicum
3. Edible Mushroom
4. Cabbage
5. Solanum

#### Bottom 5 Categories (Lowest Price)

1. Flower/Leaf Vegetables
2. Solanum
3. Cabbage
4. Edible Mushroom
5. Capsicum

> **Note:** Cabbage, Solanum, and Capsicum appear in both lists, suggesting significant price variation within those categories.

### 3. Price Volatility Analysis (Top 10)

Volatility is measured by the average monthly standard deviation of the wholesale price. These items present the highest risk/reward profiles.

#### Top 10 Most Volatile Items

1. Sichuan Red Cedar
2. Honghu Lotus Root
3. Millet Pepper
4. 7 Colour Pepper (2)
5. Chinese Cabbage
6. Chinese Caterpillar Fungus Flowers (Box) (1)
7. Wild Lotus Root (2)
8. Red Hang Pepper
9. 7 Colour Pepper (1)
10. Fruit Chili

### 4. Loss Rate vs. Price Comparison

There is a clear relationship between product cost and loss rate.

**Key Finding:** Items with **High Loss Rate (>15%)** have a higher average wholesale price than items with **Low Loss Rate (<5%)**.

> **Insight:** Expensive products have a high chance of loss, justifying increased investment in superior storage, handling, or faster inventory turnover for these goods.

---

## II. Inventory & Loss Rate Analysis

### 1. Category with Highest Average Loss Rate

The **Cabbage** category has the highest average Loss Rate (%).

> **Actionable Insight:** Marketing, sales efforts, or improved supply chain handling must be prioritized for the Cabbage category to minimize financial loss.

### 2. Zero Loss Rate Items

The following items have a Loss Rate (%) of **0.00**, indicating high inventory stability and profitability:

| Item Name | Category Name |
|:----------|:--------------|
| Lajiao Eggplant | Solanum |
| Small Purple Cabbage | Flower/Leaf Vegetables |
| Mushroom (Mixed) | Edible Mushroom |
| Mushroom (Mixed) | Edible Mushroom |

### 3. Most Valuable Items Lost (Top 5)

Value Lost is calculated as: `Average Wholesale Price × Loss Rate (%)`

Prioritizing these five items will maximize inventory management impact.

#### Top 5 Items with High Value Lost

1. Chicken Fir Bacteria
2. Huanghuacai
3. Black Chicken Mushroom
4. Black Porcini
5. Honghu Lotus Root

> **Actionable Insight:** These items are the most crucial for inventory management. Procurement should be highly responsive to demand, and immediate clearance strategies (like discounts) should be employed to reduce inventory when supply exceeds short-term sales forecasts.

---

## III. Time-Series and Trend Analysis

### 1. Price Trend for Top 3 Selling Items

The top 3 items by Quantity Sold are:

- Wuhu Green Pepper (1)
- Broccoli
- Net Lotus Root (1)

A monthly trend of their average wholesale price provides a basis for sales forecasting and price stability analysis over the 2021-2023 period.

### 2. Highest/Lowest Average Wholesale Prices

Average wholesale price varies significantly by time period:

#### By Day of the Week

- **Highest:** Wednesday
- **Lowest:** Monday

> **Insight:** The best time for procurement to capture lower prices may be earlier in the week.

#### By Month

- **Highest:** February
- **Lowest:** August

> **Insight:** February's high price is likely due to seasonal scarcity or New Year effects, while August's low price is typical of peak harvest season.

### 3. Largest Single-Day Price Drop

The largest single-day price drop (in absolute RMB) occurred for a specific item on a specific date, as identified by the LAG function in the dedicated query.

---

## IV. Sales & Performance Analysis

### 1. Top 10 Performing Items (Total Sales Value)

Total Sales Value is calculated as: `Unit Selling Price × Quantity Sold`

These items are the primary revenue drivers.

#### Top 10 Performing Items

1. Broccoli
2. Net Lotus Root (1)
3. Xixia Mushroom (1)
4. Wuhu Green Pepper (1)
5. Yunnan Shengcai
6. Eggplant (2)
7. Paopaojiao (Jingpin)
8. Luosi Pepper
9. Yunnan Lettuces
10. Chinese Cabbage

> **Insight:** Items like Broccoli and Net Lotus Root (1) are simultaneously top sellers and among the most-sold by volume, making them the most critical items to maintain stock and protect from loss.

---

## Summary

This analysis provides comprehensive insights into:

- Price volatility and risk assessment
- Loss rate patterns and high-risk categories
- Temporal pricing trends for strategic procurement
- Revenue-driving products requiring priority management

### Key Recommendations

1. Focus inventory management on high-value loss items
2. Optimize procurement timing based on weekly/monthly price patterns
3. Implement enhanced handling for volatile, high-price items
4. Prioritize the Cabbage category for loss reduction initiatives
