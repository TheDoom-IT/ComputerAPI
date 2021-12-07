# require 'rails_helper'
#
# RSpec.describe User, type: :model do
#   before do
#     @user = User.new(name: 'Dawid',
#                      email: 'example@example.com',
#                      password: 'passwd',
#                      password_confirmation: 'passwd')
#   end
#
#   context 'valid parameters' do
#     it 'valid user' do
#       expect(@user.valid?).to be_truthy
#     end
#   end
#
#   context 'invalid parameters' do
#     it 'invalid email' do
#       @user.email = 'example.example.com'
#       expect(@user.valid?).not_to be_truthy
#     end
#
#     it 'short password' do
#       @user.password = 'short'
#       @user.password_confirmation = 'short'
#       expect(@user.valid?).not_to be_truthy
#     end
#
#     it 'confirmation does not match' do
#       @user.password = 'other passwd'
#       expect(@user.valid?).not_to be_truthy
#     end
#   end
# end
