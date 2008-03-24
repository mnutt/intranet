class PositionsController < ApplicationController
  def create
    @position = Position.new(:team => Team.find(params[:position][:team_id]),
                             :user => User.find(params[:user_id]),
                             :title => params[:position][:title],
                             :description => params[:position][:description])
    @position.save!
    render :layout => false
  end

  def destroy
    if @position = Position.find(params[:id])
      @position.destroy
      render :nothing => true
    else
      raise "Could not remove position"
    end
  end
end
