class CreateTweetLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :tweet_logs do |t|

      t.timestamps
    end
  end
end
