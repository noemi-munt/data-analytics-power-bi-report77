
/*

    4. Create a view where the rows are the store types and 
    the columns are the total sales, percentage of total sales and the count of orders 

*/

--DROP VIEW IF EXISTS "Store Type Revenue Summary";

CREATE VIEW "Store Type Revenue Summary" AS
SELECT s.store_type,
       SUM(o.product_quantity * p.sale_price) AS total_revenue,
       (SUM(o.product_quantity * p.sale_price) / 
        (SELECT SUM(o2.product_quantity * p2.sale_price) 
         FROM orders o2
         JOIN dim_products p2 ON o2.product_code = p2.product_code)) * 100 AS revenue_percentage,
       COUNT(o.order_date) AS order_count
FROM orders o
JOIN dim_stores s ON o.store_code = s.store_code
JOIN dim_products p ON o.product_code = p.product_code
GROUP BY s.store_type;

SELECT * FROM  "Store Type Revenue Summary"
