class MembersController < ApplicationController
  before_action :logged_in_member, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_member, only: [:edit, :update]
  before_action :admin_member, only: :destroy

  def index
    @members = Member.paginate(page: params[:page], per_page: 15)
  end

  def show
    @member = Member.find(params[:id])
    @entries = @member.entries.paginate(page: params[:page], per_page: 3)
    # debugger
  end

  def new
    @member = Member.new
  end

  def create
    @member = Member.new(member_params)
    if @member.save
      @member.send_activation_email
      redirect_to :root, notice: "認証確認メール送りましたので「Activate」をクリックしてください。"
    else
      render "new"
    end
  end

  def edit

  end

  def update
    if @member.update_attributes(member_params)
      redirect_to @member, notice: "変更が完了しました。"
    else
      render 'edit'
    end
  end

  def destroy
    Member.find(params[:id]).destroy
    redirect_to :members, notice: "会員を削除しました。"
  end

  def following
    @title = "Following"
    @member  = Member.find(params[:id])
    @members = @member.following.paginate(page: params[:page], per_page: 10)
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @member  = Member.find(params[:id])
    @members = @member.followers.paginate(page: params[:page], per_page: 3)
    render 'show_follow'
  end

  private

  def member_params
    params.require(:member).permit(:new_profile_picture, :remove_profile_picture,
                    :name, :email, :password, :password_confirmation, :profile)
  end

  def logged_in_member
    unless logged_in?
      store_location
      redirect_to login_url, notice: "ログインしてください。"
    end
  end

  def correct_member
    @member = Member.find(params[:id])
    redirect_to(root_url) unless current_member?(@member)
end


  def admin_member
    redirect_to(root_url) unless current_member.admin?
  end
end
