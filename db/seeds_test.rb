stock = Stock.create(name:'Test Stock', code: 'TST')

StockValue.create(stock_id:stock.id, date:'14/12/2009', change:0 , open_value:44.34 ,close_value:44.34 )
StockValue.create(stock_id:stock.id, date:'15/12/2009', change:-0.25 , open_value:44.34 ,close_value:44.09 )
StockValue.create(stock_id:stock.id, date:'16/12/2009', change:0.06 , open_value:44.09 ,close_value:44.15 )
StockValue.create(stock_id:stock.id, date:'17/12/2009', change:-0.54 , open_value:44.15 ,close_value:43.61 )
StockValue.create(stock_id:stock.id, date:'18/12/2009', change:0.72 , open_value:43.61 ,close_value:44.33 )
StockValue.create(stock_id:stock.id, date:'21/12/2009', change:0.5 , open_value:44.33 ,close_value:44.83 )
StockValue.create(stock_id:stock.id, date:'22/12/2009', change:0.27 , open_value:44.83 ,close_value:45.10 )
StockValue.create(stock_id:stock.id, date:'23/12/2009', change:0.33 , open_value:45.10 ,close_value:45.42 )
StockValue.create(stock_id:stock.id, date:'24/12/2009', change:0.42 , open_value:45.42 ,close_value:45.84 )
StockValue.create(stock_id:stock.id, date:'28/12/2009', change:0.24 , open_value:45.84 ,close_value:46.08 )
StockValue.create(stock_id:stock.id, date:'29/12/2009', change:-0.19 , open_value:46.08 ,close_value:45.89 )
StockValue.create(stock_id:stock.id, date:'30/12/2009', change:0.14 , open_value:45.89 ,close_value:46.03 )
StockValue.create(stock_id:stock.id, date:'31/12/2009', change:-0.42 , open_value:46.03 ,close_value:45.61 )
StockValue.create(stock_id:stock.id, date:'04/01/2010', change:0.67 , open_value:45.61 ,close_value:46.28 )
StockValue.create(stock_id:stock.id, date:'05/01/2010', change:0 , open_value:46.28 ,close_value:46.28 )
StockValue.create(stock_id:stock.id, date:'06/01/2010', change:-0.28 , open_value:46.28 ,close_value:46 )
StockValue.create(stock_id:stock.id, date:'07/01/2010', change:0.03 , open_value:46 ,close_value:46.03 )
StockValue.create(stock_id:stock.id, date:'08/01/2010', change:0.38 , open_value:46.03 ,close_value:46.41 )
StockValue.create(stock_id:stock.id, date:'11/01/2010', change:-0.19 , open_value:46.41 ,close_value:46.22 )
StockValue.create(stock_id:stock.id, date:'12/01/2010', change:-0.58 , open_value:46.22 ,close_value:45.64 )
StockValue.create(stock_id:stock.id, date:'13/01/2010', change:0.57 , open_value:45.64 ,close_value:46.21 )
StockValue.create(stock_id:stock.id, date:'14/01/2010', change:0.04 , open_value:46.21 ,close_value:46.25 )
StockValue.create(stock_id:stock.id, date:'15/01/2010', change:-0.54 , open_value:46.25 ,close_value:45.71 )
StockValue.create(stock_id:stock.id, date:'19/01/2010', change:0.74 , open_value:45.71 ,close_value:46.45 )
StockValue.create(stock_id:stock.id, date:'20/01/2010', change:-0.67 , open_value:46.45 ,close_value:45.78 )
StockValue.create(stock_id:stock.id, date:'21/01/2010', change:-0.43 , open_value:45.78 ,close_value:45.35 )
StockValue.create(stock_id:stock.id, date:'22/01/2010', change:-1.33 , open_value:45.35 ,close_value:44.03 )
StockValue.create(stock_id:stock.id, date:'25/01/2010', change:0.15 , open_value:44.03 ,close_value:44.18 )
StockValue.create(stock_id:stock.id, date:'26/01/2010', change:0.04 , open_value:44.18 ,close_value:44.22 )
StockValue.create(stock_id:stock.id, date:'27/01/2010', change:0.35 , open_value:44.22 ,close_value:44.57 )

sorted_stock_values = StockValue.all.sort{|a,b| a.date.to_date <=> b.date.to_date}

sorted_stock_values.each do |stock_value|

  next if stock_value.date.to_date < DateTime.new(2010,1,15) 

  down, up = stock_value.calculate_average_changes
  stock_value.rsi_value
end
