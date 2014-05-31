class HomeController < ApplicationController
  def index
    @categories = Category.all
  end
  
  def user
    @users = User.all.reject{|u| u.email == "admin@admin.com" }
  end
  def change_role
    User.find(params[:id]).roles.first.update_attributes(:name => params[:role])
  end
end
