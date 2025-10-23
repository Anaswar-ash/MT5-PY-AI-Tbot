# Project Flow

This document outlines the workflow of the AI-Enhanced MQL5 Trading Bot project.

1.  **Data Export**:
    *   The process starts with the `Export_EURUSD_History.mq5` script, which is an MQL5 script that runs on the MetaTrader 5 terminal.
    *   This script exports historical price data for the EUR/USD pair to a CSV file named `raw_price_data.csv`.

2.  **Model Training**:
    *   The `raw_price_data.csv` file is then used by the Python scripts to train the machine learning models.
    *   The `create_benchmark_model.py` script trains a logistic regression model and exports it to `benchmark_logistic_model.onnx`.
    *   The `Model_Development.py` script trains a neural network model using hyperparameter tuning and exports it to `trading_neural_network_model.onnx`.

3.  **Trading**:
    *   The exported ONNX models are used by the MQL5 Expert Advisors (EAs) to make trading decisions.
    *   The `Benchmark_Model_EA.mq5` EA uses the `benchmark_logistic_model.onnx` model.
    *   The `Neural_Network_Trader_EA.mq5` EA uses the `trading_neural_network_model.onnx` model.
    *   The EAs run on the MetaTrader 5 terminal, and on each new bar, they get the latest price data, feed it to the ONNX model, and execute a trade based on the model's prediction.
