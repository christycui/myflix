Fabricator(:review) do
  rating { (1..5).to_a.sample }
  body { Faker::Lorem.paragraphs(3).join("\n") }
end