module Github
  class Repository
    def initialize(repository)
      @client = Octokit::Client.new access_token: ENV['GITHUB_TOKEN']
      @repository = Octokit::Repository.new repository
    end

    def runs
      @client.get @repository.path + '/actions/runs', branch: 'master', status: 'completed'
    end

    def artifacts(run_id)
      @client.get @repository.path + '/actions/runs/' + run_id.to_s + '/artifacts'
    end

    def artifact_archive(artifact_id)
      @client.get @repository.path + '/actions/artifacts/' + artifact_id.to_s + '/zip'
    end
  end
end