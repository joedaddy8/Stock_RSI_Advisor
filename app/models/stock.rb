class Stock < ActiveRecord::Base
  has_many :stock_values
  has_one :rsi_warning

  require 'googlecharts'

  def self.codes
    Stock.all.map{|stock|stock.code}.to_a
  end

  #Did the stock go up on this day?
  def up?(date)
     sv= StockValue.where(stock_id: self.id, date: date)
     if sv.nil? or sv.first.nil?
       return nil
     else
       return sv.first.open_value < sv.first.close_value
     end
  end

  def rsi(date = Date.current, range = 14, current_change=0)

    stock_value = StockValue.where(stock_id: self.id, date: date.strftime("%d/%m/%Y"))

    if !stock_value.first.nil? and stock_value.first.yesterdays_stock_value.average_gain.nil? 

      average_gain, average_loss = StockValue.calculate_first_average_changes(stock_value, date.strftime("%d/%m/%Y"))

      return average_gain/(average_loss.abs)
    else

      current_gain = 0
      current_loss = 0

      current_change = StockValue.where(stock_id:self.id, date:date.strftime("%d/%m/%Y")).first.change
      if current_change > 0
        current_gain = current_change
      elsif current_change < 0
        current_loss = current_change
      end

      average_loss, average_gain = stock_value.first.calculate_average_changes

      return (100 - (100/(1 + (average_gain/(average_loss.abs)))))
    end
  end

  def rsi_graph
    @rsi_values = stock_values.sort{|a,b| a.date.to_date <=> b.date.to_date}[-14..-1] 
    @rsi_values.map!{|stock_value| stock_value.rsi_value.round(2)}
    Gchart.new(type: 'line',
               title:"#{name} - RSI",
               size: '1000x250',
               axis_with_labels: [['x'],['y']],
               axis_labels: [[@rsi_values.join("|")],[(0..100).to_a.keep_if{|val|val%10==0}.join("|")]],
               data: @rsi_values)
  end

  def correct
    count = 0

    stock_values.sort{|a,b| a.date.to_date <=> b.date.to_date}.each do |stock_value|
      count = count + 1
      next if count < 15
      stock_value.calculate_average_changes
      stock_value.rsi_value
    end
  end
end
