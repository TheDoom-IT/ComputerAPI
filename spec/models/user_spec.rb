require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create :user }
  let(:user2) { create :user, key: 'another key', email: 'anotheremail@example.com' }

  context 'valid parameters' do
    it 'contains valid parameters' do
      expect(user).to be_valid
    end
  end

  context 'lack of one parameter' do
    it 'does not contain name' do
      user.name = nil
      expect(user).not_to be_valid
      expect(user.errors).to include :name
      expect(user.errors[:name][0]).to include 'blank'
    end

    it 'does not contain email' do
      user.email = nil
      expect(user).not_to be_valid
      expect(user.errors).to include :email
      expect(user.errors[:email][0]).to include 'blank'
    end

    it 'does not contain key' do
      user.key = nil
      expect(user).not_to be_valid
      expect(user.errors).to include :key
      expect(user.errors[:key][0]).to include 'blank'
    end

    it 'does not contain password' do
      user.password = nil
      expect(user).not_to be_valid
      expect(user.errors).to include :password
      expect(user.errors[:password][0]).to include 'blank'
    end
  end

  context 'invalid parameters' do
    it 'contains too long name' do
      user.name = 'tooLongNameeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee'
      expect(user).not_to be_valid
      expect(user.errors).to include :name
      expect(user.errors[:name][0]).to include 'long'
    end

    it 'contains too long email' do
      user.email = ''
      300.times do
        user.email += '1'
      end

      expect(user).not_to be_valid
      expect(user.errors).to include :email
      expect(user.errors[:email][0]).to include 'long'
    end

    it 'contains invalid email' do
      user.email = 'invalid email'
      expect(user).not_to be_valid
      expect(user.errors).to include :email
      expect(user.errors[:email][0]).to include 'invalid'
    end

    it 'contains not unique email' do
      user.email = user2.email
      expect(user).not_to be_valid
      expect(user.errors).to include :email
      expect(user.errors[:email][0]).to include 'taken'
    end

    it 'contains not unique key' do
      user.key = user2.key
      expect(user).not_to be_valid
      expect(user.errors).to include :key
      expect(user.errors[:key][0]).to include 'taken'
    end

    it 'contains too short password' do
      user.password = 'short'
      user.password_confirmation = 'short'
      expect(user).not_to be_valid
      expect(user.errors).to include :password
      expect(user.errors[:password][0]).to include 'short'
    end

    it 'contains wrong password_confirmation' do
      user.password_confirmation = 'different password'
      expect(user).not_to be_valid
      expect(user.errors).to include :password_confirmation
      expect(user.errors[:password_confirmation][0]).to include 'match'
    end
  end
end
