# How to Run

## Prerequisites

*   MetaTrader 5 terminal installed.
*   Python 3.x installed.
*   The following Python libraries installed: `pandas`, `scikit-learn`, `skl2onnx`, `onnxruntime`.

## Installation

1.  Clone the repository to your local machine.
2.  Install the required Python libraries using pip:

    ```bash
    pip install pandas scikit-learn skl2onnx onnxruntime
    ```

## Running the project

1.  **Export Price Data**:
    *   Open the MetaEditor in your MetaTrader 5 terminal.
    *   Open the `Export_EURUSD_History.mq5` file.
    *   Compile the script.
    *   Run the script on a EUR/USD chart. This will create a `raw_price_data.csv` file in the `MQL5/Files` directory of your MetaTrader 5 installation.
    *   Copy the `raw_price_data.csv` file to the root of the project directory.

2.  **Train the Models**:
    *   Run the `create_benchmark_model.py` script to create the benchmark model.

        ```bash
        python create_benchmark_model.py
        ```

    *   Run the `Model_Development.py` script to train the neural network model.

        ```bash
        python Model_Development.py
        ```

3.  **Run the Expert Advisors**:
    *   Copy the `Benchmark_Model_EA.mq5` and `Neural_Network_Trader_EA.mq5` files to the `MQL5/Experts` directory of your MetaTrader 5 installation.
    *   Copy the `benchmark_logistic_model.onnx` and `trading_neural_network_model.onnx` files to the `MQL5/Files` directory of your MetaTrader 5 installation.
    *   Open the MetaEditor and compile the EAs.
    *   Attach the EAs to a EUR/USD chart in your MetaTrader 5 terminal.
