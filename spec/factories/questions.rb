FactoryBot.define do
  factory :question do
    title { FFaker::Lorem.phrase }
    kind { Question::kinds.to_a.sample[0] }
    form
  end
end
