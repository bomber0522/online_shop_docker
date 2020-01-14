class Admin::MembersController < Admin::Base

  def index
    @members = Member.paginate(page: params[:page], per_page: 15)
  end

  def show
    @member = Member.find(params[:id])
    @entries = @member.entries.paginate(page: params[:page], per_page: 3)
  end

  def destroy
    Member.find(params[:id]).destroy
    flash[:success] = "Member deleted"
    redirect_to :admin_members, notice: "会員を削除しました。"
  end
end
