class GetTopContributors
  include Interactor

  def call
    @contributors = top_contributors_by_repo(context.repo) if repo_valid?(context.repo)

    if @contributors.blank?
      context.fail!(message: "Link empty or invalid")
    else
      context.contributors = @contributors
    end
  end

  private

  def top_contributors_by_repo(repo_url)
    owner = repo_url.split('/')[-2]
    repo = repo_url.split('/')[-1]
    api_link = "https://api.github.com/repos/" +
        owner + '/' + repo +
        "/stats/contributors?page=1&per_page=3"
    github_request(api_link)
  end

  def repo_valid?(repo_url)
    repo_url =~ /^(http|https):\/\/github\.com\/[\w|\-|\_]+\/[\w|\-|\_]+(\/|)$/ix ? true : false
  end

  def github_request(api_link)
    request = RestClient::Request.execute(
        method: :get,
        url: api_link)
    parse_top (request)
  rescue RestClient::Exception
    []
  end

  def parse_top(all_contribs_json)
    # parse contributors & choose useful info
    contributors = JSON.parse(all_contribs_json, symbolize_names: true).map {
        |man| man.select! {| key, value | [:total, :author].include?(key) }
    }

    # get top 3 places & add place into hash
    contributors.sort_by { |hsh| hsh[:total] }.last(3).reverse.each_with_index { |contrib, i| contrib[:place] = i+1 }
  end
end
