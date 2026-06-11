from pathlib import Path
import pandas as pd
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error
from sklearn.model_selection import train_test_split


def train_forecasting_model() -> None:
    """
    Train a Random Forest regression model to predict product demand.

    Input:
        data/sales.csv

    Output:
        data/demand_forecast.csv
    """

    base_dir = Path(__file__).resolve().parent.parent
    data_dir = base_dir / "data"

    sales_path = data_dir / "sales.csv"
    output_path = data_dir / "demand_forecast.csv"

    sales = pd.read_csv(sales_path)

    print("Sales data loaded successfully.")
    print(f"Rows and columns: {sales.shape}")

    sales["date"] = pd.to_datetime(sales["date"])
    sales["month"] = sales["date"].dt.month
    sales["day_of_week"] = sales["date"].dt.dayofweek

    sales["product_code"] = sales["product_id"].astype("category").cat.codes
    sales["store_code"] = sales["store_id"].astype("category").cat.codes

    product_code_mapping = sales[["product_id", "product_code"]].drop_duplicates()
    store_code_mapping = sales[["store_id", "store_code"]].drop_duplicates()

    features = [
        "product_code",
        "store_code",
        "month",
        "day_of_week",
        "unit_price",
        "discount_percent",
    ]

    target = "quantity_sold"

    X = sales[features]
    y = sales[target]

    X_train, X_test, y_train, y_test = train_test_split(
        X,
        y,
        test_size=0.2,
        random_state=42,
    )

    model = RandomForestRegressor(
        n_estimators=100,
        random_state=42,
    )

    model.fit(X_train, y_train)

    predictions = model.predict(X_test)
    mae = mean_absolute_error(y_test, predictions)

    print("Model trained successfully.")
    print(f"Mean Absolute Error: {mae:.2f}")

    future_data = sales[
        [
            "product_id",
            "store_id",
            "unit_price",
            "discount_percent",
        ]
    ].drop_duplicates()

    future_data["forecast_date"] = "2025-05-01"
    future_data["forecast_date"] = pd.to_datetime(future_data["forecast_date"])
    future_data["month"] = future_data["forecast_date"].dt.month
    future_data["day_of_week"] = future_data["forecast_date"].dt.dayofweek

    future_data = future_data.merge(product_code_mapping, on="product_id", how="left")
    future_data = future_data.merge(store_code_mapping, on="store_id", how="left")

    future_X = future_data[features]

    future_data["predicted_quantity_sold"] = model.predict(future_X)
    future_data["predicted_quantity_sold"] = (
        future_data["predicted_quantity_sold"].round().astype(int)
    )

    forecast_output = future_data[
        [
            "product_id",
            "store_id",
            "forecast_date",
            "predicted_quantity_sold",
        ]
    ]

    forecast_output.to_csv(output_path, index=False)

    print("Forecast file created successfully.")
    print(f"Output file: {output_path}")
    print(f"Forecast rows: {len(forecast_output)}")


if __name__ == "__main__":
    train_forecasting_model()