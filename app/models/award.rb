class Award
  GITHUB_REGEXP = /^(http|https):\/\/github\.com\/[\w|\-|\_]+\/[\w|\-|\_]+(\/|)$/ix
  class << self
    def top_contributors_by_link(link)
      return false unless link_valid?(link)

      api_link = "https://api.github.com/repos/" +
          link.split('/')[-2] + '/' + link.split('/')[-1] +
          "/stats/contributors?page=1&per_page=3"
      github_request(api_link)
    end

    private

    def link_valid?(link)
      link =~ Award::GITHUB_REGEXP ? true : false
    end

    def github_request(api_link)
      r = RestClient::Request.execute(
          method: :get,
          url: api_link)
      parse_top (r)
    rescue RestClient::Exception
      false
    end

    def parse_top(r_json)
      # parse contributors & choose useful info
      contributors = JSON.parse(r_json, symbolize_names: true).each do |man|
        man.select! {| key, value | [:total, :author].include?(key) }
      end

      # get top 3 places & add place into hash
      contributors.sort_by { |hsh| hsh[:total] }.last(3).reverse.each_with_index { |h, i| h[:place] = i+1  }
    end
  end
end