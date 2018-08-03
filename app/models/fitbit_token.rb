# == Schema Information
#
# Table name: fitbit_tokens
#
#  id            :integer          not null, primary key
#  refresh_token :string
#  access_token  :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class FitbitToken < ApplicationRecord
end
