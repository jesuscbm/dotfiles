#!/usr/bin/env python3

"""
Script to display in Polybar-friendly way information of given stocks. Useful to see yout positions crash in live.

Usage: stock_tracker.py --tickers <ticker1> <ticker2> ..

Created by: Jesús Blázquez
Inspired in: Polystock by Zachary Ashen. His is great I just don't like yahoo_fin
"""

import argparse
import yfinance as yf

def printTicker(ticker: str):
    stock = yf.Ticker(ticker)
    data = stock.history(period="2d", interval="1d")
    prev_close, close = data["Close"].iloc[-2], data["Close"].iloc[-1]
    # price = stock.info["regularMarketPrice"]
    percent = ((close - prev_close) / prev_close) * 100
    # Colors are my palette's. Icons are Material Design Icon's
    if percent > 0:
        print(f"%{{F#9ece6a}} {ticker}: {percent:.2f}% %{{F-}}", end="")
    elif percent < 0:
        print(f"%{{F#F7768E}} {ticker}: {percent:.2f}% %{{F-}}", end=" ")
    else:
        print(f"%{{F#7dcfff}} {ticker}: {percent:.2f}% %{{F-}}", end=" ")


parser = argparse.ArgumentParser()
parser.add_argument("--tickers", help="Tickers to display", type=str, nargs="+")
args = parser.parse_args()

if args.tickers is None:
    print("No tickers provided")
    exit(1)

tickers = args.tickers

for ticker in tickers:
    printTicker(ticker)
