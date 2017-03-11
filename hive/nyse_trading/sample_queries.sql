use handson_nasdaq;

-- Find out total volume sale for each stock symbol which has closing price more than $5.
select stock_symbol, sum(stock_volume) total_volume from nasdaq_daily_prices where stock_price_close > 5.0 group by stock_symbol

-- Find out highest price in the history for each stock symbol.
-- assume highest closing price
select stock_symbol, max(stock_price_close) record_closing_price from nasdaq_daily_prices group by stock_symbol

-- Find out highest dividends given for each stock symbol in entire history.
select stock_symbol, max(dividends) record_dividend from nasdaq_dividends group by stock_symbol

-- Find out highest price and highesh dividends for each stock symbol if highest price and highest dividends exist.
-- assume highest closing price
select prices.stock_symbol, prices.record_closing_price, dividends.record_dividend from 
(select stock_symbol, max(stock_price_close) record_closing_price from nasdaq_daily_prices group by stock_symbol) prices 
join
(select stock_symbol, max(dividends) record_dividend from nasdaq_dividends group by stock_symbol) dividends
on prices.stock_symbol = dividends.stock_symbol

-- find the record count where the volatility is greater than the avg volatility for the stock
select count(1) from nasdaq_daily_prices n join 
	(select t.stock_symbol, avg(t.stock_price_high - t.stock_price_low) avg_vol from 
		nasdaq_daily_prices t group by t.stock_symbol) i on i.stock_symbol = n.stock_symbol
where (n.stock_price_high - n.stock_price_low) > i.avg_vol
-- order by n.stock_symbol

-- Find out highest price and highest dividends for each stock symbol, if one of them does not exist then keep Null values.
select prices.stock_symbol, prices.record_closing_price, dividends.record_dividend from 
(select stock_symbol, max(stock_price_close) record_closing_price from nasdaq_daily_prices group by stock_symbol) prices 
full outer join
(select stock_symbol, max(dividends) record_dividend from nasdaq_dividends group by stock_symbol) dividends
on prices.stock_symbol = dividends.stock_symbol