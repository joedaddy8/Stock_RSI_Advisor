class RsiWarning < ActiveRecord::Base
  belongs_to :stock


  def self.send_warnings
    Stock.all.each do |stock|
      warning = RsiWarning.where(stock_id: stock.id).first
      if stock.rsi > warning.high_warning
        Mailer.rsi_email(stock.id, "high").deliver_now
      end

      if stock.rsi < warning.low_warning
        Mailer.rsi_email(stock.id, "low").deliver_now
      end
    end
  end
end
