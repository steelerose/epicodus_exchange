class VotesController < ApplicationController
  def create
    object = Object.const_get(params[:sym]).find(params[:object])
    vote = object.votes.new
    if !vote.save
      flash[:alert] = '' 
    end
    if object.class.to_s != 'Post'
      redirect_to object.post
    else
      redirect_to object
    end
  end
end