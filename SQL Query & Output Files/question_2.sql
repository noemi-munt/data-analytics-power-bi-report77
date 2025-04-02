/*

   Q.2 Which month in 2022 has had the highest revenue?

*/

-- Approach using string manipulation

SELECT 
    SPLIT_PART(order_date, '/', 2) AS revenue_month,  -- Extracts the month part from 'DD/MM/YYYY'
    SUM(o.product_quantity * p.sale_price) AS total_revenue
FROM orders o
JOIN dim_products p ON o.product_code = p.product_code
WHERE SPLIT_PART(order_date, '/', 3) = '2022'  -- Filters by year directly from string
GROUP BY revenue_month
ORDER BY total_revenue DESC
LIMIT 1;
