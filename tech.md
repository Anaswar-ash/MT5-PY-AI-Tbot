# Technical Documentation

## Project Overview

This project is a trading bot for MetaTrader 5 that uses a machine learning model to make trading decisions. The project consists of MQL5 scripts for interacting with the MetaTrader 5 terminal and Python scripts for developing and training the machine learning model.

## Technology Stack

*   **MQL5**: Used to create the Expert Advisors (EAs) that run in the MetaTrader 5 terminal.
*   **Python**: Used for data analysis, machine learning model development, and training.
*   **Pandas**: Used for data manipulation and analysis.
*   **scikit-learn**: Used for creating and training the machine learning models.
*   **ONNX**: Used to export the trained models to a format that can be used by the MQL5 EAs.
*   **skl2onnx**: Used to convert scikit-learn models to ONNX format.

## File Descriptions

*   `Export_EURUSD_History.mq5`: An MQL5 script that exports historical price data for the EUR/USD pair to a CSV file.
*   `Model_Development.py`: A Python script that loads the exported price data, performs feature engineering, and trains a neural network model. The trained model is then exported to an ONNX file.
*   `create_benchmark_model.py`: A Python script that creates and trains a simple logistic regression model to be used as a benchmark. The model is exported to an ONNX file.
*   `Benchmark_Model_EA.mq5`: An MQL5 Expert Advisor that uses the benchmark logistic regression model to make trading decisions.
*   `Neural_Network_Trader_EA.mq5`: An MQL5 Expert Advisor that uses the trained neural network model to make trading decisions.
*   `raw_price_data.csv`: A CSV file containing historical price data for the EUR/USD pair.
*   `benchmark_logistic_model.onnx`: The exported benchmark logistic regression model in ONNX format.
*   `trading_neural_network_model.onnx`: The exported trained neural network model in ONNX format.
*   `MT5-PY-AI-Tbot`: A file containing the concatenated code of all the project files.
*   `separate_codes/`: A directory containing the individual project files.

## Model

The project uses two machine learning models:

1.  **Benchmark Model**: A simple logistic regression model that predicts the direction of the next day's price change based on the previous day's price change.
2.  **Neural Network Model**: A multi-layer perceptron (MLP) classifier that predicts the direction of the next day's price change based on the previous day's price change. The model is trained using hyperparameter tuning with `RandomizedSearchCV` and `TimeSeriesSplit` to find the best parameters. The hyperparameter search space includes different hidden layer sizes, activation functions, solvers, and learning rates. The exact architecture of the model will vary depending on the results of the hyperparameter tuning.