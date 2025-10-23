# AI-Enhanced MQL5 Trading Bot

An end-to-end automated trading bot linking a Python-trained neural network to a high-performance MQL5 (MetaTrader 5) Expert Advisor via the ONNX model format.

## Features

*   **Automated Trading:** The bot automatically executes trades based on the predictions of a neural network model.
*   **Machine Learning Model:** The trading decisions are powered by a neural network model trained on historical price data.
*   **Robust Model Selection:** The model is trained using a robust model selection process with `RandomizedSearchCV` and `TimeSeriesSplit` to optimize hyperparameters and ensure model validity on chronological financial data.
*   **ONNX Integration:** The trained model is exported to the ONNX format, allowing it to be used by the MQL5 Expert Advisor.
*   **Benchmark Model:** The project includes a benchmark logistic regression model for comparison.

## Technology Stack

*   **Python**: For data analysis, model development, and training.
*   **MQL5**: For creating the Expert Advisors (EAs) that run in the MetaTrader 5 terminal.
*   **ONNX**: For exporting the trained models to a format that can be used by the MQL5 EAs.
*   **Scikit-learn**: For creating and training the machine learning models.
*   **TensorFlow**: Used as a backend for the neural network model.
*   **Pandas**: For data manipulation and analysis.

## How to Use

Please refer to the [HOWTORUN.md](howtorun.md) file for detailed instructions on how to run the project.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.