import pandas as pd
from sklearn.linear_model import LogisticRegression
import skl2onnx
from skl2onnx.common.data_types import FloatTensorType

# Load the data
raw_price_df = pd.read_csv("raw_price_data.csv")

# Feature Engineering
raw_price_df["feature_price_change"] = raw_price_df["Close"].diff()

# Target Engineering
raw_price_df["y_target_direction"] = (raw_price_df["Close"].shift(-1) > raw_price_df["Close"]).astype(int)

# Drop rows with NaN values
raw_price_df.dropna(inplace=True)

# Separate features and target
X = raw_price_df[['feature_price_change']]
y = raw_price_df['y_target_direction']

# Create and train the logistic regression model
log_reg_model = LogisticRegression()
log_reg_model.fit(X, y)

# Convert the model to ONNX format
initial_type = [('float_input', FloatTensorType([None, 1]))]
onnx_model = skl2onnx.convert_sklearn(log_reg_model, initial_types=initial_type)

# Save the ONNX model
with open("benchmark_logistic_model.onnx", "wb") as f:
    f.write(onnx_model.SerializeToString())

print("Model successfully exported to benchmark_logistic_model.onnx")