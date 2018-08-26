class AwardsController < ApplicationController
  def repo_awards
    @link = params[:link]
  end
end
