FactoryBot.define do
  factory :computer, class: Computer do
    name { "Asus 2000 GX" }
    producer { Producer.find_by(name: "Asus") }
    price { 100.00 }
  end

  factory :computer2, class: Computer do
    name { "Microsoft Plus" }
    producer { Producer.find_by(name: "Microsoft") }
    price { 2000 }
  end
end
