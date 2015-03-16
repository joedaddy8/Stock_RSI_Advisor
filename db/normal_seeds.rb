Stock.create(name:'Agilent Technologies' , code: 'A')
Stock.create(name:'Alcoa' , code: 'AA')
Stock.create(name:'American Airlines' , code: 'AAL')

StockValue.populate_values
StockValue.populate_values(true)

StockValue.post_fill_rsi_values
