class GistService
  GIST_URL_REG = %r{^https:\/\/gist.github.com\/\w+\/\w{32}$}.freeze

  def initialize(client: nil)
    @client = client || Octokit::Client.new
    @client.access_token = Rails.application.credentials.dig(:git, :access_token)
  end

  def gist(url)
    @client.gist(url.last(32))
  end

  def gist?(url)
    GIST_URL_REG.match?(url)
  end
end