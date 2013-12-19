# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :album do
    sequence(:title){|n| "album#{n}"}
    travel_id {Travel.all.to_a.map(&:id).sample}
  end
end
