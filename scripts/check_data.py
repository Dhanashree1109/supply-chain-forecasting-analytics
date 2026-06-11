from pathlib import Path
import pandas as pd


def check_dataframe_quality(df: pd.DataFrame, name: str) -> None:
    """
    Print basic data quality checks for a dataframe.
    """

    print(f"\n{name}")
    print("-" * 40)
    print(f"Rows and columns: {df.shape}")
    print("\nMissing values:")
    print(df.isnull().sum())
    print(f"\nDuplicate rows: {df.duplicated().sum()}")


def run_data_quality_checks() -> None:
    """
    Run basic validation checks on all project CSV files.
    """

    base_dir = Path(__file__).resolve().parent.parent
    data_dir = base_dir / "data"

    files = {
        "Products": data_dir / "products.csv",
        "Stores": data_dir / "stores.csv",
        "Sales": data_dir / "sales.csv",
        "Inventory": data_dir / "inventory.csv",
    }

    for name, file_path in files.items():
        df = pd.read_csv(file_path)
        check_dataframe_quality(df, name)

    print("\nData quality checks completed successfully.")


if __name__ == "__main__":
    run_data_quality_checks()