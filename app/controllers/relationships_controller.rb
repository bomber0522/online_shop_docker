class RelationshipsController < ApplicationController
  before_action :logged_in?

  def create
    @member = Member.find(params[:followed_id])
    current_member.follow(@member)
    respond_to do |format|
      format.html { redirect_to @member }
      format.js
    end
  end

  def destroy
    @member = Relationship.find(params[:id]).followed
    current_member.unfollow(@member)
    respond_to do |format|
      format.html { redirect_to @member }
      format.js
    end
  end
end
