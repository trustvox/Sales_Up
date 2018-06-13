class ApplicationController < ActionController::Base
  include DatabaseSearchs
  helper DatabaseSearchs

  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def json_maker(user_email, email_subject, email_content)
    { email: user_email, subject: email_subject, content: email_content }
  end

  def after_sign_in_path_for(resource)
    if user_signed_in?
      stored_location_for(resource) || overview_months_path
    else
      root_path
    end
  end

  def authenticate_user!
    if user_signed_in?
      if current_user.new_user?
        sign_out_and_redirect(current_user)
      else
        super
      end
    else
      redirect_to root_path, alert: 'You must sign in first'
      ## if you want render 404 page
      ## render :file => File.join(Rails.root, 'public/404'),
      ## :formats => [:html], :status => 404, :layout => false
    end
  end

  def configure_permitted_parameters
    attrs_create = %i[full_name email password password_confirmation]
    attrs_login = %i[email password]

    devise_parameter_sanitizer.permit :sign_in, keys: attrs_login
    devise_parameter_sanitizer.permit :sign_up, keys: attrs_create
    devise_parameter_sanitizer.permit :account_update, keys: attrs_create
  end
end
