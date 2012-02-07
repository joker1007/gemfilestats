require "open-uri"

module GithubUtil
  API_HOST = "api.github.com"
  class << self
    def get_master_commit_url(repository)
      ActiveSupport::JSON.decode(open("https://#{API_HOST}/repos/#{repository.username}/#{repository.name}/git/refs/heads/master"))["object"]["url"]
    end
  end
end
