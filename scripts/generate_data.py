import pandas as pd
import numpy as np
from datetime import datetime, timedelta
from pathlib import Path

# Find the main project folder
BASE_DIR = Path(__file__).resolve().parent.parent
DATA_DIR = BASE_DIR / "data"

# Read product and store master files
products = pd.read_csv(DATA_DIR / "products.csv")
stores = pd.read_csv(DATA_DIR / "stores.csv")

# This makes sure we generate the same random data every time
np.random.seed(42)

# Create 100 sales records
start_date = datetime(2025, 1, 1)
sales_rows = []

for i in range(1, 101):
    product = products.sample(1).iloc[0]
    store = stores.sample(1).iloc[0]

    random_days = int(np.random.randint(0, 120))
    sale_date = start_date + timedelta(days=random_days)

    quantity_sold = int(np.random.randint(5, 80))
    discount_percent = float(np.random.choice([0, 5, 10, 15, 20]))

    revenue = round(
        quantity_sold * product["unit_price"] * (1 - discount_percent / 100),
        2
    )

    sales_rows.append({
        "sales_id": f"SA{i:04d}",
        "date": sale_date.strftime("%Y-%m-%d"),
        "product_id": product["product_id"],
        "store_id": store["store_id"],
        "quantity_sold": quantity_sold,
        "unit_price": product["unit_price"],
        "discount_percent": discount_percent,
        "revenue": revenue
    })

sales = pd.DataFrame(sales_rows)

# Create 100 inventory records connected to the sales records
inventory_rows = []

for i, row in sales.iterrows():
    stock_on_hand = int(np.random.randint(20, 250))
    reorder_level = int(np.random.randint(25, 70))

    stockout_flag = 1 if stock_on_hand < reorder_level else 0

    inventory_rows.append({
        "inventory_id": f"IN{i + 1:04d}",
        "date": row["date"],
        "product_id": row["product_id"],
        "store_id": row["store_id"],
        "stock_on_hand": stock_on_hand,
        "reorder_level": reorder_level,
        "stockout_flag": stockout_flag
    })

inventory = pd.DataFrame(inventory_rows)

# Save output files
sales.to_csv(DATA_DIR / "sales.csv", index=False)
inventory.to_csv(DATA_DIR / "inventory.csv", index=False)

print("sales.csv and inventory.csv created successfully.")
print("Sales rows:", len(sales))
print("Inventory rows:", len(inventory))