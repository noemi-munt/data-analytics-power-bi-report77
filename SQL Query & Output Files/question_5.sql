/*

    Q5. Which product category generated the most profit for the "Wiltshire, UK" region in 2021?

*/

SELECT
    p.category,
    SUM ((o.product_quantity * p.sale_price) - p.cost_price) AS total_profit
FROM orders o
JOIN dim_products p ON o.product_code = p.product_code
JOIN dim_stores s ON o.store_code = s.store_code
WHERE SPLIT_PART(order_date, '/', 3) = '2021' AND s.geography = 'Wiltshire, United Kingdom'
GROUP BY p.category
ORDER BY total_profit DESC
LIMIT 1;
