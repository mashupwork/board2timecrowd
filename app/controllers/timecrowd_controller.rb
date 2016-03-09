class TimecrowdController < ApplicationController
  def login
    auth_hash = request.env['omniauth.auth']

    keys = {}
    %w(expires_at refresh_token token).each do |key|
      val = auth_hash.credentials.send(key)
      #keys["timecrowd_#{key}"] = val
      keys[key] = val
      if Rails.env.development?
        File.open("tmp/timecrowd_#{key}.txt", 'w') { |file| file.write(val) }
      end
    end
    cookies['timecrowd'] = keys.to_json

    redirect_to '/?timecrowd=1', notice: 'Signed in successfully'
  end
end

