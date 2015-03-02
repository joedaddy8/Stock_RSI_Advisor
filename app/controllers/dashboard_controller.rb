class DashboardController < ApplicationController
  def index
    @stocks = Stock.all
  end

  def stock
  end

  def stock_value
  end

  def update_rsi_warning
    stock = Stock.find(params[:stock_id])
    rsi = stock.rsi_warning
    rsi = RsiWarning.new if rsi.nil?

    rsi.stock_id = params[:stock_id]
    rsi.high_warning = params[:high]
    rsi.low_warning = params[:low]
    rsi.save

    redirect_to controller: :dashboard, action: :index
  end

  def create_stock

  end

  def save_stock
    name = params[:stock_name]
    code = params[:code]

    @s = Stock.new(name:name, code:code)
    @s.save
  end
end
