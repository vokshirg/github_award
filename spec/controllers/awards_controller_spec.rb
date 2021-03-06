require 'rails_helper'

RSpec.describe AwardsController, type: :controller do
  feature 'GET#index' do
    it 'render index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  feature 'GET#repo_awards' do
    feature 'valid requests' do
      before { get :repo_awards, params: { link: 'https://github.com/rails/rails' } }

      it 'should pass repo link to action' do
        expect(controller.params[:link]).to eql 'https://github.com/rails/rails'
      end

      it 'render repo_awards view' do
        expect(response).to render_template :repo_awards
      end

      it 'should get top 3 contributors'
    end

    it 'should redirect back if api_url invalid' do
      get :repo_awards, params: { link: '' }
      expect(response).to redirect_to action: :index
    end
  end
end
