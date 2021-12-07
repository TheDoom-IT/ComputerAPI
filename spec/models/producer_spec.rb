require 'rails_helper'

RSpec.describe Producer, type: :model do
  let(:producer) { create :producer }
  let(:producer2) { create :producer2 }

  context 'valid parameters' do
    it 'contains all of the parameters' do
      expect(producer).to be_valid
    end
  end

  context 'lack of one parameter' do
    it 'does not contain name' do
      producer.name = nil

      expect(producer).not_to be_valid
      expect(producer.errors).to include :name
      expect(producer.errors[:name][0]).to include 'blank'
    end
  end

  context 'invalid parameters' do
    it 'contains too long name' do
      producer.name = 'tooLongNameaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'

      expect(producer).not_to be_valid
      expect(producer.errors).to include :name
      expect(producer.errors[:name][0]).to include 'long'
    end

    it 'contains too long description' do
      producer.description = 'tooLongDescriptionaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'

      expect(producer).not_to be_valid
      expect(producer.errors).to include :description
      expect(producer.errors[:description][0]).to include 'long'
    end

    it 'contains not unique name' do
      producer.name = producer2.name

      expect(producer).not_to be_valid
      expect(producer.errors).to include :name
      expect(producer.errors[:name][0]).to include 'taken'
    end
  end
end
