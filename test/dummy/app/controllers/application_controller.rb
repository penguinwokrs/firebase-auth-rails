class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  include Firebase::Auth::Authenticable
  # before_action :authenticate_user
end
