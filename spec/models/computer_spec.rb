require 'rails_helper'

RSpec.describe Computer, type: :model do
  let!(:producer) { create :producer }
  let(:computer) { create :computer, producer: producer }

  context 'valid parameters' do
    it 'contains all of the parameters' do
      expect(computer).to be_valid
    end
  end

  context 'lack of one parameter' do
    it 'does not contain name' do
      computer.name = nil
      expect(computer).not_to be_valid
      expect(computer.errors).to include :name
      expect(computer.errors[:name][0]).to include 'blank'
    end

    it 'does not contain price' do
      computer.price = nil
      expect(computer).not_to be_valid
      expect(computer.errors).to include :price
      expect(computer.errors[:price][0]).to include 'blank'
    end

    it 'does not contain producer' do
      computer.producer_id = nil
      expect(computer).not_to be_valid
      expect(computer.errors).to include :producer_id
      expect(computer.errors[:producer_id][0]).to include 'blank'
    end
  end

  context 'invalid parameters' do
    it 'contains too long name' do
      computer.name = 'toolongnameaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
      expect(computer).not_to be_valid
      expect(computer.errors).to include :name
      expect(computer.errors[:name][0]).to include 'long'
    end

    it 'contains negative price' do
      computer.price = -1
      expect(computer).not_to be_valid
      expect(computer.errors).to include :price
      expect(computer.errors[:price][0]).to include 'greater'
    end

    it 'contains zero price' do
      computer.price = 0
      expect(computer).not_to be_valid
      expect(computer.errors).to include :price
      expect(computer.errors[:price][0]).to include 'greater'
    end

    it 'contains nonexistent producer' do
      computer.producer_id = 'strange id'
      expect(computer).not_to be_valid
      expect(computer.errors).to include :producer
      expect(computer.errors[:producer][0]).to include 'must exist'
    end
  end
end
