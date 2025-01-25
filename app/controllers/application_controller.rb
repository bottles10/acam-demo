class ApplicationController < ActionController::Base
  include Pundit
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern
  before_action :authenticate_user!


  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = 'You are not assigned to this subject. Cannot perform any action.'
    redirect_to(request.referer || root_path)
  end

  def only_admin_authorized
    unless current_user.admin?
      flash[:alert] =  'Only administrators authorized!'
      redirect_to(request.referer || root_path) and return 
    end
  end
end
