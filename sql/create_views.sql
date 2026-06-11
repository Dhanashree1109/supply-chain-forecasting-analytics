-- =========================================================
-- Create Views for Supply Chain Forecasting Project
-- =========================================================

-- =========================================================
-- View 1: Sales Analysis View
-- Combines sales, products, and stores for sales reporting.
-- =========================================================

DROP VIEW IF EXISTS sales_analysis_view;

CREATE VIEW sales_analysis_view AS
SELECT
    s.sales_id,
    s.date,
    s.product_id,
    p.product_name,
    p.category,
    s.store_id,
    st.region,
    st.store_type,
    s.quantity_sold,
    s.unit_price,
    s.discount_percent,
    s.revenue
FROM sales s
INNER JOIN products p
    ON s.product_id = p.product_id
INNER JOIN stores st
    ON s.store_id = st.store_id;

-- =========================================================
-- View 2: Inventory Risk View
-- Combines inventory, products, and stores for current stockout analysis.
-- =========================================================

DROP VIEW IF EXISTS inventory_risk_view;

CREATE VIEW inventory_risk_view AS
SELECT
    i.inventory_id,
    i.date,
    i.product_id,
    p.product_name,
    p.category,
    i.store_id,
    st.region,
    st.store_type,
    i.stock_on_hand,
    i.reorder_level,
    i.stockout_flag,
    CASE
        WHEN i.stock_on_hand < i.reorder_level THEN 'At Risk'
        ELSE 'Healthy'
    END AS inventory_status
FROM inventory i
INNER JOIN products p
    ON i.product_id = p.product_id
INNER JOIN stores st
    ON i.store_id = st.store_id;

-- =========================================================
-- View 3: Store Inventory KPI View
-- Aggregates sales and inventory separately before joining.
-- This avoids row multiplication and inflated KPI values.
-- =========================================================

DROP VIEW IF EXISTS store_inventory_kpi_view;

CREATE VIEW store_inventory_kpi_view AS
WITH sales_summary AS (
    SELECT
        store_id,
        SUM(revenue) AS total_revenue,
        SUM(quantity_sold) AS total_quantity_sold,
        COUNT(sales_id) AS total_sales_transactions
    FROM sales
    GROUP BY store_id
),

inventory_summary AS (
    SELECT
        store_id,
        COUNT(*) AS total_inventory_records,
        COUNT(
            CASE
                WHEN stock_on_hand < reorder_level THEN 1
            END
        ) AS stockout_risk_count
    FROM inventory
    GROUP BY store_id
)

SELECT
    st.store_id,
    st.region,
    st.store_type,
    COALESCE(ss.total_revenue, 0) AS total_revenue,
    COALESCE(ss.total_quantity_sold, 0) AS total_quantity_sold,
    COALESCE(ss.total_sales_transactions, 0) AS total_sales_transactions,
    COALESCE(inv.total_inventory_records, 0) AS total_inventory_records,
    COALESCE(inv.stockout_risk_count, 0) AS stockout_risk_count
FROM stores st
LEFT JOIN sales_summary ss
    ON st.store_id = ss.store_id
LEFT JOIN inventory_summary inv
    ON st.store_id = inv.store_id;

-- =========================================================
-- View 4: Forecast Stockout Risk View
-- Compares latest inventory stock with ML-predicted demand.
-- Helps identify product-store combinations at future stockout risk.
-- =========================================================

DROP VIEW IF EXISTS forecast_stockout_risk_view;

CREATE VIEW forecast_stockout_risk_view AS
WITH latest_inventory AS (
    SELECT
        inventory_id,
        date,
        product_id,
        store_id,
        stock_on_hand,
        reorder_level,
        ROW_NUMBER() OVER (
            PARTITION BY product_id, store_id
            ORDER BY date DESC
        ) AS row_num
    FROM inventory
),

forecast_summary AS (
    SELECT
        product_id,
        store_id,
        forecast_date,
        ROUND(AVG(predicted_quantity_sold))::INTEGER AS predicted_quantity_sold
    FROM demand_forecast
    GROUP BY product_id, store_id, forecast_date
)

SELECT
    fs.product_id,
    p.product_name,
    p.category,
    fs.store_id,
    st.region,
    st.store_type,
    li.date AS latest_inventory_date,
    li.stock_on_hand,
    li.reorder_level,
    fs.forecast_date,
    fs.predicted_quantity_sold,
    li.stock_on_hand - fs.predicted_quantity_sold AS projected_stock_gap,
    CASE
        WHEN li.stock_on_hand < fs.predicted_quantity_sold THEN 'High Forecasted Stockout Risk'
        WHEN li.stock_on_hand < li.reorder_level THEN 'Current Stockout Risk'
        ELSE 'Healthy'
    END AS forecast_risk_status
FROM forecast_summary fs
INNER JOIN latest_inventory li
    ON fs.product_id = li.product_id
    AND fs.store_id = li.store_id
    AND li.row_num = 1
INNER JOIN products p
    ON fs.product_id = p.product_id
INNER JOIN stores st
    ON fs.store_id = st.store_id;