require 'spec_helper'

RSpec.describe GetTopContributors, type: :interactor do
  feature 'should validate repo_url' do
    urls = {
        'https://github.com/rails/rails/' => true,
        'https://github.com/solidusio/solidus_paypal_braintree' => true,
        'http://github.com/donnemartin/system-design-primer' => true,
        'https://github.com/rails/' => false,
        'https://bitbucket.com/rails/rails' => false,
        'https://github.com/rails/rails/asdasdasd' => false
    }
    urls.each do  |repo,validation|
      interactor = GetTopContributors.call(repo: repo)
      if validation
        it "#{repo} should be valid" do
          expect(interactor).to be_a_success
        end
      else
        it "#{repo} should be invalid" do
          expect(interactor).not_to be_a_success
        end
      end
    end
  end
end
