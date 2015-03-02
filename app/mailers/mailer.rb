class Mailer < ApplicationMailer
  def rsi_email(stock_id, warning_type)
    @w = warning_type
    @stock = Stock.find(stock_id)
    @warning = RsiWarning.where(stock_id: stock_id).first

    @destination = ["sincapyuvasi@gmail.com","serkanoran1234@gmail.com"]
    mail(to: @destination, subject: "RSI too #{warning_type} for #{@stock.name}")
  end


end
