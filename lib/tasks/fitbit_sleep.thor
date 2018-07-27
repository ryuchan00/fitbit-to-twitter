require 'net/http'
require 'uri'
require 'dotenv'

class FitbitSleep < Thor
  desc 'sleep', 'get sleep time form fitbit api'
  def sleep
    Dotenv.load ".env"
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