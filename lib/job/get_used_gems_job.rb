module Job
  class GetUsedGemsJob
    @queue = :get_used_gems

    def self.perform(repo_id)
      repo = Repository.find(repo_id)
      repo.used_gems.clear
      repo.get_gemfile
      repo.gemfile.get_used_gems
    end
  end
end
