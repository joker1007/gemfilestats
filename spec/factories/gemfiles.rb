# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :gemfile do
    body { File.read(File.join(Rails.root, "spec", "Gemfile")) }
    repository
  end
end
