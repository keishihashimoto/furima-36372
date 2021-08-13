class ApplicationController < ActionController::Base
  before_action :user_basic

  private
  def user_basic
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]
    end
  end
end
