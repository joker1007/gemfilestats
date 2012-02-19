# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :repository do
    url "https://github.com/joker1007/pasokara_player3"
    username "joker1007"
    name "pasokara_player3"
  end

  factory :repository_seq, :parent => :repository do
    sequence(:url) {|n| "https://github.com/joker1007/repo#{n}"}
    username nil
    name nil
    sequence(:created_at) {|n| Time.now + n}
  end
end
