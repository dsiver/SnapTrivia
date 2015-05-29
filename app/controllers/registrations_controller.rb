class RegistrationsController < Devise::RegistrationsController

  def create
    @user = build_resource # Needed for Merit
    super
  end

  def after_sign_up_path_for(resource)
    game_rules_path
  end

  def update
    @user = resource # Needed for Merit
    super
  end

  def update_resource(resource, params)
    if session[:logged_in_omniauth].present?
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end
end