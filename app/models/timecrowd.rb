class Timecrowd
  VERSION = 'v1'
  attr_accessor :client, :access_token

  def initialize params = nil
    self.client = OAuth2::Client.new(
      ENV['TIMECROWD_CLIENT_ID'],
      ENV['TIMECROWD_SECRET_KEY'],
      site: 'https://timecrowd.net',
      ssl: { verify: false }
    )

    if params
      params = JSON.parse(params)
      token = params['token']
      refresh_token = params['refresh_token']
      expires_at = params['expires_at']
    elsif Rails.env.development?
      token = File.open("tmp/timecrowd_token.txt", 'r').read
      refresh_token =  File.open("tmp/timecrowd_refresh_token.txt", 'r').read
      expires_at =  File.open("tmp/timecrowd_expires_at.txt", 'r').read
    else
      raise
    end

    self.access_token = OAuth2::AccessToken.new(
      client, token, refresh_token: refresh_token, expires_at: expires_at
    )

    #self.access_token = access_token.refresh! if self.access_token.expired?
    #self.access_token = access_token.refresh!

    #%w(expires_at refresh_token token).each do |key|
    #  val = self.access_token.send(key)
    #  File.open("tmp/timecrowd_#{key}.txt", 'w') { |file| file.write(val) }
    #end
    access_token
  end

  def teams(state = nil)
    access_token.get("/api/#{VERSION}/teams?state=#{state}").parsed
  end

  def add team_id, task_title
    params = {
      task: {
        title: task_title
      }
    }
    url = "/api/#{VERSION}/teams/#{team_id}/tasks.json"
    #raise params.inspect
    #raise url.inspect
    access_token.post(url, body: params).parsed
  end
end

