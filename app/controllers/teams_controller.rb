require 'csv'
class TeamsController < ApplicationController
  def show
  end

  def import
    file = params[:file]
    CSV.foreach(file.path, encoding: 'Shift_JIS:UTF-8', headers: true) do |row|
      Timecrowd.new(
        cookies[:timecrowd]
      ).add(
        params[:team_id],
        row['顧客名']
      )
    end
    redirect_to team_path(params[:team_id])
  end
end
