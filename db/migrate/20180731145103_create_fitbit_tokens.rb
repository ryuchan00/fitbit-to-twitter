class CreateFitbitTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :fitbit_tokens do |t|
      t.string :refresh_token
      t.string :access_token

      t.timestamps
    end
  end
end
