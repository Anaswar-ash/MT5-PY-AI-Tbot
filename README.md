# MT5-PY-AI-Tbot
A complete framework for creating an Al-enhanced trading bot in MQL5, using Python for model training and the ONNX format for deployment on the MetaTrader 5 platform.
Author: Ash.
MQL5-Python-Trader
This repository contains a complete, working example of an automated trading bot that uses a Python-trained neural network to make trading decisions directly inside MetaTrader 5. The model is optimized using Time Series Cross Validation to find the best possible parameters and ensure its robustness.
System Architecture 🏗️
The project is built on a modern, decoupled architecture that leverages the best tool for each task.
1. The Python "Lab" 🔬
All data analysis, feature engineering, and model training happens here. We use Python for its powerful data science libraries to create a predictive model. The development is done in a standard .py script, perfect for use in Visual Studio Code.
2. The MQL5 "Trader" ⚙️
This is a lightweight, high-performance Expert Advisor (EA) written in MQL5. Its only jobs are to feed the latest market data into the model and execute trades. It does no complex calculations itself.
3. The ONNX "Bridge" 🌉
The ONNX file format is the magic that connects our Python lab to our MQL5 trader. We save our trained model as an .onnx file, which MQL5 can load and use natively, creating a perfect, efficient link between the two environments.
Project Files
 * Export_EURUSD_History.mq5: MQL5 script to pull daily EUR/USD price history into a .csv file.
 * Model_Development.py: The Python script where all model training, validation, and hyperparameter tuning occurs.
 * benchmark_logistic_model.onnx: A simple baseline model used for performance comparison.
 * trading_neural_network_model.onnx: The final, optimized neural network model ready for deployment.
 * Benchmark_Model_EA.mq5: The MQL5 Expert Advisor for running the simple benchmark model.
 * Neural_Network_Trader_EA.mq5: The main Expert Advisor that runs our advanced neural network model.
The Workflow: From Data to Trade
The process is broken down into three logical steps.
Step 1: Data Export
We run the Export_EURUSD_History.mq5 script in MetaTrader 5. This gives us a raw_price_data.csv file to work with in Python.
Step 2: Model Development & Optimization
This is the core of the project, handled within the Model_Development.py script.
1. Feature Engineering:
 * We load the data into a raw_price_df DataFrame.
 * [cite_start]Our primary feature, feature_price_change, is the difference between one day's close and the previous day's.
 * Our target, y_target_direction, is 1 if the next day's price went up and 0 otherwise.
2. Hyperparameter Tuning with Time Series Cross Validation:
[cite_start]To find the best possible version of our model, we use a search process that respects the chronological order of the data.
 * Split Strategy: We first define a TimeSeriesSplit object. [cite_start]This object creates 5 sequential "folds" of data and ensures there is a gap between the training and validation sets equal to our forecast horizon.
 * [cite_start]Parameter Search Space: We create a dictionary of potential parameters for the neural network. [cite_start]This includes different activation functions, learning rates, solver algorithms, and hidden layer sizes.
 * [cite_start]Randomized Search: We use RandomizedSearchCV to conduct the search. [cite_start]This tool systematically tests 50 random combinations of the parameters across our time series splits. [cite_start]It evaluates each combination and identifies the set of parameters that performs the best on unseen data.
3. Final Model Training:
 * [cite_start]After the search identifies the optimal parameters (best_params_), we initialize a new neural_network_model with these settings.
 * [cite_start]We then train this final, optimized model on the entire training dataset.
 * The fully trained model is exported to trading_neural_network_model.onnx.
Step 3: Trade Execution
The Neural_Network_Trader_EA.mq5 takes over in MetaTrader 5:
 * On startup, it loads the .onnx file using its onnxModelHandle.
 * On each new daily bar, it calculates the latest feature_price_change.
 * It feeds this feature into the model and gets back the buyProbability.
 * [cite_start]If buyProbability is greater than the current close price, it executes a BUY order. [cite_start]Otherwise, it executes a SELL order. All trades are protected with stopLossPips and takeProfitPips.
How to Run This Project
 * Setup Your Environment:
   * Install MetaTrader 5 and open a free demo account.
   * Install Visual Studio Code and the Python extension.
   * Install the necessary Python packages:
     pip install pandas numpy tensorflow scikit-learn onnxruntime skl2onnx tf2onnx MetaTrader5

 * Execute the Pipeline:
   * Get Data: Place Export_EURUSD_History.mq5 in MQL5/Scripts and run it.
   * Train Model: Run the Model_Development.py script. It will automatically perform the cross-validation and save the final .onnx file.
   * Deploy EA: Copy Neural_Network_Trader_EA.mq5 to MQL5/Experts and the .onnx file to MQL5/Files.
 * Test Your Bot:
   * Use the MT5 Strategy Tester for historical backtesting.
   * Attach the EA to a EURUSD, D1 chart to run it on your demo account.
Disclaimer: This is an educational project. Trading financial markets involves significant risk. Past performance is not indicative of future results. Never deploy an untested automated strategy on a live account with real money.
