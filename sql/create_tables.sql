-- =========================================================
-- Create Tables for Supply Chain Forecasting Project
-- =========================================================

-- Drop views first because views depend on tables
DROP VIEW IF EXISTS forecast_stockout_risk_view;
DROP VIEW IF EXISTS store_inventory_kpi_view;
DROP VIEW IF EXISTS inventory_risk_view;
DROP VIEW IF EXISTS sales_analysis_view;

-- Drop tables in dependency order
DROP TABLE IF EXISTS demand_forecast;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS stores;

-- =========================================================
-- Master Table: Products
-- =========================================================

CREATE TABLE products (
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price NUMERIC(10, 2)
);

-- =========================================================
-- Master Table: Stores
-- =========================================================

CREATE TABLE stores (
    store_id VARCHAR(10) PRIMARY KEY,
    region VARCHAR(50),
    store_type VARCHAR(50)
);

-- =========================================================
-- Transaction Table: Sales
-- =========================================================

CREATE TABLE sales (
    sales_id VARCHAR(10) PRIMARY KEY,
    date DATE,
    product_id VARCHAR(10),
    store_id VARCHAR(10),
    quantity_sold INTEGER,
    unit_price NUMERIC(10, 2),
    discount_percent NUMERIC(5, 2),
    revenue NUMERIC(10, 2),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

-- =========================================================
-- Transaction Table: Inventory
-- =========================================================

CREATE TABLE inventory (
    inventory_id VARCHAR(10) PRIMARY KEY,
    date DATE,
    product_id VARCHAR(10),
    store_id VARCHAR(10),
    stock_on_hand INTEGER,
    reorder_level INTEGER,
    stockout_flag INTEGER,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

-- =========================================================
-- Forecast Table: Demand Forecast
-- This table stores ML model output.
-- =========================================================

CREATE TABLE demand_forecast (
    product_id VARCHAR(10),
    store_id VARCHAR(10),
    forecast_date DATE,
    predicted_quantity_sold INTEGER,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id)
);