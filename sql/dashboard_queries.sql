-- =========================================================
-- Dashboard Queries for Power BI
-- =========================================================

-- =========================================================
-- Dashboard Query 1:
-- Store KPI Summary
-- Shows revenue, quantity sold, transactions, inventory records,
-- and current stockout risk by store.
-- =========================================================

SELECT
    store_id,
    region,
    store_type,
    total_revenue,
    total_quantity_sold,
    total_sales_transactions,
    total_inventory_records,
    stockout_risk_count
FROM store_inventory_kpi_view
ORDER BY stockout_risk_count DESC;

-- =========================================================
-- Dashboard Query 2:
-- Category Revenue Summary
-- Shows which categories are generating the most revenue.
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
-- Dashboard Query 3:
-- Product Sales Ranking
-- Shows top-selling products by revenue and quantity sold.
-- =========================================================

SELECT
    product_id,
    product_name,
    category,
    SUM(quantity_sold) AS total_quantity_sold,
    SUM(revenue) AS total_revenue
FROM sales_analysis_view
GROUP BY product_id, product_name, category
ORDER BY total_revenue DESC;

-- =========================================================
-- Dashboard Query 4:
-- Current Stockout Risk Details
-- Shows product-store combinations currently below reorder level.
-- =========================================================

SELECT
    product_id,
    product_name,
    category,
    store_id,
    region,
    store_type,
    stock_on_hand,
    reorder_level,
    inventory_status
FROM inventory_risk_view
WHERE inventory_status = 'At Risk'
ORDER BY store_id, product_name;

-- =========================================================
-- Dashboard Query 5:
-- Forecasted Stockout Risk
-- Shows products/stores where predicted demand is greater than current stock.
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