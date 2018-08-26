require 'rails_helper'

RSpec.describe AwardsController, type: :controller do
  feature 'GET#index' do
    it 'render index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  feature 'GET#repo_awards' do
    before { get :repo_awards, params: { link: 'https://github.com/rails/rails' } }


    it 'should pass repo link to action' do
      expect(controller.params[:link]).to eql 'https://github.com/rails/rails'
    end

    it 'should assign link to @link' do
      expect(assigns(:link)).to eq 'https://github.com/rails/rails'
    end
    it 'should validate api_url'
    it 'should redirect back if api_url invalid'
    it 'should get api response'
    it 'should redirect back if response invalid'
    it 'should get top 3 contributors'

    it 'render repo_awards view' do
      get :repo_awards
      expect(response).to render_template :repo_awards
    end
  end


end
