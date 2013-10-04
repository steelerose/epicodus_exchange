FactoryGirl.define do 
  factory :post do 
    sequence(:name) { |n| "foobar#{n}" }
    content { "I need help with #{name} please!" }
    user
  end

  factory :answer do 
    sequence(:content) { |n| "foobar#{n} solution" }
    sequence(:user_id) { |n| n }
    post
    user
  end

  factory :comment do 
    sequence(:content) { |n| "response to foobar#{n} solution" }
    answer
    user
  end

  factory :user do
    sequence(:email) { |n| "stevefoo#{n}@example.com" }
    password 'foobarbaz'
    password_confirmation 'foobarbaz'
    first_name 'Steve'
    last_name 'Foo'
    github 'foosy'
    website 'http://foosforall.com'
  end
end