//+------------------------------------------------------------------+
//|                                           Benchmark_Model_EA.mq5 |
//|                        Copyright 2025, https://github.com/Anaswar-ash |
//|                                  author: Ash                     |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, https://github.com/Anaswar-ash"
#property link      "https://github.com/Anaswar-ash"
#property version   "1.00"

#include <Trade/Trade.mqh> // Include the trade library

//--- ONNX model parameters
int onnx_handle; // Handle for the ONNX model
long onnx_input_shape[] = {1, 1}; // Shape of the input tensor
long onnx_output_shape[] = {1, 1}; // Shape of the output tensor

//--- Expert Advisor parameters
input double InpLots          = 0.1;   // Lot size for trades
input int    InpStopLoss      = 50;    // Stop loss in points
input int    InpTakeProfit    = 100;   // Take profit in points

//--- Create a CTrade object for executing trades
CTrade trade;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- Create the ONNX model from the file
   onnx_handle = OnnxCreateFromFile("benchmark_logistic_model.onnx");
   
//--- Check if the model was created successfully
   if(onnx_handle == INVALID_HANDLE)
     {
      Print("Failed to create ONNX model from file: ", GetLastError());
      return(INIT_FAILED);
     }

//--- Set the input shape of the model
   if(!OnnxSetInputShape(onnx_handle, 0, onnx_input_shape))
     {
      Print("OnnxSetInputShape failed with error: ", GetLastError());
      return(INIT_FAILED);
     }

//--- Set the output shape of the model
   if(!OnnxSetOutputShape(onnx_handle, 0, onnx_output_shape))
     {
      Print("OnnxSetOutputShape failed with error: ", GetLastError());
      return(INIT_FAILED);
     }

//--- Initialization successful
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- Release the ONNX model
   if(onnx_handle != INVALID_HANDLE)
      OnnxRelease(onnx_handle);
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//--- Array to store the price data
   MqlRates rates[];
   
//--- Get the last 2 bars
   if(CopyRates(_Symbol, PERIOD_D1, 0, 2, rates) < 2)
      return;

//--- Create the input data for the model (price change)
   float input_data[1];
   input_data[0] = (float)(rates[1].close - rates[0].close);

//--- Create the output data array
   float output_data[1];

//--- Run the ONNX model
   if(!OnnxRun(onnx_handle, input_data, output_data))
     {
      Print("OnnxRun failed with error: ", GetLastError());
      return;
     }

//--- Execute a trade based on the model's prediction
   if(output_data[0] == 1)
      trade.Buy(InpLots, _Symbol, 0, 0, 0, "Buy order");
   else
      trade.Sell(InpLots, _Symbol, 0, 0, 0, "Sell order");
  }
//+------------------------------------------------------------------+