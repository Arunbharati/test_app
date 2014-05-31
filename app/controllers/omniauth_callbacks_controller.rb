class OmniauthCallbacksController < Devise::OmniauthCallbacksController   
  def all
    auth = env["omniauth.auth"]
    user = User.from_omniauth(request.env["omniauth.auth"],current_user)
    if user.persisted?
      flash[:notice] = "Welcome! You have signed up successfully."
      sign_in_and_redirect(user)
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to root_url
    end
  end
    alias_method :facebook, :all
    alias_method :linkedin, :all
    alias_method :google_oauth2, :all
end