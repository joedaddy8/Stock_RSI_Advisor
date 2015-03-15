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

  def rsi(date = Date.current, range = 14, current_change)

    up_days = []
    down_days = []

    last_business_day = 1.business_day.before(date)
    stock_value = StockValue.where(stock_id: self.id, date: last_business_day.strftime("%d/%m/%Y"))

    lookup_range = 4
    count = 0

    while stock_value.empty? and count < lookup_range
      last_business_day = 1.business_day.before(last_business_day)
      stock_value = StockValue.where(stock_id: self.id, date: last_business_day.strftime("%d/%m/%Y"))
      count = count + 1
    end


    if stock_value.empty? and stock_value.first.nil?
      
      dates = stock_value.first.get_last_14_stock_values.map{|sv|sv.date.to_date}
      dates.each do |date|
        up = self.up? date.strftime("%d/%m/%Y")
        if up == true
          up_days << day
        elsif up == false
          down_days << day
        end
      end

      up_days.map!{|date|StockValue.where(stock_id:id,date:date.strftime("%d/%m/%Y")).first.change}
      down_days.map!{|date|StockValue.where(stock_id:id,date:date.strftime("%d/%m/%Y")).first.change}

      average_gain = (up_days.sum)/range rescue 0.01
      average_loss = (down_days.sum)/range rescue 0.01

      return average_gain/(average_loss.abs)
    else

      avg_loss, avg_gain = stock_value.first.calculate_average_changes
      avg_gain = 0.001 if avg_gain.nil?
      avg_loss = 0.001 if avg_loss.nil?

      current_gain = 0
      current_loss = 0

      current_change = stock_values.last.change
      if current_change > 0
        current_gain = current_change
      elsif current_change < 0
        current_loss = current_change
      end

      average_gain = (avg_gain * 13 + current_gain) / 14
      average_loss = ((avg_loss.abs * 13 + current_loss.abs) / 14).abs

      return 100 - (100/(1 + (average_gain/average_loss)))
    end
  end

end
