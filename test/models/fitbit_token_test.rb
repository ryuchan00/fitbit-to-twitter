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

require 'test_helper'

class FitbitTokenTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
