module ApplicationHelper

  def current_user
    User.find_by(code:session[:code])
  end
end
