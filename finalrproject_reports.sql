SELECT 
  o.order_made_id,
  GROUP_CONCAT(DISTINCT p.product_name) AS Product_names,
  GROUP_CONCAT(DISTINCT p.product_description) AS Product_descriptions,
  c.client_first_name,
  c.client_last_name,
  c.client_email,
  c.client_phone_number,
  c.client_address,
  o.order_made_date,
  o.order_made_status,
  o.order_made_total_amount,
  (SELECT pm.payment_method_name
   FROM Client_payment_method cpm
   JOIN Payment_method pm ON cpm.payment_method_payment_method_id = pm.payment_method_id
   WHERE cpm.client_client_id = o.client_client_id
   LIMIT 1) AS payment_method_name
FROM Order_made o
JOIN Client c ON o.client_client_id = c.client_id
JOIN Order_detail od ON o.order_made_id = od.order_made_order_made_id
JOIN Product p ON od.product_product_sku = p.product_sku
GROUP BY o.order_made_id, c.client_first_name, c.client_last_name, c.client_email, c.client_phone_number, c.client_address, o.order_made_date, o.order_made_status, o.order_made_total_amount;



SELECT *
FROM Client
WHERE client_id = 'CLI001';


SELECT *
FROM Order_made
WHERE client_client_id = 'CLI001';


SELECT 
  strftime('%Y-%m', order_made_date) AS Month,
  SUM(order_made_total_amount) AS Total_sales
FROM Order_made
WHERE order_made_status = 'Completed'
GROUP BY month;



SELECT product_product_sku, SUM(order_detail_quantity) AS total_quantity_sold
FROM Order_detail
JOIN Order_made ON Order_detail.order_made_order_made_id = Order_made.order_made_id
WHERE Order_made.order_made_status = 'Completed'
GROUP BY product_product_sku
ORDER BY total_quantity_sold DESC
LIMIT 10;

SELECT product_product_sku, SUM(order_detail_quantity * order_detail_unit_cost) AS total_income
FROM Order_detail
JOIN Order_made ON Order_detail.order_made_order_made_id = Order_made.order_made_id
WHERE Order_made.order_made_status = 'Completed'
GROUP BY product_product_sku
ORDER BY total_income DESC
LIMIT 10;



UPDATE Order_made
SET order_made_status = 'Completed' 
WHERE order_made_id = 'ORD174' 


SELECT * FROM Order_made 
where order_made_id = 'ORD174';


DELETE * FROM Client
WHERE client_id = 'CLI001'; 