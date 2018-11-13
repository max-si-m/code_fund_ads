# frozen_string_literal: true
class SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]

  protected

  def after_sign_in_path_for(user)
    dashboard_path
  end

  def after_sign_out_path_for(user)
    new_user_session_path
  end
end
