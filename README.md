# Supply Chain Forecasting Analytics Project

## Project Overview

This project is an end-to-end supply chain forecasting analytics project built using Python, PostgreSQL, SQL views, Scikit-learn, and Power BI.

The goal of the project is to analyze sales and inventory data, forecast future product demand, and identify product-store combinations that may face stockout risk.

## Tech Stack

* Python
* Pandas
* NumPy
* Scikit-learn
* PostgreSQL
* SQL
* Power BI
* Random Forest Regression

## Business Problem

Supply chain teams need to understand product demand, inventory availability, and potential stockout risk before shortages happen.

This project helps answer questions such as:

* Which product categories generate the most revenue?
* Which regions perform best?
* Which products are top sellers?
* Which products are currently at inventory risk?
* Which products may run out of stock based on forecasted demand?

## Project Workflow

1. Generated sample supply chain sales and inventory datasets using Python.
2. Validated data quality by checking row counts, missing values, and duplicate records.
3. Loaded CSV files into PostgreSQL tables.
4. Created SQL views for sales analysis, inventory risk, store KPIs, and forecasted stockout risk.
5. Trained a Random Forest regression model to predict future product demand.
6. Compared predicted demand against current stock levels.
7. Built a Power BI dashboard to visualize revenue performance and forecasted stockout risk.

## Dataset

The project includes sample data for:

* Products
* Stores
* Sales
* Inventory
* Demand forecast

## Machine Learning Model

The forecasting model predicts `quantity_sold` using features such as:

* Product
* Store
* Month
* Day of week
* Unit price
* Discount percentage

Model used:

* RandomForestRegressor

Evaluation metric:

* Mean Absolute Error: 16.73

## Power BI Dashboard

The Power BI dashboard includes two pages:

### 1. Executive Summary

This page shows:

* Total Revenue
* Total Quantity Sold
* Total Sales Transactions
* Total Inventory Records
* Current Stockout Risk Count
* Revenue by Category
* Revenue by Region
* Top Products by Revenue

### 2. Forecasted Stockout Risk

This page shows:

* Forecasted stockout risk details
* Current stock vs predicted demand
* Projected stock gap by product

## Key Business Insight

The forecasted stockout risk view identifies product-store combinations where predicted demand is greater than current stock levels. This helps supply chain teams prioritize replenishment before stockouts happen.

## Project Structure

```text
supply_chain_forecasting_project/
│
├── data/
│   ├── products.csv
│   ├── stores.csv
│   ├── sales.csv
│   ├── inventory.csv
│   └── demand_forecast.csv
│
├── scripts/
│   ├── generate_data.py
│   └── check_data.py
│
├── models/
│   └── train_forecast_model.py
│
├── sql/
│   ├── create_tables.sql
│   ├── create_views.sql
│   ├── business_questions.sql
│   └── dashboard_queries.sql
│
├── dashboard/
│   └── supply_chain_forecasting_dashboard.pbix
│
├── README.md
├── requirements.txt
└── .gitignore
```

## How to Run the Project

### 1. Install required Python packages

```bash
pip install -r requirements.txt
```

### 2. Generate sample sales and inventory data

```bash
python scripts/generate_data.py
```

### 3. Validate the generated data

```bash
python scripts/check_data.py
```

### 4. Create PostgreSQL tables

Run this SQL file in pgAdmin:

```text
sql/create_tables.sql
```

### 5. Import CSV files into PostgreSQL

Import the following files into their matching PostgreSQL tables:

```text
data/products.csv
data/stores.csv
data/sales.csv
data/inventory.csv
```

### 6. Train the forecasting model

```bash
python models/train_forecast_model.py
```

This creates:

```text
data/demand_forecast.csv
```

### 7. Import demand forecast into PostgreSQL

Import:

```text
data/demand_forecast.csv
```

into the PostgreSQL table:

```text
demand_forecast
```

### 8. Create SQL views

Run this SQL file in pgAdmin:

```text
sql/create_views.sql
```

### 9. Open the Power BI dashboard

Open:

```text
dashboard/supply_chain_forecasting_dashboard.pbix
```

## Business Value

This project demonstrates how sales, inventory, SQL analytics, machine learning, and dashboarding can be combined to support data-driven supply chain planning and reduce potential stockout risk.
