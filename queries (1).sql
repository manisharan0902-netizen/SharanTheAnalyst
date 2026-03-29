-- ============================================
-- RIDE SHARING SQL ANALYSIS PROJECT
-- ============================================

-- Table structure
CREATE TABLE rides (
    ride_id INT,
    user_id INT,
    driver_id INT,
    ride_date DATE,
    city VARCHAR(50),
    distance_km DECIMAL(5,2),
    fare_amount DECIMAL(10,2),
    payment_type VARCHAR(20)
);

-- ============================================
-- 1. Total Revenue
-- ============================================
SELECT SUM(fare_amount) AS total_revenue
FROM rides;

-- ============================================
-- 2. Total Rides by City
-- ============================================
SELECT city,
       COUNT(ride_id) AS total_rides
FROM rides
GROUP BY city
ORDER BY total_rides DESC;

-- ============================================
-- 3. Revenue by City
-- ============================================
SELECT city,
       SUM(fare_amount) AS total_revenue
FROM rides
GROUP BY city
ORDER BY total_revenue DESC;

-- ============================================
-- 4. Average Fare per Ride
-- ============================================
SELECT AVG(fare_amount) AS avg_fare
FROM rides;

-- ============================================
-- 5. Top 5 Users by Spending
-- ============================================
SELECT user_id,
       SUM(fare_amount) AS total_spent
FROM rides
GROUP BY user_id
ORDER BY total_spent DESC
LIMIT 5;

-- ============================================
-- 6. Top 3 Drivers by Earnings
-- ============================================
SELECT driver_id,
       SUM(fare_amount) AS total_earnings
FROM rides
GROUP BY driver_id
ORDER BY total_earnings DESC
LIMIT 3;

-- ============================================
-- 7. Daily Revenue
-- ============================================
SELECT ride_date,
       SUM(fare_amount) AS daily_revenue
FROM rides
GROUP BY ride_date
ORDER BY ride_date;

-- ============================================
-- 8. Monthly Revenue Trend
-- MySQL version
-- ============================================
SELECT DATE_FORMAT(ride_date, '%Y-%m') AS month,
       SUM(fare_amount) AS monthly_revenue
FROM rides
GROUP BY DATE_FORMAT(ride_date, '%Y-%m')
ORDER BY month;

-- ============================================
-- 9. Payment Method Distribution
-- ============================================
SELECT payment_type,
       COUNT(ride_id) AS total_rides
FROM rides
GROUP BY payment_type
ORDER BY total_rides DESC;

-- ============================================
-- 10. Longest Ride by City
-- ============================================
SELECT city,
       MAX(distance_km) AS longest_ride
FROM rides
GROUP BY city
ORDER BY longest_ride DESC;

-- ============================================
-- 11. Running Revenue
-- ============================================
SELECT ride_date,
       fare_amount,
       SUM(fare_amount) OVER (ORDER BY ride_date, ride_id) AS running_revenue
FROM rides
ORDER BY ride_date, ride_id;

-- ============================================
-- 12. Rank Drivers by Earnings
-- ============================================
SELECT driver_id,
       SUM(fare_amount) AS total_earnings,
       RANK() OVER (ORDER BY SUM(fare_amount) DESC) AS earnings_rank
FROM rides
GROUP BY driver_id;

-- ============================================
-- 13. Most Active Users
-- ============================================
SELECT user_id,
       COUNT(ride_id) AS total_rides
FROM rides
GROUP BY user_id
ORDER BY total_rides DESC;

-- ============================================
-- 14. Customer Segmentation
-- ============================================
SELECT user_id,
       SUM(fare_amount) AS total_spent,
       CASE
           WHEN SUM(fare_amount) > 100 THEN 'High Value'
           WHEN SUM(fare_amount) BETWEEN 50 AND 100 THEN 'Medium Value'
           ELSE 'Low Value'
       END AS customer_segment
FROM rides
GROUP BY user_id
ORDER BY total_spent DESC;

-- ============================================
-- 15. Most Recent Ride per User
-- ============================================
SELECT ride_id,
       user_id,
       driver_id,
       ride_date,
       city,
       distance_km,
       fare_amount,
       payment_type
FROM (
    SELECT r.*,
           ROW_NUMBER() OVER (
               PARTITION BY user_id
               ORDER BY ride_date DESC, ride_id DESC
           ) AS rn
    FROM rides r
) t
WHERE rn = 1;

-- ============================================
-- 16. Peak Revenue Day
-- ============================================
SELECT ride_date,
       SUM(fare_amount) AS total_revenue
FROM rides
GROUP BY ride_date
ORDER BY total_revenue DESC
LIMIT 1;

-- ============================================
-- 17. Total Distance Travelled by City
-- ============================================
SELECT city,
       SUM(distance_km) AS total_distance
FROM rides
GROUP BY city
ORDER BY total_distance DESC;

-- ============================================
-- 18. Monthly Revenue by City
-- MySQL version
-- ============================================
SELECT city,
       DATE_FORMAT(ride_date, '%Y-%m') AS month,
       SUM(fare_amount) AS revenue
FROM rides
GROUP BY city, DATE_FORMAT(ride_date, '%Y-%m')
ORDER BY city, month;

-- ============================================
-- 19. Highest Revenue Month
-- MySQL version
-- ============================================
SELECT DATE_FORMAT(ride_date, '%Y-%m') AS month,
       SUM(fare_amount) AS total_revenue
FROM rides
GROUP BY DATE_FORMAT(ride_date, '%Y-%m')
ORDER BY total_revenue DESC
LIMIT 1;

-- ============================================
-- 20. Percentage Contribution by City
-- ============================================
SELECT city,
       SUM(fare_amount) AS total_revenue,
       ROUND(
           100 * SUM(fare_amount) / SUM(SUM(fare_amount)) OVER (),
           2
       ) AS revenue_percentage
FROM rides
GROUP BY city
ORDER BY total_revenue DESC;