class AccountActivationsController < ApplicationController

  def edit
    member = Member.find_by(email: params[:email])
    if member && !member.activated? && member.authenticated?(:activation, params[:id])
      member.activate
      log_in member
      redirect_to member, notice: "Account activated!"
    else
      redirect_to :root, notice: "Invalid activation link"
    end
  end
end
