require "open-uri"

module GithubUtil
  API_HOST = "api.github.com"
  class << self
    def get_master_commit_url(repository)
      ActiveSupport::JSON.decode(open("https://#{API_HOST}/repos/#{repository.username}/#{repository.name}/git/refs/heads/master"))["object"]["url"]
    end

    def get_tree_url(repository)
      ActiveSupport::JSON.decode(open(get_master_commit_url(repository)))["tree"]["url"]
    end

    def get_gemfile_url(repository)
      tree = ActiveSupport::JSON.decode(open(get_tree_url(repository)))["tree"]
      gemfile_info = tree.find {|info| info["path"] == "Gemfile"}
      if gemfile_info
        gemfile_info["url"]
      else
        nil
      end
    end

    def get_gemfile_body(repository)
      blob = ActiveSupport::JSON.decode(open(get_gemfile_url(repository)))
      if blob["encoding"] == "base64"
        content = Base64.decode64(blob["content"])
      else
        content = blob["content"]
      end
      content
    rescue OpenURI::HTTPError
      nil
    end
  end
end
