module SessionsHelper

  def log_in(member)
    session[:member_id] = member.id
  end

  def remember(member)
    member.remember
    cookies.permanent.signed[:member_id] = member.id
    cookies.permanent[:remember_token] = member.remember_token
  end

  def current_member?(member)
    member == current_member
  end

  def current_member
    if (member_id = session[:member_id])
      @current_member ||= Member.find_by(id: member_id)
    elsif (member_id = cookies.signed[:member_id])
      member = Member.find_by(id: member_id)
    if member && member.authenticated?(:remember, cookies[:remember_token])
      log_in member
      @current_member = member
    end
  end
end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_member.nil?
  end

  def forget(member)
    member.forget
    cookies.delete(:member_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_member)
    session.delete(:member_id)
    @current_member = nil

  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
