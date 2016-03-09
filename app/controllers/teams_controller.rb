require 'csv'
class TeamsController < ApplicationController
  def show
  end

  def import_clients
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

  def import_projects
    clients = {} # name => task_id
    tc = Timecrowd.new(
      cookies[:timecrowd]
    )
    tc.team_tasks(
      params[:team_id], 
      'uncategorized'
    ).each do |t|
      clients[t['title']] = t['id']
    end 
    file = params[:file]
    CSV.foreach(file.path, encoding: 'Shift_JIS:UTF-8', headers: true) do |row|
      #raise row.inspect
      raise '登録されていない顧客が設定されている案件があります' unless clients[row['顧客正式名(必須)']]
      tc.add(
        params[:team_id],
        row['案件名(必須)'],
        clients[row['顧客正式名(必須)']]
      )
    end
    redirect_to team_path(params[:team_id])
  end

end
