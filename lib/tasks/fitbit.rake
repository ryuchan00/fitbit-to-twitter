namespace :fitbit do
    desc "Users中confirm_atから１週間が経過していれば削除" #=> 説明

    # $ rake inactive_user:destroy_unconfirmed のように使う
    # :environmentは超大事。ないとモデルにアクセスできない

    task :destroy_unconfirmed => :environment do 
        p Rails.env
        p FitbitToken.new
    end    
end
