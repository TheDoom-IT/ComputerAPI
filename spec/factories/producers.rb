FactoryBot.define do

  factory :producer, class: 'Producer' do
    name { "Asus" }
    description { "A company producing PC's" }
  end

  factory :producer2, class: 'Producer' do
    name { "Microsoft" }
    description { "Company" }
  end
end
