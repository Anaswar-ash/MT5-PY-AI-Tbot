import pandas as pd
from sklearn.model_selection import TimeSeriesSplit, RandomizedSearchCV
from sklearn.neural_network import MLPClassifier
import skl2onnx
from skl2onnx.common.data_types import FloatTensorType

def main():
    """
    This script performs the following steps:
    1. Loads the historical price data from a CSV file.
    2. Performs feature engineering to create a 'feature_price_change' feature.
    3. Performs target engineering to create a 'y_target_direction' target variable.
    4. Performs hyperparameter tuning using RandomizedSearchCV and TimeSeriesSplit to find the best parameters for an MLPClassifier.
    5. Trains a final MLPClassifier model with the best parameters.
    6. Exports the trained model to an ONNX file named 'trading_neural_network_model.onnx'.
    """
    # Load the data
    raw_price_df = pd.read_csv("raw_price_data.csv")

    # Feature Engineering
    raw_price_df["feature_price_change"] = raw_price_df["Close"].diff()

    # Target Engineering
    raw_price_df["y_target_direction"] = (raw_price_df["Close"].shift(-1) > raw_price_df["Close"]).astype(int)

    # Drop rows with NaN values
    raw_price_df.dropna(inplace=True)

    # --- Hyperparameter Tuning ---
    # Define the parameter search space
    param_distributions = {
        'hidden_layer_sizes': [(50,), (100,), (50, 50)],
        'activation': ['tanh', 'relu'],
        'solver': ['adam', 'sgd'],
        'learning_rate': ['constant', 'adaptive'],
    }

    # Create the neural network model
    neural_network_model = MLPClassifier(max_iter=1000)

    # Create the time series split object
    ts_split = TimeSeriesSplit(n_splits=2, gap=1)

    # Create the randomized search object
    random_search = RandomizedSearchCV(
        estimator=neural_network_model,
        param_distributions=param_distributions,
        n_iter=10,  # Reduced for faster execution
        cv=ts_split,
        scoring='accuracy',
        random_state=42,
        n_jobs=-1
    )

    # Separate features and target
    X = raw_price_df[['feature_price_change']]
    y = raw_price_df['y_target_direction']

    # Fit the randomized search to the data
    random_search.fit(X, y)

    print(f"Best parameters found: {random_search.best_params_}")

    # --- Final Model Training ---
    # Initialize a new neural network model with the best parameters
    final_model = MLPClassifier(**random_search.best_params_, max_iter=1000)

    # Train the model on the entire dataset
    final_model.fit(X, y)

    # --- Export to ONNX ---
    # Define the initial types for the ONNX conversion
    initial_type = [('float_input', FloatTensorType([None, 1]))]

    # Convert the model to ONNX format
    onnx_model = skl2onnx.convert_sklearn(final_model, initial_types=initial_type)

    # Save the ONNX model
    with open("trading_neural_network_model.onnx", "wb") as f:
        f.write(onnx_model.SerializeToString())

    print("Model successfully exported to trading_neural_network_model.onnx")

if __name__ == "__main__":
    main()