# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :travel do
    sequence(:title){|n| "travel#{n}"}
    startdate Date.today - 3.days
    enddate Date.today
    user_id { User.all.to_a.map(&:id).sample }
  end
end
