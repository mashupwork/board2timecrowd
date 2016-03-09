class WelcomeController < ApplicationController
  def index
    if cookies[:timecrowd]
      @timecrowd = Timecrowd.new(cookies[:timecrowd])
    end
  end
end
