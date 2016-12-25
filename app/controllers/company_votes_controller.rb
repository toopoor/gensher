class CompanyVotesController < ApplicationController
  before_action :set_company, only: [:create]

  def create
    @company_vote = @company.company_votes.by_user(current_user).create(company_vote_params)
    respond_to do |format|
      format.js
    end
  end

  protected
  def set_company
    @company = Company.find(params[:company_id])
  end

  def company_vote_params
    params.require(:company_vote).permit(:vote)
  end
end