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
input string InpFileName = "raw_price_data.csv"; // File name to save the data to
input int    InpDays     = 1000;                 // Number of days of historical data to export

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//--- Array to store the price data
   MqlRates rates[];
//--- Variable to store the number of bars copied
   int      copied;

//--- Get daily price data for EURUSD for the specified number of days
   copied = CopyRates("EURUSD", PERIOD_D1, 0, InpDays, rates);
   
//--- Check if the data was copied successfully
   if(copied > 0)
     {
      //--- Open the file to write the data to
      int file_handle = FileOpen(InpFileName, FILE_WRITE | FILE_CSV | FILE_ANSI, ',');
      
      //--- Check if the file was opened successfully
      if(file_handle != INVALID_HANDLE)
        {
         //--- Write the header row to the CSV file
         FileWrite(file_handle, "Time", "Open", "High", "Low", "Close", "Volume");

         //--- Loop through the copied data and write each row to the CSV file
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

         //--- Close the file
         FileClose(file_handle);
         Print("Data successfully exported to ", InpFileName);
        }
      else
        {
         //--- Print an error message if the file could not be opened
         Print("Error opening file: ", GetLastError());
        }
     }
   else
     {
      //--- Print an error message if the data could not be copied
      Print("Error copying rates: ", GetLastError());
     }
  }
//+------------------------------------------------------------------+