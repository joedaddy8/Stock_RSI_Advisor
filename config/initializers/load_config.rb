APP_CONFIG = Hash.new
APP_CONFIG["pwd"] = ENV["pwd"]
APP_CONFIG["app_pwd"] = ENV["app_pwd"]
APP_CONFIG["app_pwd"] = 'test' if APP_CONFIG["app_pwd"].nil? 
