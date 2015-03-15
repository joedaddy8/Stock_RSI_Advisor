class StockValue < ActiveRecord::Base
  require 'net/http'

  belongs_to :stock

  def rsi_value
    if rsi.nil?
      new_rsi = stock.rsi(DateTime.strptime(date,"%d/%m/%Y"), 14, change)
      self.rsi = new_rsi
      self.save
    end

    return rsi
  end

  def calculate_average_changes
    if !average_gain.nil? and !average_loss.nil?
#      return average_loss, average_gain
    end

    range = 14
    up_days = []
    down_days = []

    ((date.to_date - range.days)..date.to_date).each do |day|
      
      up = self.up?(day.strftime("%d/%m/%Y"))
      next if up.nil?
      if up
        up_days << day
      elsif !up
        down_days << day
      end
    end

    up_days.map!{|date|StockValue.where(stock_id:id,date:date.strftime("%d/%m/%Y")).first.try(:change)}
    down_days.map!{|date|StockValue.where(stock_id:id,date:date.strftime("%d/%m/%Y")).first.try(:change)}

    up_average = (up_days.sum)/14 rescue 0.01
    down_average = (down_days.sum)/14 rescue 0.01

    self.average_gain = up_average
    self.average_loss = down_average
    self.save

    return down_average, up_average
  end

  def average_loss
    range = 14
    down_days = []

    ((date.to_date - range.days)..date.to_date).each do |day|
      down = !(self.up? day.strftime("%d/%m/%Y"))
      if down == true
        down_days << day
      end
    end
      down_days.map!{|date|StockValue.where(stock_id:id,date:date.strftime("%d/%m/%Y")).first.try(:change)}
      (down_days.sum)/14 rescue 0.01
  end

  def average_gain
    range = 14
    up_days = []

    ((date.to_date - range.days)..date.to_date).each do |day|
      up = self.up? day.strftime("%d/%m/%Y")
      if up == true
        up_days << day
      end
    end
      up_days.map!{|date|StockValue.where(stock_id:id,date:date.strftime("%d/%m/%Y")).first.try(:change)}
      (up_days.sum)/14 rescue 0.01
  end

  def yesterdays_stock_value
    StockValue.where(stock_id: self.stock_id, date: 1.business_day.before(date.to_date).strftime("%d/%m/%Y")).first
  end

  def yesterdays_rsi
    StockValue.where(stock_id: self.stock_id, date: 1.business_day.before(date.to_date).strftime("%d/%m/%Y")).try(:rsi_value)
  end


  def self.populate_values(historical = false) 
    #Update current day
    if(!historical)
      Stock.all.each do |stock|
        data = YahooFinance.quotes([stock.code], [:average_daily_volume, :change, :change_in_percent, :close, :high, :low, :open, :pe_ratio, :previous_close, :volume])[0]

        s = StockValue.create(stock_id:stock.id, average_daily_volume:data.average_daily_volume, change:data.change, change_in_percent:data.change_in_percent.to_d, close_value:data.close, high:data.high, low:data.low, open_value:data.open, pe_ratio:data.pe_ratio, previous_close:data.previous_close, volume:data.volume, date:Date.current.strftime("%d/%m/%Y")) 
      end
    else
      #Update history
      Stock.all.each do |stock|
        begin
          data = YahooFinance.historical_quotes(stock.code, period: :daily)
          data.each do |stock_value|
            trade_date = "#{stock_value.trade_date[8..9]}/#{stock_value.trade_date[5..6]}/#{stock_value.trade_date[0..3]}"
            next if DateTime.strptime(trade_date,"%d/%m/%Y") < DateTime.new(2014,1,1)
            StockValue.create(stock_id:stock.id, change: stock_value.close.to_d - stock_value.open.to_d, change_in_percent: (stock_value.close.to_d - stock_value.open.to_d)/stock_value.close.to_d, close_value:stock_value.close, high:stock_value.high, low:stock_value.low, open_value:stock_value.open, date:trade_date)
          end
        rescue OpenURI::HTTPError => ex
          puts "Failing to import historical quotes for #{stock.name}. #{ex}"
        end
      end
    end
  end

  def self.post_fill_rsi_values
    sorted_stock_values = StockValue.all.sort{|a,b| a.date.to_date <=> b.date.to_date}

    sorted_stock_values.each do |stock_value|
      next if stock_value.date.to_date < DateTime.new(2015) 
      stock_value.rsi_value
    end
  end

  def up?(lookup_date= self.date)
    stock_value = StockValue.where(stock_id: stock_id, date: lookup_date).first 

    return nil if stock_value.nil?

    (stock_value.close_value - stock_value.open_value) > 0
  end
end
