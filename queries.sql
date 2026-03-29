-- ============================================
-- E-COMMERCE SQL ANALYSIS PROJECT
-- ============================================

-- Table structure
CREATE TABLE orders (
    order_id INT,
    customer_id INT,
    order_date DATE,
    product_category VARCHAR(50),
    amount DECIMAL(10,2),
    city VARCHAR(50)
);

-- ============================================
-- 1. Total Sales
-- ============================================
SELECT SUM(amount) AS total_sales
FROM orders;

-- ============================================
-- 2. Sales by Product Category
-- ============================================
SELECT product_category,
       SUM(amount) AS total_sales
FROM orders
GROUP BY product_category
ORDER BY total_sales DESC;

-- ============================================
-- 3. Top 5 Customers by Spending
-- ============================================
SELECT customer_id,
       SUM(amount) AS total_spent
FROM orders
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;

-- ============================================
-- 4. Monthly Sales Trend
-- MySQL version
-- ============================================
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month,
       SUM(amount) AS monthly_sales
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;

-- ============================================
-- 5. Average Order Value
-- ============================================
SELECT AVG(amount) AS avg_order_value
FROM orders;

-- ============================================
-- 6. Sales by City
-- ============================================
SELECT city,
       SUM(amount) AS total_sales
FROM orders
GROUP BY city
ORDER BY total_sales DESC;

-- ============================================
-- 7. Repeat Customers
-- ============================================
SELECT customer_id,
       COUNT(order_id) AS order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1
ORDER BY order_count DESC;

-- ============================================
-- 8. Highest Order Value per Customer
-- ============================================
SELECT customer_id,
       MAX(amount) AS highest_order
FROM orders
GROUP BY customer_id
ORDER BY highest_order DESC;

-- ============================================
-- 9. Daily Sales
-- ============================================
SELECT order_date,
       SUM(amount) AS daily_sales
FROM orders
GROUP BY order_date
ORDER BY order_date;

-- ============================================
-- 10. Running Total of Sales
-- ============================================
SELECT order_date,
       amount,
       SUM(amount) OVER (ORDER BY order_date, order_id) AS running_total
FROM orders
ORDER BY order_date, order_id;

-- ============================================
-- 11. Rank Customers by Total Spending
-- ============================================
SELECT customer_id,
       SUM(amount) AS total_spent,
       RANK() OVER (ORDER BY SUM(amount) DESC) AS spending_rank
FROM orders
GROUP BY customer_id;

-- ============================================
-- 12. Best-Selling Category
-- ============================================
SELECT product_category,
       SUM(amount) AS total_sales
FROM orders
GROUP BY product_category
ORDER BY total_sales DESC
LIMIT 1;

-- ============================================
-- 13. Customer Segmentation
-- ============================================
SELECT customer_id,
       SUM(amount) AS total_spent,
       CASE
           WHEN SUM(amount) > 1000 THEN 'High Value'
           WHEN SUM(amount) BETWEEN 500 AND 1000 THEN 'Medium Value'
           ELSE 'Low Value'
       END AS customer_segment
FROM orders
GROUP BY customer_id
ORDER BY total_spent DESC;

-- ============================================
-- 14. Most Recent Order per Customer
-- ============================================
SELECT order_id,
       customer_id,
       order_date,
       product_category,
       amount,
       city
FROM (
    SELECT o.*,
           ROW_NUMBER() OVER (
               PARTITION BY customer_id
               ORDER BY order_date DESC, order_id DESC
           ) AS rn
    FROM orders o
) t
WHERE rn = 1;

-- ============================================
-- 15. Top Category in Each City
-- ============================================
SELECT city,
       product_category,
       total_sales
FROM (
    SELECT city,
           product_category,
           SUM(amount) AS total_sales,
           RANK() OVER (
               PARTITION BY city
               ORDER BY SUM(amount) DESC
           ) AS rnk
    FROM orders
    GROUP BY city, product_category
) t
WHERE rnk = 1;

-- ============================================
-- 16. Customers with Above-Average Spending
-- ============================================
SELECT customer_id,
       SUM(amount) AS total_spent
FROM orders
GROUP BY customer_id
HAVING SUM(amount) > (
    SELECT AVG(customer_total)
    FROM (
        SELECT SUM(amount) AS customer_total
        FROM orders
        GROUP BY customer_id
    ) avg_table
)
ORDER BY total_spent DESC;

-- ============================================
-- 17. Orders Count by Category
-- ============================================
SELECT product_category,
       COUNT(order_id) AS total_orders
FROM orders
GROUP BY product_category
ORDER BY total_orders DESC;

-- ============================================
-- 18. Monthly Revenue by City
-- MySQL version
-- ============================================
SELECT city,
       DATE_FORMAT(order_date, '%Y-%m') AS month,
       SUM(amount) AS revenue
FROM orders
GROUP BY city, DATE_FORMAT(order_date, '%Y-%m')
ORDER BY city, month;

-- ============================================
-- 19. Highest Revenue Month
-- MySQL version
-- ============================================
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month,
       SUM(amount) AS total_sales
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY total_sales DESC
LIMIT 1;

-- ============================================
-- 20. Percentage Contribution by Category
-- ============================================
SELECT product_category,
       SUM(amount) AS total_sales,
       ROUND(
           100 * SUM(amount) / SUM(SUM(amount)) OVER (),
           2
       ) AS sales_percentage
FROM orders
GROUP BY product_category
ORDER BY total_sales DESC;