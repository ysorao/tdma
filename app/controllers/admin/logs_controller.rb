class Admin::LogsController < ApplicationController
  # before_action :authenticate_user!
  
  def index
    @lines = params[:lines] || 100
    log_file = Rails.root.join('log', "#{Rails.env}.log")
    @logs = `tail -n #{@lines} #{log_file}`.split("\n")
  end
end
