#!/usr/bin/env ruby
require File.expand_path('../../../config/application',  __FILE__)
Rails.application.require_environment!

require 'thor'
require 'net/http'
require 'uri'
require 'dotenv'

class FitbitSleep < Thor
  desc 'sleep', 'get sleep time form fitbit api'
  def sleep
    Dotenv.load ".env" if Rails.env.development?

     fitbit_token = FitbitToken.last
     fitbit_token.refresh_token

    uri = URI.parse('https://api.fitbit.com/oauth2/token')
    https = Net::HTTP.new(uri.host, uri.port)

    https.use_ssl = true # HTTPSでよろしく
    req = Net::HTTP::Post.new(uri.request_uri)

    req.set_form_data({'grant_type' => 'refresh_token', 'refresh_token' => 'fbf83605b2adffb725dc8e3accd408e7d64327fbbddfe1e43b8ef3753c4332ce'})
    req['Authorization'] = 'Bearer ' + ENV['AUTH']
    req['Content-Type'] = 'application/x-www-form-urlencoded'

    # 返却の中身を見てみる
    puts "code -> #{res.code}"
    puts "msg -> #{res.message}"
    puts "body -> #{res.body}"

    uri = URI.parse('https://api.fitbit.com/1.2/user/-/sleep/date/2018-07-20.json')
    https = Net::HTTP.new(uri.host, uri.port)

    https.use_ssl = true # HTTPSでよろしく
    req = Net::HTTP::Post.new(uri.request_uri)

    req['Authorization'] = 'Bearer ' + ENV['FITBIT_TOKEN']
    res = https.request(req)
    
    # 返却の中身を見てみる
    puts "code -> #{res.code}"
    puts "msg -> #{res.message}"
    puts "body -> #{res.body}"
  end
end