FactoryGirl.define do
  factory :tenant do
    sequence(:name) { |n| "Spectre#{n}" }
    organization { "#{name.downcase}" }
  end

  factory :terminal do
    sequence(:name) { |n| "terminal#{n}" }
  end

  factory :device do
    sequence(:imei) { |n| "#{n}" }
    os "Android"
    sequence(:phone) { |n| "1234-44#{n}"}
    owner "Spectre"
    model "Moto G"
    current false
  end
end
