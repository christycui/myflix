Fabricator(:payment) do
  user { Fabricate(:user) }
  reference_id { 'abc' }
  amount { Faker::Number.number(3) }
end