-- =========================================================
-- Business Questions for Supply Chain Forecasting Project
-- =========================================================

-- =========================================================
-- Question 1:
-- Which products sold the most?
-- =========================================================

SELECT
    product_id,
    product_name,
    SUM(quantity_sold) AS total_quantity_sold
FROM sales_analysis_view
GROUP BY product_id, product_name
ORDER BY total_quantity_sold DESC;

-- =========================================================
-- Question 2:
-- Which regions generated the most revenue?
-- =========================================================

SELECT
    region,
    SUM(revenue) AS total_revenue
FROM sales_analysis_view
GROUP BY region
ORDER BY total_revenue DESC;

-- =========================================================
-- Question 3:
-- Which products are currently at stockout risk?
-- =========================================================

SELECT
    product_id,
    product_name,
    category,
    store_id,
    region,
    stock_on_hand,
    reorder_level,
    inventory_status
FROM inventory_risk_view
WHERE inventory_status = 'At Risk'
ORDER BY product_id, store_id;

-- =========================================================
-- Question 4:
-- Which product categories are performing best?
-- =========================================================

SELECT
    category,
    SUM(revenue) AS total_revenue,
    SUM(quantity_sold) AS total_quantity_sold,
    COUNT(sales_id) AS total_transactions
FROM sales_analysis_view
GROUP BY category
ORDER BY total_revenue DESC;

-- =========================================================
-- Question 5:
-- Which stores have the highest current stockout risk?
-- =========================================================

SELECT
    store_id,
    region,
    store_type,
    COUNT(*) AS stockout_risk_count
FROM inventory_risk_view
WHERE inventory_status = 'At Risk'
GROUP BY store_id, region, store_type
ORDER BY stockout_risk_count DESC;

-- =========================================================
-- Question 6:
-- Which products may face future stockout risk based on forecasted demand?
-- =========================================================

SELECT
    product_id,
    product_name,
    category,
    store_id,
    region,
    stock_on_hand,
    predicted_quantity_sold,
    projected_stock_gap,
    forecast_risk_status
FROM forecast_stockout_risk_view
WHERE forecast_risk_status = 'High Forecasted Stockout Risk'
ORDER BY projected_stock_gap ASC;