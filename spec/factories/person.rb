FactoryGirl.define do

  factory :person do
    name 'Nat Buckley'
    email 'hi@example.com'
    password 'password'
    password_confirmation 'password'
    confirmed_at Time.now
  end

end
