class Stock < ActiveRecord::Base
  has_many :stock_values
  has_one :rsi_warning

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

end
