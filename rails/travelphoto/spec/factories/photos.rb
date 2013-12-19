# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :photo do
    album_id { Album.all.to_a.map(&:id).sample }
    user_id { Album.find(album_id).travel.user.id }
    image { File.open("app/assets/images/rails.png") }
    sequence(:comment){|n| "comment#{n}"}
  end
end
