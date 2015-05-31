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

  def destroy
    resource.soft_delete
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_navigational_format?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end
end