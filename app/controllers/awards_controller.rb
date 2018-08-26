class AwardsController < ApplicationController
  def index
  end

  def repo_awards
    @link = params[:link]
    @contributors = Award.top_contributors_by_link(@link)
    unless @contributors
      flash[:error] = "Link empty or invalid"
      redirect_to action: 'index'
    end
  end

  def diplom
  end

  def download_zip
  end
end
