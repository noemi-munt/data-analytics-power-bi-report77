/*

    3. Which German store type had the highest revenue for 2022? 

*/

SELECT 
    s.store_type,
    SUM(o.product_quantity * p.sale_price) AS total_revenue
FROM orders o
JOIN dim_stores s ON o.store_code = s.store_code
JOIN dim_products p ON o.product_code = p.product_code
WHERE 
    EXTRACT(YEAR FROM TO_TIMESTAMP(o.order_date, 'DD/MM/YYYY')) = 2022
    AND s.country_code = 'DE'
GROUP BY s.store_type
ORDER BY total_revenue DESC
LIMIT 1;
