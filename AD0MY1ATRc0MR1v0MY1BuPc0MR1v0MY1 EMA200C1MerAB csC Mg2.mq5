//+------------------------------------------------------------------+
//|                                          Chat_GPT3_5.mq5         |
//|                                   Copyright 2023, YourName      |
//|                                     http://www.yourwebsite.com  |
//+------------------------------------------------------------------+
#property copyright "2023, YourName"
#property link      "http://www.yourwebsite.com"
#property version   "1.0"
#property description "Your Expert Advisor Description"
#property strict

input double LotSize = 0.2;
input int EMAPeriod = 200;
input ENUM_TIMEFRAMES Period = PERIOD_H2; // Default 2-hour period

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    //---
    return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    //---
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    double emaPrev = iMA(Symbol(), Period, EMAPeriod, 1, MODE_EMA, 1);
    double emaCurr = iMA(Symbol(), Period, EMAPeriod, 0, MODE_EMA, 1);
    double atrPrev = iATR(Symbol(), Period, 14);
    double atrCurr = iATR(Symbol(), Period, 14);
    double bpPrev = iBullsPower(Symbol(), Period, 1);
    double bpCurr = iBullsPower(Symbol(), Period, 0);

    if (emaPrev > iClose(Symbol(), Period, 1) && emaCurr < iClose(Symbol(), Period, 0) && atrCurr < atrPrev && bpCurr < bpPrev)
    {
        MqlTradeRequest request;
        MqlTradeResult result;
        ZeroMemory(request);
        request.action = TRADE_ACTION_DEAL;
        request.symbol = Symbol();
        request.volume = LotSize;
        request.type = ORDER_TYPE_BUY;
        request.price = SymbolInfoDouble(Symbol(), SYMBOL_BID);
int slippage = 3; // Declare and define the slippage variable
request.slippage = slippage; // Use the slippage variable
        request.magic = 123456789;
        if(OrderSend(request, result))
        {
            // Order opened successfully
        }
    }
    else if (emaPrev < iClose(Symbol(), Period, 1) && emaCurr > iClose(Symbol(), Period, 0) && atrCurr > atrPrev && bpCurr > bpPrev)
    {
        MqlTradeRequest request;
        MqlTradeResult result;
        ZeroMemory(request);
        request.action = TRADE_ACTION_DEAL;
        request.symbol = Symbol();
        request.volume = LotSize;
        request.type = ORDER_TYPE_SELL;
        request.price = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
        request.slippage = 3;
        request.magic = 123456789;
        if(OrderSend(request, result))
        {
            // Order opened successfully
        }
    }

    if (emaPrev < iClose(Symbol(), Period, 1) && emaCurr > iClose(Symbol(), Period, 0) && (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY || PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL))
{
        MqlTradeRequest request;
        MqlTradeResult result;
        ZeroMemory(request);
        request.action = TRADE_ACTION_REMOVE;
int index = 0; // Index of the order in the order pool
request.order = OrderGetTicket(index);
        if(OrderSend(request, result))
        {
            // Order closed successfully
        }
    }
}
//+------------------------------------------------------------------+
