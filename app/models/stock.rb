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
    stock_value = StockValue.where(stock_id: self.id, date: date.strftime("%d/%m/%Y"))
#    stock_value = StockValue.where(stock_id: self.id, date: last_business_day.strftime("%d/%m/%Y"))

    lookup_range = 7
    count = 0

#    while stock_value.empty? and count < lookup_range
#      last_business_day = 1.business_day.before(last_business_day)
#      stock_value = StockValue.where(stock_id: self.id, date: last_business_day.strftime("%d/%m/%Y"))
#      count = count + 1

#    end


    if !stock_value.first.nil? and stock_value.first.yesterdays_stock_value.average_gain.nil? 
      dates = stock_value.first.get_last_14_stock_values.map{|sv|sv.date.to_date}
      dates.each do |date|
        up = self.up? date.strftime("%d/%m/%Y")
        if up == true
          up_days << date
        elsif up == false
          down_days << date
        end
      end

      up_days.map!{|date|StockValue.where(stock_id:id,date:date.strftime("%d/%m/%Y")).first.change}
      down_days.map!{|date|StockValue.where(stock_id:id,date:date.strftime("%d/%m/%Y")).first.change}

      average_gain = (up_days.sum)/range rescue 0.01
      average_loss = (down_days.sum)/range rescue 0.01

      return average_gain/(average_loss.abs)
    else
      puts "Second loop"

      current_gain = 0
      current_loss = 0

      current_change = StockValue.where(stock_id:self.id, date:date.strftime("%d/%m/%Y")).first.change
      if current_change > 0
        current_gain = current_change
      elsif current_change < 0
        current_loss = current_change
      end

      average_loss, average_gain = stock_value.first.calculate_average_changes



      puts "date is #{date.strftime('%d/%m/%Y')}"
      puts "old avg gain #{average_gain}"
      puts "old avg loss #{average_loss.abs}"
      puts "current gain #{current_gain}"
      puts "current loss #{current_loss}"

      puts "RS = #{average_gain/average_loss}"
      puts "RSI = #{100 - (100/(1 + (average_gain/average_loss)))}"
      
      return (100 - (100/(1 + (average_gain/(average_loss.abs)))))
    end
  end

end
