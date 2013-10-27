class VotesController < ApplicationController
  
  def create
    object = Object.const_get(params[:sym]).find(params[:object])
    authorize! :upvote, object
    vote = object.votes.new(user_id: current_user.id)
    if !vote.save
      flash[:alert] = "You have already voted on this #{object.class.to_s.downcase}."
    end
    if object.class.to_s != 'Post'
      redirect_to object.post
    else
      object.user.update(karma: object.user.update_karma + 1)
      redirect_to object
    end
  end
end