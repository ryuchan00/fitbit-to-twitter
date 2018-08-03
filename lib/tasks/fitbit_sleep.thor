#!/usr/bin/env ruby
# coding: utf-8

# ref http://blog.mirakui.com/entry/2012/01/19/123155
require File.expand_path('../../../config/application',  __FILE__)
Rails.application.require_environment!

require 'thor'

class FitbitSleep < Thor
  desc 'sleep', 'get sleep time form fitbit api'
  def sleep
    if completed_today
      puts "completed today task"
      return
    end

    fitbit_token = FitbitToken.last

    uri = URI.parse('https://api.fitbit.com/oauth2/token')
    https = Net::HTTP.new(uri.host, uri.port)

    https.use_ssl = true # HTTPSでよろしく
    req = Net::HTTP::Post.new(uri.request_uri)

    refresh_token = fitbit_token&.refresh_token ? fitbit_token.refresh_token : ENV['REFRESH_TOKEN']
    req.set_form_data({'grant_type' => 'refresh_token', 'refresh_token' => refresh_token})
    req['Authorization'] = 'Basic ' + ENV['AUTH']
    req['Content-Type'] = 'application/x-www-form-urlencoded'
    res = https.request(req)

    token_response = JSON.parse(res.body)

    fitbit_token.destroy if fitbit_token
    fitbit_token = FitbitToken.create!(refresh_token: token_response['refresh_token'].to_s)

    # 返却の中身を見てみる
    if Rails.env.development?
      puts "code -> #{res.code}"
      puts "msg -> #{res.message}"
      puts "body -> #{res.body}"
    end

    date = Time.current.strftime("%Y-%m-%d")
    # date = '2018-07-31'
    uri = URI.parse("https://api.fitbit.com/1.2/user/-/sleep/date/#{date}.json")
    https = Net::HTTP.new(uri.host, uri.port)

    https.use_ssl = true # HTTPSでよろしく
    req = Net::HTTP::Post.new(uri.request_uri)

    req['Authorization'] = 'Bearer ' + token_response['access_token'].to_s
    res = https.request(req)

    sleep_response = JSON.parse(res.body)
    
    # 返却の中身を見てみる
    if Rails.env.development?
      puts "code -> #{res.code}"
      puts "msg -> #{res.message}"
      puts "body -> #{res.body}"
    end

    # twitterへ投稿する
    start_time = sleep_response.dig('sleep',0,'startTime')
    end_time = sleep_response.dig('sleep',0,'endTime')

    if start_time.present? && end_time.present?
      post = Time.parse(start_time)&.strftime("%Y年%m月%d日は%H時%M分") + "入眠、" + Time.parse(end_time)&.strftime("%Y月%m日%dは%H時%M分") + "起床"

      uri = URI.parse(ENV['POST_URL'])
      https = Net::HTTP.new(uri.host, uri.port)

      https.use_ssl = true # HTTPSでよろしく
      req = Net::HTTP::Post.new(uri.request_uri)

      req['Content-Type'] = 'application/json'
      req.body = {'value1' => post}.to_json
      res = https.request(req)

      # 返却の中身を見てみる
      if Rails.env.development?
        puts "code -> #{res.code}"
        puts "msg -> #{res.message}"
        puts "body -> #{res.body}"
      end

      TweetLog.create
    end
  end
  no_commands do
    def completed_today
      TweetLog.where('created_at >= ?', Time.current.beginning_of_day).last
    end
  end
end