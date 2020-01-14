class SessionsController < ApplicationController
  def new
  end

  def create
    member = Member.find_by(email: params[:session][:email].downcase)
    if member && member.authenticate(params[:session][:password])
      if member.activated?
        log_in member
        params[:session][:remember_me] == '1' ? remember(member) : forget(member)
        redirect_back_or member
      else
        redirect_to :root, notice: "認証が完了してません。登録メールをご確認ください。"
      end
    else
      render 'new', notice: "パスワードが一致しません。"
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to :root
  end
end
