class ApplicationController < ActionController::Base
  include Pundit::Authorization
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern
  before_action :set_current_school
  before_action :teacher_assigned_subject?, unless: -> { action_name.in?(["waiting_room", "destroy"]) }
  before_action :configure_permitted_parameters, if: :devise_controller?


  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def set_current_school
    if request.subdomain.present? && request.subdomain != 'www'
      @current_school = School.find_by(subdomain: request.subdomain)
      if @current_school
        Current.school = @current_school
      end
      redirect_to main_root_url(subdomain: nil), allow_other_host: true,  alert: 'School not found' and return  unless @current_school
    end
  end

  def teacher_assigned_subject?
    return unless user_signed_in?
  
    if current_user.teacher? && current_user.subjects.blank?
      flash[:alert] = "Account created! Wait for admin to assign you a subject!"
      redirect_to waiting_room_path and return
    end
  end

  def user_not_authorized
    flash[:alert] = 'You are not assigned to this subject. Cannot perform any action.'
    redirect_to(request.referer || school_root_path) and return
  end

  def only_admin_authorized
    unless current_user.admin?
      flash[:alert] =  'Only administrators authorized!'
      redirect_to(request.referer || school_root_path) and return 
    end
  end


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
  end
end
