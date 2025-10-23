//+------------------------------------------------------------------+
//|                                      Export_EURUSD_History.mq5 |
//|                        Copyright 2025, https://github.com/Anaswar-ash |
//|                                  author: Ash                     |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, https://github.com/Anaswar-ash"
#property link      "https://github.com/Anaswar-ash"
#property version   "1.00"
#property script_show_inputs

//--- input parameters
input string InpFileName = "raw_price_data.csv"; // File name
input int    InpDays     = 1000;                 // Number of days

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   MqlRates rates[];
   int      copied;

   //--- get daily price data
   copied = CopyRates("EURUSD", PERIOD_D1, 0, InpDays, rates);
   if(copied > 0)
     {
      int file_handle = FileOpen(InpFileName, FILE_WRITE | FILE_CSV | FILE_ANSI, ',');
      if(file_handle != INVALID_HANDLE)
        {
         //--- write header
         FileWrite(file_handle, "Time", "Open", "High", "Low", "Close", "Volume");

         //--- write data
         for(int i = 0; i < copied; i++)
           {
            FileWrite(file_handle,
                      TimeToString(rates[i].time, TIME_DATE),
                      DoubleToString(rates[i].open, _Digits),
                      DoubleToString(rates[i].high, _Digits),
                      DoubleToString(rates[i].low, _Digits),
                      DoubleToString(rates[i].close, _Digits),
                      rates[i].tick_volume);
           }

         FileClose(file_handle);
         Print("Data successfully exported to ", InpFileName);
        }
      else
        {
         Print("Error opening file: ", GetLastError());
        }
     }
   else
     {
      Print("Error copying rates: ", GetLastError());
     }
  }
//+------------------------------------------------------------------+
