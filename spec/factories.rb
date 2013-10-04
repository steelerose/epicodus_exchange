FactoryGirl.define do 
  factory :post do 
    sequence(:name) { |n| "foobar#{n}" }
    content { "I need help with #{name} please!" }
    sequence(:user_id) { |n| n }
  end

  factory :answer do 
    sequence(:content) { |n| "foobar#{n} solution" }
    sequence(:user_id) { |n| n }
    post_id 1
  end
end