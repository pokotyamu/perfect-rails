# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    provider 'twitter'
    sequence(:uid) { |i| "uid#{i}" }
    sequence(:nickname) { |i| "nickname#{i}" }
    sequence(:image_url) { |i| "http://example.com/image#{i}.jpg" }
  end
end