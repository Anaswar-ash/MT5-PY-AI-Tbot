//+------------------------------------------------------------------+
//|                                           Benchmark_Model_EA.mq5 |
//|                        Copyright 2025, https://github.com/Anaswar-ash |
//|                                  author: Ash                     |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, https://github.com/Anaswar-ash"
#property link      "https://github.com/Anaswar-ash"
#property version   "1.00"

#include <Trade/Trade.mqh>

//--- ONNX model parameters
int onnx_handle;
long onnx_input_shape[] = {1, 1};
long onnx_output_shape[] = {1, 1};

//--- Expert Advisor parameters
input double InpLots          = 0.1;
input int    InpStopLoss      = 50;
input int    InpTakeProfit    = 100;

CTrade trade;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   onnx_handle = OnnxCreateFromFile("benchmark_logistic_model.onnx");
   if(onnx_handle == INVALID_HANDLE)
     {
      Print("Failed to create ONNX model from file: ", GetLastError());
      return(INIT_FAILED);
     }

   if(!OnnxSetInputShape(onnx_handle, 0, onnx_input_shape))
     {
      Print("OnnxSetInputShape failed with error: ", GetLastError());
      return(INIT_FAILED);
     }

   if(!OnnxSetOutputShape(onnx_handle, 0, onnx_output_shape))
     {
      Print("OnnxSetOutputShape failed with error: ", GetLastError());
      return(INIT_FAILED);
     }

   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(onnx_handle != INVALID_HANDLE)
      OnnxRelease(onnx_handle);
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   MqlRates rates[];
   if(CopyRates(_Symbol, PERIOD_D1, 0, 2, rates) < 2)
      return;

   float input_data[1];
   input_data[0] = (float)(rates[1].close - rates[0].close);

   float output_data[1];

   if(!OnnxRun(onnx_handle, input_data, output_data))
     {
      Print("OnnxRun failed with error: ", GetLastError());
      return;
     }

   if(output_data[0] == 1)
      trade.Buy(InpLots, _Symbol, 0, 0, 0, "Buy order");
   else
      trade.Sell(InpLots, _Symbol, 0, 0, 0, "Sell order");
  }
//+------------------------------------------------------------------+
